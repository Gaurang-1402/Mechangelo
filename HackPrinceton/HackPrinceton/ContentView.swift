//
//  ContentView.swift
//  HackPrinceton
//
//  Created by Brayton Lordianto on 3/31/23.
//

import SwiftUI
import PencilKit

struct ContentView: View {
    @State var canvas = PKCanvasView()
    @State var isDraw = true
    @State var color = Color.white
    @State var drawingTool: tool = .pen
    var body: some View {
        HStack {
            DrawingView(canvas: $canvas, isDraw: $isDraw, color: $color, drawingTool: $drawingTool)
            SideCommitView(canvas: $canvas)
                .frame(width: 300)
        }
        .ignoresSafeArea()
        //       CanvasMenu()
            
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
