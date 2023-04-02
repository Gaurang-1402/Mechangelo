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
    @State var showingAlert = false
    @State var imagesToSave = [Image("")]
    @State var keepPolling = true
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    var body: some View {
        HStack {
            DrawingView(canvas: $canvas, isDraw: $isDraw, color: $color, drawingTool: $drawingTool)
            SideCommitView(canvas: $canvas, isDraw: $isDraw, color: $color, drawingTool: $drawingTool, showingSecondScreen: $showingSecondScreen)
                .frame(width: 300)
        }
        .ignoresSafeArea()
//        .fullScreenCover(isPresented: $showingSecondScreen) {
//            ResultImage(lastURL: $lastURL)
//        }
        .onAppear {
            // get the url and store it in lastURL=
            initialzeURL()
        }
        .alert("Lights On!", isPresented: $showingAlert, actions: {
            Button("Save to Photos", role: .cancel) {
                for image in imagesToSave {
                    let uiimage = image.asUIImage()
                    UIImageWriteToSavedPhotosAlbum(uiimage, nil, nil, nil);
                }
            }
            .disabled(keepPolling)
            Button("Cancel", role: .cancel, action: {})
        }) {
            ScrollView(.horizontal) {
                ResultImage(lastURL: $lastURL, keepPolling: $keepPolling)
            }
        }
        .onReceive(timer) { _ in
            print("timer fired")
            if !showingSecondScreen { return }
            if !showingAlert { showingAlert = true }
            pollServer()

            if !keepPolling {
                timer.upstream.connect().cancel()
            }
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


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}


extension View {
// This function changes our View to UIView, then calls another function
// to convert the newly-made UIView to a UIImage.
    public func asUIImage() -> UIImage {
        let controller = UIHostingController(rootView: self)
        
        controller.view.frame = CGRect(x: 0, y: CGFloat(Int.max), width: 1, height: 1)
        UIApplication.shared.windows.first!.rootViewController?.view.addSubview(controller.view)
        
        let size = controller.sizeThatFits(in: UIScreen.main.bounds.size)
        controller.view.bounds = CGRect(origin: .zero, size: size)
        controller.view.sizeToFit()
        
// here is the call to the function that converts UIView to UIImage: `.asUIImage()`
        let image = controller.view.asUIImage()
        controller.view.removeFromSuperview()
        return image
    }
}

extension UIView {
// This is the function to convert UIView to UIImage
    public func asUIImage() -> UIImage {
        let renderer = UIGraphicsImageRenderer(bounds: bounds)
        return renderer.image { rendererContext in
            layer.render(in: rendererContext.cgContext)
        }
    }
}
