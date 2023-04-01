//
//  ResultImage.swift
//  HackPrinceton
//
//  Created by Brayton Lordianto on 4/1/23.
//

import SwiftUI
import FirebaseStorage

struct ResultImage: View {
    @Binding var lastURL: String
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
            .onAppear {
                
            }
    }
    
    func pollServer() {
        // get the url
        var url = ""
        
        // get the url that is there
        // once you get it,
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

struct ResultImage_Previews: PreviewProvider {
    static var previews: some View {
        ResultImage()
    }
}
