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
    @Binding var keepPolling: Bool
    @Environment(\.dismiss) var dismiss

    var body: some View {
        VStack {
            EmptyView()
            
            if URL(string: lastURL) == nil && !keepPolling {
                AsyncImage(url: URL(string: lastURL), content: { image in
                    image
                }, placeholder: {
                    Text("placeholder")
                })
            } else {
                ProgressView()
            }
                
            Button {
                dismiss.callAsFunction()
            } label: {
                Text("X")
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
