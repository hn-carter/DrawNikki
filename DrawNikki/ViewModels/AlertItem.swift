//
//  AlertItem.swift
//  DrawNikki
//
//  Created by hn-carter on 2022/01/27.
//

import Foundation
import SwiftUI

/// アラートダイアログ
struct AlertItem: Identifiable {
    var id = UUID()
    var alert: Alert
}
