//
//  DMStrings.swift
//  Daily-Metrics
//
//  Created by Praveen Kumar Vedanti on 3/12/26.
//

import Foundation

// MARK: - Localized strings.

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
    static let swipeTipViewTitle = NSLocalizedString("Swipe  or Long press counter card more options", comment: "Swipe tip view title")
    static let swipeTipViewSubTitle = NSLocalizedString("Edit, reset or delete your counter", comment: "Swipe tip view sub title")
    static let countersNavigationTitle = NSLocalizedString("Counters", comment: "Counters navigation title")
    static let newCountersButtonTitle = NSLocalizedString("New Counter", comment: "New counter title")
    static let resetCounterAlertMessage = NSLocalizedString("This will reset the counter back to 0", comment: "Alert message explaining that the counter will be reset to zero")
    static let deleteCounterAlertMessage = NSLocalizedString(
        "This will permanently delete the counter and all its history.",
        comment: "Warning message shown before deleting a counter"
    )
    static let cancelButtonTitle = NSLocalizedString("Cancel", comment: "Button title to cancel an action")
    static let resetButtonTitle = NSLocalizedString("Reset", comment: "Button title to reset the counter value")
    static let deleteButtonTitle = NSLocalizedString("Delete", comment: "Button title to delete a counter")
    static let editButtonTitle = NSLocalizedString("Edit", comment: "Button title to edit a counter")
    
    static let emptyStateTitle = NSLocalizedString(
        "No Counters Yet",
        comment: "Title shown when user has not created any counters"
    )

    static let emptyStateMessage = NSLocalizedString(
        "Create your first counter to start.",
        comment: "Message encouraging the user to create their first counter"
    )

    static let emptyStateHint = NSLocalizedString(
        "You can also tap + in the top right",
        comment: "Hint explaining how to add a new counter"
    )
    
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
    static let clearButtonTitle = NSLocalizedString("Clear", comment: "clear button title")
    
    // History view
    static let emptyHistoryTitle = NSLocalizedString(
        "No history yet",
        comment: "Title shown when there is no counter history"
    )

    static let emptyHistoryMessage = NSLocalizedString(
        "Start using a counter and your activity will appear here.",
        comment: "Message explaining that history will show when user interacts with counters"
    )
    static let historyNavigationTitle = NSLocalizedString("History", comment: "History navigation title")
    
}

struct DMIcons {
    static let plus = "plus"
    static let minus = "minus"
    static let handDraw = "hand.tap"
    static let crossMark = "xmark"
    static let trash = "trash"
    static let reset = "arrow.counterclockwise"
    static let edit = "pencil"
    static let info = "info.circle"
    static let haptics = "iphone.radiowaves.left.and.right"
    static let sounds = "speaker.wave.2"
    static let star = "star"
    static let envelope = "envelope"
    static let checkMark = "checkmark"
    static let clock = "clock"
    static let rightArrow = "arrow.right"
}
