//
//  View+extensions.swift
//  DrawNikki
//
//  Created by hn-carter on 2021/11/29.
//

import Foundation
import SwiftUI

/// 回転を検知するためのカスタムモディファイア
struct DeviceRotationViewModifier: ViewModifier {
    let action: (UIDeviceOrientation) -> Void

    
    /// デバイスの向きが変わったことを検知し、指定の処理に向きを渡し、呼び出す
    /// - Parameter content: 対象となるView
    /// - Returns: 結果
    func body(content: Content) -> some View {
        content
            .onAppear()
            .onReceive(NotificationCenter.default.publisher(for: UIDevice.orientationDidChangeNotification)) { _ in
                action(UIDevice.current.orientation)
            }
    }
}

extension View {
    /// モディファイアで端末の向きが変わった時の処理を記述できるようにする
    /// - Parameter action: 実行する処理
    /// - Returns: カスタムモディファイア
    func onRotate(perform action: @escaping (UIDeviceOrientation) -> Void) -> some View {
        self.modifier(DeviceRotationViewModifier(action: action))
    }
}
