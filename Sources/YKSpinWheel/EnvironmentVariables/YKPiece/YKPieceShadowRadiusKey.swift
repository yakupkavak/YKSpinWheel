//
//  YKPieceShadowRadiusKey.swift
//  YKSpinWheel
//
//  Created by Yakup Kavak on 1.04.2026.
//

import SwiftUI

/// An environment key for the shadow radius of the content inside the piece.
@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
public struct YKPieceShadowRadiusKey: @preconcurrency EnvironmentKey {
    /// The default shadow radius for `YKPieceUI`.
    @MainActor public static var defaultValue: CGFloat = 5.0
}

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
public extension EnvironmentValues {
    
    /// The blur radius of the shadow for the icon and text inside the wheel slice.
    ///
    /// - Note: This value is set using the ``View/ykPieceShadowRadius(_:)`` modifier.
    var ykPieceShadowRadius: CGFloat {
        get { self[YKPieceShadowRadiusKey.self] }
        set { self[YKPieceShadowRadiusKey.self] = newValue }
    }
}
