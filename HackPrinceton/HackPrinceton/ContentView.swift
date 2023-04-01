//
//  ContentView.swift
//  HackPrinceton
//
//  Created by Brayton Lordianto on 3/31/23.
//

import SwiftUI
import PencilKit
import FirebaseStorage
 



struct ContentView: View {
    @State var canvas = PKCanvasView()
    @State var isDraw = true
    @State var color = Color.white
    @State var drawingTool: tool = .pen
    @State var showingSecondScreen = false
    @State var lastURL = ""
    var body: some View {
        HStack {
            DrawingView(canvas: $canvas, isDraw: $isDraw, color: $color, drawingTool: $drawingTool)
            SideCommitView(canvas: $canvas, isDraw: $isDraw, color: $color, drawingTool: $drawingTool, showingSecondScreen: $showingSecondScreen)
                .frame(width: 300)
        }
        .ignoresSafeArea()
        .fullScreenCover(isPresented: $showingSecondScreen) {
            ResultImage(lastURL: $lastURL)
        }
        .onAppear {
            // get the url and store it in lastURL=
            initialzeURL()
        }
    }
    
    func initialzeURL() {
        print("DEBUG: polling server")
        let storageRef = Storage.storage().reference()
        storageRef.listAll { (result, error) in
            if let error { print("Error listing files: \(error.localizedDescription)"); return }
            guard let result else {print("DEBUG: no file");return}
            let pollGroup = DispatchGroup()
            for file in result.items {
                pollGroup.enter()
                print("DEBUG: " + file.name)
                if file.name == "output.jpg" {
                    file.downloadURL { url, error in
                        if let error { print("DEBUG: \(error)")}
                        guard let url else { print("DEBUG: no url"); return }
                        
                        // you have the url where you want it to be
                        print("DEBUG: \(url.absoluteString) \(lastURL)")
                        lastURL = url.absoluteString
                    }
                }
            }
        }
    }
    
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
