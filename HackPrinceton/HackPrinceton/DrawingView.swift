//
//  DrawingView.swift
//  HackPrinceton
//
//  Created by Brayton Lordianto on 3/31/23.
//

import SwiftUI
import PencilKit


struct DrawingView: View {
    @State var canvas = PKCanvasView()
    @State var isDraw = true
    @State var color = Color.black
    var body: some View {
        NavigationStack {
            
            DrawingViewRepresentable(canvas: $canvas, isDraw: $isDraw)
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItemGroup(placement: .navigationBarLeading) {
                        saveButton()
                    }
                    
                    ToolbarItemGroup(placement: .navigationBarTrailing) {
                        HStack {
                            currentModeButton()
                            menu()
                        }
                    }
                }
                .navigationTitle("Drawing")
        }
        
    }
    
    func saveButton() -> some View {
        Button {
        } label: {
            VStack {
                Image(systemName: "square.and.arrow.up.fill")
                Text("Share")
            }
        }
    }
    
    func currentModeButton() -> some View {
        Button {
            isDraw.toggle()
        } label: {
            let imageName = isDraw ? "eraser" : "pencil"
            let text = isDraw ? "eraser" : "pencil"
            return AnyView(VStack {
                Image(systemName: imageName)
                Text(text)
            })
        }
    }
    
    func menu() -> some View {
        Menu {
            ColorPicker(selection: $color) {
                Label {
                    Text("Color")
                } icon: {
                    Image(systemName: "eyedropper.fill")
                }
            }
            
            Button(action: {}) {
                Label {
                    Text("Pen")
                } icon: {
                    Image(systemName: "pencil.tip")
                }
            }

        } label : {
            Image(systemName: "dots")
        }
    }
}

struct DrawingViewRepresentable : UIViewRepresentable {
    var canvas: Binding<PKCanvasView>
    var isDraw: Binding<Bool>
    
    let ink = PKInkingTool(.marker, color: .black)
    let eraser = PKEraserTool(.bitmap)
    
    func makeUIView(context: Context) -> PKCanvasView {
        canvas.wrappedValue.drawingPolicy = .anyInput
        canvas.wrappedValue.tool = isDraw.wrappedValue ? ink : eraser
        return canvas.wrappedValue
    }
    
    func updateUIView(_ uiView: PKCanvasView, context: Context) {
        uiView.tool = isDraw.wrappedValue ? ink : eraser
    }
    
}

struct DrawingView_Previews: PreviewProvider {
    static var previews: some View {
            DrawingView()
    }
}
