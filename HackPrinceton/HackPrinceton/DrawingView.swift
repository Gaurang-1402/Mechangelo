//
//  DrawingView.swift
//  HackPrinceton
//
//  Created by Brayton Lordianto on 3/31/23.
//

import SwiftUI
import PencilKit
import Firebase
import FirebaseStorage

enum tool {
case partialEraser
case wholeEraser
case pen
}

struct DrawingView: View {
    @Binding var canvas: PKCanvasView
    @Binding var isDraw: Bool
    @Binding var color: Color
    @Binding var drawingTool: tool 
    
    let types: [PKInkingTool.InkType] = [.pencil, .pen, .marker]
    let names = ["Pencil", "Pen", "Marker"]
    let imageNames = ["pencil", "pencil.tip", "highlighter"]
    
    var body: some View {
//        NavigationStack {
            ZStack(alignment: .leading) {
                DrawingViewRepresentable(canvas: $canvas, isDraw: $isDraw, color: $color, drawingTool: $drawingTool)
                    .aspectRatio(contentMode: .fill)
                
        
//                commitButton()
            }
//        }
    }
    
    func clearButton() -> some View {
        Button {
            canvas.drawing = PKDrawing()
        } label: {
            Text("CLEAR")
                .foregroundColor(.red)
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
    
    func colorPicker() -> some View {
        ColorPicker(selection: $color) {
            Label {
                Text("Color")
            } icon: {
                Image(systemName: "eyedropper.fill")
            }
        }
    }
    
    func switchToTool(_ newTool: tool) {
        drawingTool = newTool
    }
    

    
    
    
}

struct DrawingViewRepresentable : UIViewRepresentable {
    
    var canvas: Binding<PKCanvasView>
    var isDraw: Binding<Bool>
//    var inkTool: Binding<PKInkingTool.InkType>
    var color: Binding<Color>
    var drawingTool: Binding<tool>
    
    
    var ink: PKInkingTool {
        PKInkingTool(.marker, color: UIColor(color.wrappedValue))
    }

    let partialEraser = PKEraserTool(.bitmap)
    let wholeEraser = PKEraserTool(.vector)
    
    func makeUIView(context: Context) -> PKCanvasView {
        canvas.wrappedValue.backgroundColor = .black
        canvas.wrappedValue.drawingPolicy = .anyInput
        if drawingTool.wrappedValue == .pen {
            canvas.wrappedValue.tool = ink
        } else if drawingTool.wrappedValue == .partialEraser {
            canvas.wrappedValue.tool = partialEraser
        } else {
            canvas.wrappedValue.tool = wholeEraser
        }
        
        return canvas.wrappedValue
    }
    
    func updateUIView(_ uiView: PKCanvasView, context: Context) {
        if drawingTool.wrappedValue == .pen {
            canvas.wrappedValue.tool = ink
        } else if drawingTool.wrappedValue == .partialEraser {
            canvas.wrappedValue.tool = partialEraser
        } else {
            canvas.wrappedValue.tool = wholeEraser
        }
    }
    
}

//struct DrawingView_Previews: PreviewProvider {
//    static var previews: some View {
//            DrawingView()
//    }
//}

/*
 //                .toolbar {
 //                    ToolbarItemGroup(placement: .navigationBarLeading) {
 //                        commitButton()
 //                    }
 //
 //                    ToolbarItemGroup(placement: .navigationBarTrailing) {
 //                        HStack {
 //                            clearButton()
 //                            currentModeButton()
 //                            CustomColorPicker(selectedColor: $color, isDraw: $isDraw)
 //                            menu()
 //                        }
 //                    }
 //                }

 */
