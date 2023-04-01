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
    var body: some View {
        HStack {
            DrawingView(canvas: $canvas)
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
