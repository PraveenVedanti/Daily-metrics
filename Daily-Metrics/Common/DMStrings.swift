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
    
    // Metrics list view
    static let swipeTipViewTitle = NSLocalizedString("Swipe counter card more options", comment: "Swipe tip view title")
    static let swipeTipViewSubTitle = NSLocalizedString("Edit, reset or delete your counter", comment: "Swipe tip view sub title")
    static let countersNavigationTitle = NSLocalizedString("Counters", comment: "Counters navigation title")
    static let newCountersButtonTitle = NSLocalizedString("New Counter", comment: "New counter title")
    
    // Settings view
    static let settingsNavigationTitle = NSLocalizedString("Settings", comment: "New counter title")
    static let clearHistoryAlertTitle = NSLocalizedString("Clear All History", comment: "Clear history title")
    static let feedbackSectionHeader = NSLocalizedString("Feedback", comment: "Feedback header title")
    static let dataSectionHeader = NSLocalizedString("Data", comment: "Data header title")
    static let supportSectionHeader = NSLocalizedString("Support", comment: "Support header title")
    static let clearHistoryAlertMessage = NSLocalizedString("This will permanently delete the counter and all its history.", comment: "Clear history alert title")
    static let hapticsText = NSLocalizedString("Haptics", comment: "Haptics title")
    static let soundsText = NSLocalizedString("Sounds", comment: "Sounds title")
    static let clearHistoryText = NSLocalizedString("Clear All History", comment: "clear history title")
    static let rateTheAppText = NSLocalizedString("Rate the App", comment: "rate the app title")
    static let feedbacktext = NSLocalizedString("Contact / Feedback", comment: "contact title")
    static let versionText = NSLocalizedString("Version", comment: "version title")
    
}

struct DMIcons {
    static let plusIcon = "plus"
    static let minusIcon = "minus"
    static let handDrawIcon = "hand.draw"
    static let crossMarkIcon = "xmark"
    static let trashIcon = "trash"
    static let resetIcon = "arrow.counterclockwise"
    static let editIcon = "pencil"
    static let infoIcon = "info.circle"
    static let hapticsIcon = "iphone.radiowaves.left.and.right"
    static let soundsIcon = "speaker.wave.2"
    static let starIcon = "star"
    static let envelopeIcon = "envelope"
}
