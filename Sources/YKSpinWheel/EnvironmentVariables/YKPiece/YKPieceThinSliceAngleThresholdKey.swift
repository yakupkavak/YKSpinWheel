//
//  YKPieceThinSliceAngleThresholdKey.swift
//  YKSpinWheel
//
//  Created by Yakup Kavak on 1.04.2026.
//

import SwiftUI

/// An environment key for the angle threshold determining if a slice is "thin".
@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
public struct YKPieceThinSliceAngleThresholdKey: @preconcurrency EnvironmentKey {
    /// The default angle threshold (50 in degrees). Slices with an angle less than or equal to this value will use the thin layout.
    @MainActor public static var defaultValue: Double = 50.0
}

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
public extension EnvironmentValues {
    
    /// The maximum angle (in degrees) for a slice to be considered "thin".
    ///
    /// - Note: This value is set using the ``View/ykPieceThinSliceAngleThreshold(_:)`` modifier.
    var ykPieceThinSliceAngleThreshold: Double {
        get { self[YKPieceThinSliceAngleThresholdKey.self] }
        set { self[YKPieceThinSliceAngleThresholdKey.self] = newValue }
    }
}

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
public extension View {
    
    /// Sets the maximum angle for a slice to be considered "thin" in `YKPieceUI`.
    ///
    /// Thin slices dynamically change their layout (e.g., stacking text vertically and rotating it). Use this modifier to adjust when that transition happens.
    ///
    /// - Parameter threshold: The threshold angle in degrees.
    /// - Returns: A view that applies the specified threshold.
    ///
    /// - Example:
    /// ```swift
    /// YKPieceUI(...)
    ///     .ykPieceThinSliceAngleThreshold(40.0)
    /// ```
    func ykPieceThinSliceAngleThreshold(_ threshold: Double) -> some View {
        environment(\.ykPieceThinSliceAngleThreshold, threshold)
    }
}
