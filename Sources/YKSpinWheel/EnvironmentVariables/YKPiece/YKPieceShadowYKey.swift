//
//  YKPieceShadowYKey.swift
//  YKSpinWheel
//
//  Created by Yakup Kavak on 1.04.2026.
//

import SwiftUI

/// An environment key for the vertical shadow offset of the content inside the piece.
@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
public struct YKPieceShadowYKey: @preconcurrency EnvironmentKey {
    /// The default vertical shadow offset for `YKPieceUI`.
    @MainActor public static var defaultValue: CGFloat = 5.0
}

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
public extension EnvironmentValues {
    
    /// The vertical offset of the shadow for the icon and text inside the wheel slice.
    ///
    /// - Note: This value is set using the ``View/ykPieceShadowY(_:)`` modifier.
    var ykPieceShadowY: CGFloat {
        get { self[YKPieceShadowYKey.self] }
        set { self[YKPieceShadowYKey.self] = newValue }
    }
}
