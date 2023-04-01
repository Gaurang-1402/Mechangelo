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

enum tool {
case partialEraser
case wholeEraser
case pen
}

struct DrawingView: View {
    @State var canvas = PKCanvasView()
    @State var isDraw = true
    @State var color = Color.white
//    @State var inkTool: PKInkingTool.InkType = .pen
    @State var drawingTool: tool = .pen
    
    let types: [PKInkingTool.InkType] = [.pencil, .pen, .marker]
    let names = ["Pencil", "Pen", "Marker"]
    let imageNames = ["pencil", "pencil.tip", "highlighter"]
    
    var body: some View {
        NavigationStack {
            ZStack(alignment: .leading) {
                DrawingViewRepresentable(canvas: $canvas, isDraw: $isDraw, color: $color, drawingTool: $drawingTool)
                    .navigationBarTitleDisplayMode(.inline)
                    .navigationTitle("Drawing")
                CanvasMenu(toolSelection: $drawingTool, color: $color, canvas: $canvas)
                    .padding(.leading)
                commitButton()
            }
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
            // Create a new graphics context with a black background color
            UIGraphicsBeginImageContextWithOptions(canvas.bounds.size, false, 1.0)
            let context = UIGraphicsGetCurrentContext()!
            context.setFillColor(UIColor.black.cgColor)
            context.fill(canvas.bounds)

            // Draw the canvas image onto the context
            canvas.drawing.image(from: canvas.bounds, scale: 1).draw(in: canvas.bounds)

            // Get the resulting image from the context
            let image = UIGraphicsGetImageFromCurrentImageContext()!

            // End the context
            UIGraphicsEndImageContext()

            // type UIImage
//            let image = canvas.drawing.image(from: canvas.bounds, scale: 1)
//            image(from: canvas.drawing.bounds, scale: 1)
            
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
    
//    func menu() -> some View {
////        Menu {
////            ForEach(0..<3) { idx in
////                Button(action: {switchToTool(types[idx])}) {
////                    Label {
////                        Text(names[idx])
////                    } icon: {
////                        Image(systemName: imageNames[idx])
////                    }
////                }
////            }
////        } label : {
////            VStack {
////                Image(systemName: "menubar.rectangle")
////                Text("menu")
////            }
////        }
//    }
    
    func switchToTool(_ newTool: tool) {
        drawingTool = newTool
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
//    var inkTool: Binding<PKInkingTool.InkType>
    var color: Binding<Color>
    var drawingTool: Binding<tool>
    
    
    var ink: PKInkingTool {
        PKInkingTool(.pen, color: UIColor(color.wrappedValue))
    }

    let partialEraser = PKEraserTool(.bitmap)
    let wholeEraser = PKEraserTool(.vector)
    
    func makeUIView(context: Context) -> PKCanvasView {
        canvas.wrappedValue.backgroundColor = .black
        canvas.wrappedValue.drawingPolicy = .anyInput
        if drawingTool.wrappedValue == .pen {
            canvas.wrappedValue.tool = ink
        } else if drawingTool.wrappedValue == .partialEraser {
            canvas.wrappedValue.tool = partialEraser
        } else {
            canvas.wrappedValue.tool = wholeEraser
        }
        
        return canvas.wrappedValue
    }
    
    func updateUIView(_ uiView: PKCanvasView, context: Context) {
        if drawingTool.wrappedValue == .pen {
            canvas.wrappedValue.tool = ink
        } else if drawingTool.wrappedValue == .partialEraser {
            canvas.wrappedValue.tool = partialEraser
        } else {
            canvas.wrappedValue.tool = wholeEraser
        }
    }
    
}

struct DrawingView_Previews: PreviewProvider {
    static var previews: some View {
            DrawingView()
    }
}

/*
 //                .toolbar {
 //                    ToolbarItemGroup(placement: .navigationBarLeading) {
 //                        commitButton()
 //                    }
 //
 //                    ToolbarItemGroup(placement: .navigationBarTrailing) {
 //                        HStack {
 //                            clearButton()
 //                            currentModeButton()
 //                            CustomColorPicker(selectedColor: $color, isDraw: $isDraw)
 //                            menu()
 //                        }
 //                    }
 //                }

 */
