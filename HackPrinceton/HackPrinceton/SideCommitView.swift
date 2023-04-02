//
//  SideCommitView.swift
//  HackPrinceton
//
//  Created by Brayton Lordianto on 4/1/23.
//

import SwiftUI
import PencilKit
import FirebaseStorage

struct GrowingButton: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding()
            .frame(width: 285)
            .background(Color("MenuColor"))
//            .foregroundColor(.black)
            .cornerRadius(10)
            .scaleEffect(configuration.isPressed ? 1.2 : 1)
            .animation(.easeOut(duration: 0.2), value: configuration.isPressed)
            .padding(.bottom, 10)
            .glow(color: .blue, radius: 1)

    }
}
extension View {
    func glow(color: Color = .blue, radius: CGFloat = 20) -> some View {
        self
            .shadow(color: color, radius: radius / 3)
            .shadow(color: color, radius: radius / 3)
            .shadow(color: color, radius: radius / 3)
    }
}
struct SideCommitView: View {
    
    @Binding var canvas: PKCanvasView
    @Binding var isDraw: Bool
    @Binding var color: Color
    @Binding var drawingTool: tool
    @Binding var showingSecondScreen: Bool
    @State var showingImagePicker: Bool = false
    @State var uploadedImage: UIImage? = nil
    @State var showingAlert = false
    @Binding var showScreen: Bool

    var body: some View {
        ZStack {
            Color("CustomBrown")
            VStack {
                
                Image("MenuLogo")
                    .resizable()
                    .scaleEffect(0.8)
                    .scaledToFit()
                    .aspectRatio(contentMode: .fit)
                    .padding(.vertical,5)
                    .padding(.horizontal, 10)
                    .glow(color: .white)
                    .glow(color: .red)
                    .offset(x: -20)

                CanvasMenu(toolSelection: $drawingTool, color: $color, canvas: $canvas)
                    .padding(.leading)
                    .padding(.bottom)
//                    .glow(color: .red)
                    .glow(color: .blue)
                    .offset(x: -20)
                
                uploadButton()
                    .glow()
                    .buttonStyle(GrowingButton())
                
                commitButton()
                    .buttonStyle(GrowingButton())
                    .glow()
                
            }
        }
        .ignoresSafeArea()
        .onChange(of: uploadedImage) { newValue in
            guard let newValue else { return }
            showScreen = true
            uploadImage(image: newValue)
        }
        .popover(isPresented: $showingImagePicker) {
            ImagePicker(image: $uploadedImage)
        }
        .alert("Let There Be Light!", isPresented: $showingAlert, actions: {}, message: {Text("Your image is uploaded. All that's left is your light painting.")})
    }
    
    func loadImage() {
        guard let uploadedImage else { return }
        
    }
    
    func uploadButton() -> some View {
        Button {
            showingImagePicker.toggle()
        } label: {
            Text("Light an uploaded image ✨")
                .underline()
                .fontWeight(.heavy)
                .glow(color: .red)
                .fontWeight(.heavy)
                .foregroundColor(.white)
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

            // send to firestore
            uploadImage(image: image)
            
            // signal the alert
//            showingAlert.toggle()
            
            // start listening for the resulting image
            showingSecondScreen.toggle()
            showScreen.toggle()
            
        } label: {
            VStack {
                Text("Light my drawing 🔥")
                    .underline()
                    .fontWeight(.heavy)
                    .glow(color: .red)
                    .fixedSize(horizontal: false, vertical: true)
                    .foregroundColor(.white)

            }
        }
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

//struct SideCommitView_Previews: PreviewProvider {
//    static var previews: some View {
//        SideCommitView(canvas: .constant(PKCanvasView()))
//    }
//}
