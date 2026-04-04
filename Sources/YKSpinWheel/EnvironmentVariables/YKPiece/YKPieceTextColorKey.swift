//
//  YKPieceTextColorKey.swift
//  YKSpinWheel
//
//  Created by Yakup Kavak on 1.04.2026.
//

import SwiftUI

/// An environment key for the text color inside the piece.
@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
public struct YKPieceTextColorKey: @preconcurrency EnvironmentKey {
    /// The default text color for `YKPieceUI`.
    @MainActor public static var defaultValue: Color = Color(red: 0.4, green: 0.3, blue: 0.5)
}

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
public extension EnvironmentValues {
    
    /// The color of the text displayed inside the wheel slice.
    ///
    /// - Note: This value is set using the ``View/ykPieceTextColor(_:)`` modifier.
    var ykPieceTextColor: Color {
        get { self[YKPieceTextColorKey.self] }
        set { self[YKPieceTextColorKey.self] = newValue }
    }
}
