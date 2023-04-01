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
        .onAppear {
            // get the url and store it in lastURL
            
        }
    }
    
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
