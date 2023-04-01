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
    @State var inkTool: PKInkingTool.InkType = .pen
    
    let types: [PKInkingTool.InkType] = [.pencil, .pen, .marker]
    let names = ["Pencil", "Pen", "Marker"]
    let imageNames = ["pencil", "pencil.tip", "highlighter"]
    
    var body: some View {
        NavigationStack {
            
            DrawingViewRepresentable(canvas: $canvas, isDraw: $isDraw, inkTool: $inkTool, color: $color)
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItemGroup(placement: .navigationBarLeading) {
                        commitButton()
                    }
                    
                    ToolbarItemGroup(placement: .navigationBarTrailing) {
                        HStack {
                            clearButton()
                            currentModeButton()
                            menu()
                        }
                    }
                }
                .navigationTitle("Drawing")
        }
        
    }
    
    func clearButton() -> some View {
        Button {
            canvas.drawing = PKDrawing()
        } label: {
            Text("CLEAR")
                .foregroundColor(.red)
        }

    }
    
    func commitButton() -> some View {
        Button {
            // type UIImage
            let image = canvas.drawing.image(from: canvas.drawing.bounds, scale: 1)
            
            // send to firestore
            c
            
        } label: {
            VStack {
                Image(systemName: "square.and.arrow.up.fill")
                Text("Draw My \nLight Painting!")
                    .fixedSize(horizontal: false, vertical: true)

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
//            ColorPicker(selection: $color) {
//                Label {
//                    Text("Color")
//                } icon: {
//                    Image(systemName: "eyedropper.fill")
//                }
//            }
            
            ForEach(0..<3) { idx in
                Button(action: {switchToTool(types[idx])}) {
                    Label {
                        Text(names[idx])
                    } icon: {
                        Image(systemName: imageNames[idx])
                    }
                }
            }
        } label : {
            VStack {
                Image(systemName: "menubar.rectangle")
                Text("menu")
            }
        }
    }
    
    func switchToTool(_ tool : PKInkingTool.InkType) {
        isDraw = true
        inkTool = tool
    }
    
    
    
}

struct DrawingViewRepresentable : UIViewRepresentable {
    
    var canvas: Binding<PKCanvasView>
    var isDraw: Binding<Bool>
    var inkTool: Binding<PKInkingTool.InkType>
    var color: Binding<Color>
    
    
    var ink: PKInkingTool {
        PKInkingTool(inkTool.wrappedValue, color: UIColor(color.wrappedValue))
    }

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
