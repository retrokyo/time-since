//
//  ThemeManager.swift
//  TimeSince
//
//  Created by Froning, Reeves | Reeves | DSCD on 2024/06/22.
//

import Foundation
import SwiftUI

enum AppTheme: String, CaseIterable, Identifiable {
    case system, light, dark, nineties
    
    var id : String { self.rawValue }
    
    var name: String {
        switch self {
        case .system: return "System"
        case .light: return "Light"
        case .dark: return "Dark"
        case .nineties: return "90s"
        }
    }
}

class ThemeManager: ObservableObject {
    @Published var currentTheme: AppTheme {
        didSet {
            UserDefaults.standard.set(currentTheme.rawValue, forKey: "app_theme")
        }
    }
    
    @Environment(\.colorScheme) var colorScheme
    
    init() {
        if let savedTheme = UserDefaults.standard.string(forKey: "app_theme"),
           let theme = AppTheme(rawValue: savedTheme) {
            self.currentTheme = theme
        } else {
            self.currentTheme = .system
        }
    }
    
    func applyTheme() -> AnyViewModifier {
        switch currentTheme {
        case .system:
            return AnyViewModifier(EmptyModifier())
        case .light:
            return AnyViewModifier(SystemThemeModifier(colorScheme: .light))
        case .dark:
            return AnyViewModifier(SystemThemeModifier(colorScheme: .dark))
        case .nineties:
            return AnyViewModifier(NinetiesThemeModifier(themeManager: self))
        }
    }
    
    func color(for colorRole: ThemeColorRole) -> Color {
        switch currentTheme {
        case .system:
            return colorRole.systemColor
        case .light:
            return colorRole.lightColor
        case .dark:
            return colorRole.darkColor
        case .nineties:
            return colorRole.nineties
        }
    }
    
    func font(for textStyle: Font.TextStyle) -> Font {
        switch currentTheme {
        case .nineties:
            return .custom("VT323", size: fontSizeFor(textStyle))
        default:
            return Font.system(textStyle)
        }
    }
    
    private func fontSizeFor(_ textStyle: Font.TextStyle) -> CGFloat {
        switch textStyle {
        case .largeTitle: return 34
        case .title: return 28
        case .title2: return 22
        case .title3: return 20
        case .headline: return 17
        case .body: return 17
        case .callout: return 16
        case .subheadline: return 15
        case .footnote: return 13
        case .caption: return 12
        case .caption2: return 11
        @unknown default: return 17
        }
    }
}

struct SystemThemeModifier: ViewModifier {
    let colorScheme: ColorScheme
    
    func body(content: Content) -> some View {
        content.preferredColorScheme(colorScheme)
    }
}

struct AnyViewModifier: ViewModifier {
    private let modifier: (Content) -> AnyView
    
    init<M: ViewModifier>(_ m: M) {
        modifier = { AnyView($0.modifier(m)) }
    }
    
    func body(content: Content) -> some View {
        modifier(content)
    }
}

enum ThemeColorRole {
    case background
    case text
    case accent
    case buttonBackground
    
    var systemColor: Color {
        switch self {
        case .background:
            return Color(.systemBackground)
        case .text:
            return Color(.label)
        case .accent:
            return Color(.systemBlue)
        case .buttonBackground:
            return Color(.secondarySystemBackground)
        }
    }
    
    var lightColor: Color {
        switch self {
        case .background: return .white
        case .text: return .black
        case .accent: return .blue
        case .buttonBackground: return Color(UIColor.systemGray6)
        }
    }
    
    var darkColor: Color {
        switch self {
        case .background: return .black
        case .text: return .white
        case .accent: return .blue
        case .buttonBackground: return Color(UIColor.systemGray5)
        }
    }
    
    var nineties: Color {
        switch self {
        case .background:
            return Theme90s.background
        case .text:
            return Theme90s.text
        case .accent:
            return Theme90s.accent
        case .buttonBackground:
            return Theme90s.buttonBackground
        }
    }
}

