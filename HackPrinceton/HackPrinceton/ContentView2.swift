//
//  ContentView2.swift
//  HackPrinceton
//
//  Created by Brayton Lordianto on 4/1/23.
//

import SwiftUI
import PencilKit

struct ContentView2: View {
    @State var canvas = PKCanvasView()
    @State var isDraw = true
    @State var color = Color.white
    @State var drawingTool: tool = .pen
    @State var showingSecondScreen = false
    @State var lastURL = ""
    @State var showScreen = false
    var body: some View {
        HStack {
            DrawingView(canvas: $canvas, isDraw: $isDraw, color: $color, drawingTool: $drawingTool)
            SideCommitView(canvas: $canvas, isDraw: $isDraw, color: $color, drawingTool: $drawingTool, showingSecondScreen: $showingSecondScreen, showScreen: $showScreen)
                .frame(width: 400)
        }
        .ignoresSafeArea()
    }
}

struct ContentView2_Previews: PreviewProvider {
    static var previews: some View {
        ContentView2()
    }
}
