//
//  YKSpinRandomMaxValueKey.swift
//  YKSpinWheel
//
//  Created by Yakup Kavak on 1.04.2026.
//

import SwiftUI

/// An environment key that defines the maximum random stopping angle for the spin wheel.
@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
public struct YKSpinRandomMaxValueKey: @preconcurrency EnvironmentKey {
    
    /// The default maximum random angle for the `YKSpinWheel`.
    ///
    /// The default value is `360.0`. This represents the upper bound of the random degree
    /// the wheel will add to its base rotations before stopping.
    @MainActor public static var defaultValue: Double = 360.0
}

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
public extension EnvironmentValues {
    
    /// The maximum random stopping angle of the `YKSpinWheel`.
    ///
    /// Use this value to restrict the wheel's stopping position to a specific range.
    /// By default, it allows the wheel to stop anywhere up to `360.0` degrees.
    ///
    /// - Note: This value is set using the ``View/ykSpinRandomMaxValue(_:)`` modifier.
    var ykSpinRandomMaxValue: Double {
        get { self[YKSpinRandomMaxValueKey.self] }
        set { self[YKSpinRandomMaxValueKey.self] = newValue }
    }
}
