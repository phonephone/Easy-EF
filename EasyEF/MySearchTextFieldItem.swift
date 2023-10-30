//
//  MySearchTextFieldItem.swift
//  EasyEF
//
//  Created by Truk Karawawattana on 1/8/2565 BE.
//

import Foundation
import SearchTextField

class MySearchTextFieldItem: SearchTextFieldItem {
    public var id: String?
    public init(title: String, subtitle: String?, id: String?) {
        super.init(title: title)
        self.title = title
        self.subtitle = subtitle
        self.id = id
    }
}
