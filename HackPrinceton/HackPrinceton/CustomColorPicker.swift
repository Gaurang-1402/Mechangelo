//
//  CustomColorPicker.swift
//  HackPrinceton
//
//  Created by Brayton Lordianto on 4/1/23.
//

import SwiftUI

struct CustomColorPickerSample: View {
    @State private var selectedColor = Color.blue
    @State var isDraw: tool = .pen
       var body: some View {
           ZStack {
               CustomColorPicker(selectedColor: $selectedColor, drawingTool: $isDraw)
                   .padding()
           }
           .frame(maxWidth: .infinity, maxHeight: .infinity)
       }
}

struct CanvasMenu: View {
    @Binding var toolSelection: tool
    @Binding var color: Color
    
    var body: some View {
        VStack(alignment: .center) {
            Text("Brush Color")
                .fontWeight(.black)
            HStack(spacing: 0) {
                CustomColorPicker(selectedColor: $color, drawingTool: $toolSelection)
                CustomColorPicker(selectedColor: $color, drawingTool: $toolSelection)
            }
            
            Text("Tools")
                .fontWeight(.black)
            toolSection()
        }
        .padding(30)
        .frame(width: 135)
        .background {
            RoundedRectangle(cornerRadius: 10)
                .foregroundColor(Color("MenuColor"))
        }
    }
    
    func singleTool(label: String, imageName: String, associatedTool: tool) -> some View {
        Button(action: {
            toolSelection = associatedTool
        }) {
            VStack {
                Image(systemName: imageName)
                Text(label)
            }
        }
    }
    
    func toolSection() -> some View {
        VStack {
            singleTool(label: "pen", imageName: "pencil.tip", associatedTool: .pen)
            singleTool(label: "whole eraser", imageName: "circle", associatedTool: .wholeEraser)
            singleTool(label: "partial eraser", imageName: "eraser", associatedTool: .partialEraser)
        }
    }
}

struct CustomColorPicker: View {
    @Binding var selectedColor: Color
    @Binding var drawingTool: tool
    let colors: [Color] = [.white,
                           .purple,
                           .red,
                           .orange,
                           .yellow,
                           .green,
                           .blue]
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            VStack(spacing: 20) {
                ForEach(colors, id: \.self) { color in
                    Button(action: {
                        self.selectedColor = color
                    }) {
                        Image(systemName: self.selectedColor == color ? "checkmark.circle.fill" : "circle.fill")
                            .resizable()
                            .frame(width: 30, height: 30)
                            .overlay(
                                Circle()
                                    .stroke(Color.white, lineWidth: self.selectedColor == color ? 3 : 0)
                            )
                    }.accentColor(color)
                }
            }
        }
    }
}

struct CustomColorPickerSample_Previews: PreviewProvider {
    static var previews: some View {
        CustomColorPickerSample()
    }
}
