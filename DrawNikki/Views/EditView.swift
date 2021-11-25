//
//  EditView.swift
//  DrawNikki
//
//  Created by hn-carter on 2021/11/24.
//

import SwiftUI

struct EditView: View {
    @State private var multiLine: String = "フンフンフフーン\nフンフフー\n\nTextEditorで複数行入力"
    var body: some View {
        NavigationView {
        TextEditor(text: $multiLine)
            .font(.title)
            .padding()
        
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

struct EditView_Previews: PreviewProvider {
    static var previews: some View {
        EditView()
    }
}
