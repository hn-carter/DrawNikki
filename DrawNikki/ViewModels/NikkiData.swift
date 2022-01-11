//
//  NikkiData.swift
//  DrawNikki
//
//  Created by hn-carter on 2021/12/30.
//

import Foundation
import UIKit

class NikkiData {
    var date: Date
    var number: Int
    var picture: UIImage?
    var text: String?

    init(date: Date, number: Int = 0, picture: UIImage? = nil, text: String? = nil) {
        self.date = date
        self.number = number
        self.picture = picture
        self.text = text
    }
}
