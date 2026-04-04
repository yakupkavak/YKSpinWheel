//
//  YKPieceShadowColorKey.swift
//  YKSpinWheel
//
//  Created by Yakup Kavak on 1.04.2026.
//

import SwiftUI

/// An environment key for the shadow color of the content inside the piece.
@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
public struct YKPieceShadowColorKey: @preconcurrency EnvironmentKey {
    /// The default shadow color for `YKPieceUI`.
    @MainActor public static var defaultValue: Color = Color.black.opacity(0.2)
}

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
public extension EnvironmentValues {
    
    /// The shadow color for the icon and text inside the wheel slice.
    ///
    /// - Note: This value is set using the ``View/ykPieceShadowColor(_:)`` modifier.
    var ykPieceShadowColor: Color {
        get { self[YKPieceShadowColorKey.self] }
        set { self[YKPieceShadowColorKey.self] = newValue }
    }
}
