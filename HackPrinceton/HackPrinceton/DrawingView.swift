//
//  DrawingView.swift
//  HackPrinceton
//
//  Created by Brayton Lordianto on 3/31/23.
//

import SwiftUI
import PencilKit
import Firebase
import FirebaseStorage

struct DrawingView: View {
    @State var canvas = PKCanvasView()
    @State var isDraw = true
    @State var color = Color.black
    @State var inkTool: PKInkingTool.InkType = .pen
    
    let types: [PKInkingTool.InkType] = [.pencil, .pen, .marker]
    let names = ["Pencil", "Pen", "Marker"]
    let imageNames = ["pencil", "pencil.tip", "highlighter"]
    
    var body: some View {
        NavigationStack {
            
            DrawingViewRepresentable(canvas: $canvas, isDraw: $isDraw, inkTool: $inkTool, color: $color)
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItemGroup(placement: .navigationBarLeading) {
                        commitButton()
                    }
                    
                    ToolbarItemGroup(placement: .navigationBarTrailing) {
                        HStack {
                            clearButton()
                            currentModeButton()
                            colorPicker()
                            menu()
                        }
                    }
                }
                .navigationTitle("Drawing")
        }
    }
    
    func clearButton() -> some View {
        Button {
            canvas.drawing = PKDrawing()
        } label: {
            Text("CLEAR")
                .foregroundColor(.red)
        }

    }
    
    func commitButton() -> some View {
        Button {
            // type UIImage
            let image = canvas.drawing.image(from: canvas.drawing.bounds, scale: 1)
            
            // send to firestore
            uploadImage(image: image)
            
        } label: {
            VStack {
                Image(systemName: "square.and.arrow.up.fill")
                Text("Draw My \nLight Painting!")
                    .fixedSize(horizontal: false, vertical: true)

            }
        }
    }
    
    func currentModeButton() -> some View {
        Button {
            isDraw.toggle()
        } label: {
            let imageName = isDraw ? "eraser" : "pencil"
            let text = isDraw ? "eraser" : "pencil"
            return AnyView(VStack {
                Image(systemName: imageName)
                Text(text)
            })
        }
    }
    
    func colorPicker() -> some View {
        ColorPicker(selection: $color) {
            Label {
                Text("Color")
            } icon: {
                Image(systemName: "eyedropper.fill")
            }
        }
    }
    
    func menu() -> some View {
        Menu {
            ForEach(0..<3) { idx in
                Button(action: {switchToTool(types[idx])}) {
                    Label {
                        Text(names[idx])
                    } icon: {
                        Image(systemName: imageNames[idx])
                    }
                }
            }
        } label : {
            VStack {
                Image(systemName: "menubar.rectangle")
                Text("menu")
            }
        }
    }
    
    func switchToTool(_ tool : PKInkingTool.InkType) {
        isDraw = true
        inkTool = tool
    }
    
    func uploadImage(image: UIImage) {
        let storageRef = Storage.storage().reference()
        let imageData = image.jpegData(compressionQuality: 0.8)
        guard let imageData = imageData else { return }
        let fileRef = storageRef.child("image.jpg")
        let metadata = StorageMetadata()
        metadata.contentType = ".jpg"
        
        storageRef.listAll { (result, error) in
            if let error {
                uploadImageWithoutDeleting(image)
                print("Error listing files: \(error.localizedDescription)")
                return
            }
            let deleteGroup = DispatchGroup()
            guard let result else {
                print("DEBUG: no files to delete")
                return
            }
            print(result.items)
            for file in result.items {
                deleteGroup.enter()
                file.delete(completion: { error in
                    if let error = error {
                        print("Error deleting file: \(error.localizedDescription)")
                    }
                    deleteGroup.leave()
                })
            }
            deleteGroup.notify(queue: .main) {
                // Upload the new image
                fileRef.putData(imageData, metadata: metadata) { (metadata, error) in
                    if let error = error {
                        print("Error uploading file: \(error.localizedDescription)")
                        return
                    }
                    print("Image uploaded successfully!")
                }
            }
        }

    }
    
    func uploadImageWithoutDeleting(_ image: UIImage) {
        let storageRef = Storage.storage().reference()
        let imageData = image.jpegData(compressionQuality: 0.8)
        guard let imageData = imageData else { return }
        let fileRef = storageRef.child("\(UUID().uuidString).jpg")
        let metadata = StorageMetadata()
        metadata.contentType = ".jpg"
        fileRef.putData(imageData, metadata: metadata) { metadata, error in
            // optinoally add to the database. this is the completion func.
            print("DEBUG: sent image data.")
        }
    }

    
    
}

struct DrawingViewRepresentable : UIViewRepresentable {
    
    var canvas: Binding<PKCanvasView>
    var isDraw: Binding<Bool>
    var inkTool: Binding<PKInkingTool.InkType>
    var color: Binding<Color>
    
    
    var ink: PKInkingTool {
        PKInkingTool(inkTool.wrappedValue, color: UIColor(color.wrappedValue))
    }

    let eraser = PKEraserTool(.bitmap)
    
    func makeUIView(context: Context) -> PKCanvasView {
        canvas.wrappedValue.drawingPolicy = .anyInput
        canvas.wrappedValue.tool = isDraw.wrappedValue ? ink : eraser
        return canvas.wrappedValue
    }
    
    func updateUIView(_ uiView: PKCanvasView, context: Context) {
        uiView.tool = isDraw.wrappedValue ? ink : eraser
    }
    
}

struct DrawingView_Previews: PreviewProvider {
    static var previews: some View {
            DrawingView()
    }
}
