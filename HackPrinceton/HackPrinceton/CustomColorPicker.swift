//
//  CustomColorPicker.swift
//  HackPrinceton
//
//  Created by Brayton Lordianto on 4/1/23.
//

import SwiftUI

struct CustomColorPickerSample: View {
    @State private var selectedColor = Color.blue
    @State var isDraw = false
       var body: some View {
           ZStack {
               CustomColorPicker(selectedColor: $selectedColor, isDraw: $isDraw)
                   .padding()
           }
           .frame(maxWidth: .infinity, maxHeight: .infinity)
       }
}

struct CanvasMenu: View {
    @Binding var toolSelection: tool
    
    var body: some View {
        VStack(alignment: .center) {
            Text("Brush Color")
                .fontWeight(.black)
            CustomColorPickerSample()
            
            Text("Tools")
                .fontWeight(.black)
            
        }
        .padding(30)
        .frame(width: 135, height: 585)
        .background {
            RoundedRectangle(cornerRadius: 10)
                .foregroundColor(Color("MenuColor"))
        }
    }
    
    func singleTool(label: String, imageName: String) -> some View {
        VStack {
            Image(systemName: imageName)
            Text(label)
        }
    }
    
    func toolSection() -> some View {
        VStack {
            singleTool(label: "pen", imageName: "pencil.tip")
            HStack {
                singleTool(label: "whole eraser", imageName: "eraser")
                singleTool(label: "partial eraser", imageName: "eraser.dotted")
            }
        }
    }
}

struct CustomColorPicker: View {
    @Binding var selectedColor: Color
    @Binding var isDraw: Bool
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
                            .frame(width: 50, height: 50)
                            .overlay(
                                Circle()
                                    .stroke(Color.white, lineWidth: self.selectedColor == color ? 3 : 0)
                            )
                    }.accentColor(color)
                }
            }
            .padding()
        }
    }
}

struct CustomColorPickerSample_Previews: PreviewProvider {
    static var previews: some View {
        CustomColorPickerSample()
    }
}
