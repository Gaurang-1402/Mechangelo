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
            .background(Color("CustomTeal"))
            .foregroundColor(.black)
            .cornerRadius(10)
            .scaleEffect(configuration.isPressed ? 1.2 : 1)
            .animation(.easeOut(duration: 0.2), value: configuration.isPressed)
    }
}

struct SideCommitView: View {
    @Binding var canvas: PKCanvasView
    var body: some View {
        ZStack {
            Color("MenuColor")
            VStack {
                Image("MenuLogo")
                    .resizable()
                    .scaledToFit()
                    .aspectRatio(contentMode: .fit)
                    .padding(.vertical,50)
                    .padding(.horizontal, 10)
                
                Spacer()
                Button {
                    
                } label: {
                    Text("Upload Image")
                }
                .padding(50)
                .buttonStyle(GrowingButton())
                
                commitButton()
                .padding(50)
                .buttonStyle(GrowingButton())
                .padding(.bottom, 100)
                
            }
        }
        .ignoresSafeArea()
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
            
        } label: {
            VStack {
                Image(systemName: "square.and.arrow.up.fill")
                Text("Draw My \nLight Painting!")
                    .fixedSize(horizontal: false, vertical: true)

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

struct SideCommitView_Previews: PreviewProvider {
    static var previews: some View {
        SideCommitView(canvas: .constant(PKCanvasView()))
    }
}
