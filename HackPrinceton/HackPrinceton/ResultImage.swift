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
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

    var body: some View {
        VStack {
            EmptyView()
            if let url = URL(string: lastURL) {
                AsyncImage(url: URL(string: lastURL), content: { image in
                    image
                }, placeholder: {
                    Text("placeholder")
                })
            }
        }
        .onReceive(timer) { _ in
            print("timer fired")
            pollServer()

            if !keepPolling {
                timer.upstream.connect().cancel()
            }
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
        }
    }
}
//
//struct ResultImage_Previews: PreviewProvider {
//    static var previews: some View {
//        ResultImage()
//    }
//}
