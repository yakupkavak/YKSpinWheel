//
//  YKPieceCornerRadiusKey.swift
//  YKSpinWheel
//
//  Created by Yakup Kavak on 1.04.2026.
//

import SwiftUI

/// An environment key for the corner radius of the piece.
@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
public struct YKPieceCornerRadiusKey: @preconcurrency EnvironmentKey {
    /// The default corner radius for `YKPieceUI`.
    @MainActor public static var defaultValue: CGFloat = 15.0
}

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
public extension EnvironmentValues {
    
    /// The roundness of the outer corners of the wheel slice.
    ///
    /// - Note: This value is set using the ``View/ykPieceCornerRadius(_:)`` modifier.
    var ykPieceCornerRadius: CGFloat {
        get { self[YKPieceCornerRadiusKey.self] }
        set { self[YKPieceCornerRadiusKey.self] = newValue }
    }
}
