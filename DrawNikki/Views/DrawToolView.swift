//
//  DrawToolView.swift
//  DrawNikki
//
//  Created by hn-carter on 2021/11/22.
//

import SwiftUI
import PencilKit

struct DrawToolView: View {
    
    @Environment(\.undoManager) private var undoManager
    
    @ObservedObject var viewModel: DrawingViewModel
    
    var body: some View {
        ZStack {
            Capsule()
                .fill(Color(red: 0.4627, green: 0.8392, blue: 1.0))
                .frame(width:250, height: 150)
            
        HStack(spacing: 10.0) {
            Button("消しゴム") {
                
            }
            Button("取り消し") { undoManager?.undo() }
            Button("やり直し") { undoManager?.redo() }

            Button(action: { viewModel.selectedColor = UIColor.black })
            { Image(systemName: "circle.fill")
                        .foregroundColor(Color.black) }
            Button(action: { viewModel.selectedColor = UIColor.red })
            { Image(systemName: "circle.fill")
                        .foregroundColor(Color.red) }
            Button(action: { viewModel.selectedColor = UIColor.yellow })
            { Image(systemName: "circle.fill")
                        .foregroundColor(Color.yellow)}

            Button(action: { viewModel.selectedColor = UIColor.yellow })
            { Image(systemName: "circle.fill")
                        .foregroundColor(Color.yellow)}


            Button("保存") {
                //imageFile.save(canvasView: canvasView)
            }
            Button("縮小") { viewModel.scaleValue -= 0.1 }
            Button("拡大") { viewModel.scaleValue += 0.1 }
            //Button("全体") { viewModel.scaleValue =  UIScreen.main.bounds.width / viewModel.picSize.width }

        }
        }

    }
}

struct DrawToolView_Previews: PreviewProvider {
    static var previews: some View {
        DrawToolView(viewModel: DrawingViewModel())
    }
}
