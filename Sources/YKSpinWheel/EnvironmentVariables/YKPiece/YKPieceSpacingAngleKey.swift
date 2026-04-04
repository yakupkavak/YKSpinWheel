//
//  YKPieceSpacingAngleKey.swift
//  YKSpinWheel
//
//  Created by Yakup Kavak on 1.04.2026.
//

import SwiftUI

/// An environment key for the gap angle between wheel slices.
@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
public struct YKPieceSpacingAngleKey: @preconcurrency EnvironmentKey {
    /// The default gap angle for `YKPieceUI`.
    @MainActor public static var defaultValue: Double = 2.0
}

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
public extension EnvironmentValues {
    
    /// The gap angle between the slices.
    ///
    /// - Note: This value is set using the ``View/ykPieceSpacingAngle(_:)`` modifier.
    var ykPieceSpacingAngle: Double {
        get { self[YKPieceSpacingAngleKey.self] }
        set { self[YKPieceSpacingAngleKey.self] = newValue }
    }
}
