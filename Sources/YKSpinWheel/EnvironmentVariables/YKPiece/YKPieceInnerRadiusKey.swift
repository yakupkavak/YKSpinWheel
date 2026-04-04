//
//  YKPieceInnerRadiusKey.swift
//  YKSpinWheel
//
//  Created by Yakup Kavak on 1.04.2026.
//

import SwiftUI

/// An environment key for the inner hole radius of the piece.
@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
public struct YKPieceInnerRadiusKey: @preconcurrency EnvironmentKey {
    /// The default inner radius for `YKPieceUI`.
    @MainActor public static var defaultValue: CGFloat = 10.0
}

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
public extension EnvironmentValues {
    
    /// The size of the inner hole of the wheel slice.
    ///
    /// - Note: This value is set using the ``View/ykPieceInnerRadius(_:)`` modifier.
    var ykPieceInnerRadius: CGFloat {
        get { self[YKPieceInnerRadiusKey.self] }
        set { self[YKPieceInnerRadiusKey.self] = newValue }
    }
}
