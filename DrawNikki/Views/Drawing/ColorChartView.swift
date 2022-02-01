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
        LazyVGrid(columns: Array(repeating: GridItem(), count: 4)) {
            ForEach(viewModel.colors, id: \.self){ color in
                ZStack {
                    Image(systemName: "drop.fill")
                        .resizable()
                        .frame(width: 25, height: 30)
                        .foregroundColor(color)
                        .onTapGesture(perform: {
                            viewModel.selectedColor(c: color)
                            viewModel.selection = color
                        })
                        .padding(5)

                    if viewModel.selection == color {
                        Circle()
                            .stroke(color!, lineWidth: 5)
                            .frame(width: 25, height: 30)
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
