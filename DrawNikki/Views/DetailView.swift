//
//  DetailView.swift
//  DrawNikki
//
//  Created by hn-carter on 2021/11/21.
//

import SwiftUI

/**
 1ページの日記を表示する
 追加ボタンで同じ日にページを追加
 絵をタップすると全画面表示
 絵の編集ボタンで描画画面へ遷移
 テキストを入力
 */
struct DetailView: View {
    var body: some View {
        VStack {
            // 年月日
            Text("2021-11-24")
                .font(.title)

            // 絵
            
            
            // 文章
            BubbleView(direction: BubbleView.BubbleShape.Direction.left, backGround: Color.green)
                .frame(width: 250, height: 150)
                .overlay(Text("フンフンフフーン")
                            .font(.system(size: 20, weight: .heavy, design: .serif))
                            .foregroundColor(Color.white))
            BubbleView(direction: BubbleView.BubbleShape.Direction.top, backGround: Color.blue)
                .frame(width: 250, height: 150)
                .overlay(Text("フンフフー")
                            .font(.system(size: 20, weight: .heavy, design: .serif))
                            .foregroundColor(Color.white)
                            )
                
            BubbleView(direction: BubbleView.BubbleShape.Direction.right, backGround: Color.gray)
                .frame(width: 250, height: 150)
            BubbleView(direction: BubbleView.BubbleShape.Direction.bottom, backGround: Color.red)
                .frame(width: 250, height: 150)
        }
    }
}

struct DetailView_Previews: PreviewProvider {
    static var previews: some View {
        DetailView()
    }
}
