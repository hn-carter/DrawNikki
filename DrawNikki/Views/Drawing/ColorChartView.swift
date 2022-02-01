//
//  ColorChartView.swift
//  DrawNikki
//
//  Created by hn-carter on 2021/11/22.
//

import SwiftUI

struct ColorChartView: View {
    @ObservedObject var viewModel: ColorChartViewModel

    var body: some View {
        // 画面幅によって表示サイズを調整
        var imageWidth: CGFloat = 0.0
        var imageHeight: CGFloat = 0.0
        if UIScreen.main.bounds.width < Constants.narrowScreenWidth {
            imageWidth = 22.0
            imageHeight = 26.0
        } else {
            imageWidth = 25.0
            imageHeight = 30.0
        }

        return LazyVGrid(columns: Array(repeating: GridItem(), count: 4)) {
            ForEach(viewModel.colors, id: \.self){ color in
                ZStack {

                    Image(systemName: "drop.fill")
                        .resizable()
                        .frame(width: imageWidth, height: imageHeight)
                        .foregroundColor(color)
                        .onTapGesture(perform: {
                            viewModel.selectedColor(c: color)
                            viewModel.selection = color
                        })
                        .padding(5)

                    if viewModel.selection == color {
                        Circle()
                            .stroke(color!, lineWidth: 5)
                            .frame(width: imageWidth, height: imageHeight)
                    }
                }
            }
        }
    }
}

struct ColorChartView_Previews: PreviewProvider {
    static func kara(c: Color?) -> Void {}
    
    static var previews: some View {
        ColorChartView(viewModel: ColorChartViewModel(selectAction: kara))
    }
}
