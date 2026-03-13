//
//  DMStrings.swift
//  Daily-Metrics
//
//  Created by Praveen Kumar Vedanti on 3/12/26.
//

import Foundation

struct DMStrings {
    
    // Add counter view
    static let initialValueTextFiledHeader = NSLocalizedString("Initial value", comment: "Initial value text field header")
    static let initialValueTextFieldFooter = NSLocalizedString("Enter initial value (default is 0)", comment: "Initial value text field footer")
    
    static let incrementByTextFieldHeader = NSLocalizedString("Increment by", comment: "Increment by text field header")
    static let incrementByTextFieldFooter = NSLocalizedString("Enter the amount the counter should increase per tap (default is 1)", comment: "Increment by text field footer")
    
    static let colorSectionHeader = NSLocalizedString("Color", comment: "Color section header")
    static let colorSectionFooter = NSLocalizedString("Choose a color for your counter", comment: "Color section footer")
    
    static let metricNameTextFieldPlaceholder = NSLocalizedString("Counter name (Required)", comment: "Counter name text field placeholder")
    static let newCounterTitle = NSLocalizedString("New Counter", comment: "New counter navigation title")
    static let counterValueTextFiledHeader = NSLocalizedString("Counter value", comment: "Counter value text field header")
    
    // Edit counter view
    static let counterCurrentValueHeader = NSLocalizedString("Current value", comment: "Counter current value text")
    static let editCounterSheetTitle = NSLocalizedString("Edit counter", comment: "Edit counter sheet title")
}
