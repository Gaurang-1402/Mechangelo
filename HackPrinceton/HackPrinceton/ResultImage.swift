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
    @State var keepPolling = true
    @State var timer = Timer()
    var body: some View {
        VStack {
            Text("")
            if let url = URL(string: lastURL) {
                AsyncImage(url: URL(string: lastURL), content: { image in
                    image
                }, placeholder: {
                    Text("placeholder")
                })
            }
        }
        .onAppear {
            print("link is \(lastURL)")
            Timer.init(timeInterval: 1.0, repeats: true, block: { (timer) in
                print("\n--------------------TIMER FIRED--------------\n")
//                pollServer()

//                if !keepPolling {
//                    timer.invalidate()
//                }
            })
        }
    }
    
    
    func pollServer() {
        // get the url
        print("DEBUG: polling server")
        let storageRef = Storage.storage().reference()
        storageRef.listAll { (result, error) in
            if let error { print("Error listing files: \(error.localizedDescription)"); return }
            guard let result else {print("DEBUG: no file");return}
            let pollGroup = DispatchGroup()
            for file in result.items {
                pollGroup.enter()
                if file.name == "output.jpg" {
                    file.downloadURL { url, error in
                        if let error { print("DEBUG: \(error)")}
                        guard let url else { print("DEBUG: no url"); return }
                        
                        // you have the url where you want it to be
                        print("DEBUG: \(url.absoluteString) \(lastURL)")
                        if url.absoluteString != lastURL {
                            lastURL = url.absoluteString
                            keepPolling = false
                        }
                    }
                }
            }
            pollGroup.notify(queue: .main) {
                // Upload the new image
                //                fileRef.putData(imageData, metadata: metadata) { (metadata, error) in
                //                    if let error = error {
                //                        print("Error uploading file: \(error.localizedDescription)")
                //                        return
                //                    }
                //                    print("Image uploaded successfully!")
                //                }
            }
        }
        var url = ""
        
        // get the url that is there
        // once you get it,
        //        let imageData = image.jpegData(compressionQuality: 0.8)
        //        guard let imageData = imageData else { return }
        //        let fileRef = storageRef.child("\(UUID().uuidString).jpg")
        //        let metadata = StorageMetadata()
        //        metadata.contentType = ".jpg"
        //        fileRef.putData(imageData, metadata: metadata) { metadata, error in
        //            // optinoally add to the database. this is the completion func.
        //            print("DEBUG: sent image data.")
        //        }
    }
}
//
//struct ResultImage_Previews: PreviewProvider {
//    static var previews: some View {
//        ResultImage()
//    }
//}
