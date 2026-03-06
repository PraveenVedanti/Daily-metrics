//
//  Metrics.swift
//  Daily-Metrics
//
//  Created by Praveen Kumar Vedanti on 3/6/26.
//

import Foundation
import SwiftData
import SwiftUI

@Model
class Metric {
    var name: String
    var desc: String?
    var unit: String?
    var value: Int
    var increment: Int
    var color: String?

    init(
        name: String,
        desc: String? = nil,
        unit: String? = nil,
        value: Int = 0,
        increment: Int = 1,
        color: String? = "blue"
    ) {
        self.name = name
        self.desc = desc
        self.unit = unit
        self.value = value
        self.increment = increment
        self.color = color
    }
}
