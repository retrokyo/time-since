//
//  File.swift
//  TimeSinceWidgetExtension
//
//  Created by Froning, Reeves | Reeves | DSCD on 2024/06/24.
//

import Foundation
import SwiftUI

struct WidgetTheme {
    let backgroundColor: Color
    let textColor: Color
    let secondaryTextcolor: Color
    let accentColor: Color
    let mainFont: Font
    let titleFont: Font
    let subtitleFont: Font
    
    static func from(_ appTheme: AppTheme) -> WidgetTheme {
        let themeManager = ThemeManager(initialTheme: appTheme)
        return WidgetTheme(
            backgroundColor: themeManager.color(for: .background),
            textColor: themeManager.color(for: .text),
            secondaryTextcolor: themeManager.color(for: .text).opacity(0.7),
            accentColor: themeManager.color(for: .accent),
            mainFont: themeManager.font(for: .body),
            titleFont: themeManager.font(for: .headline),
            subtitleFont: themeManager.font(for: .subheadline)
        )
    }
}
