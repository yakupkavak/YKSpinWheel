//
//  YKSpinRandomMinValueKey.swift
//  YKSpinWheel
//
//  Created by Yakup Kavak on 1.04.2026.
//

import SwiftUI

/// An environment key that defines the minimum random stopping angle for the spin wheel.
@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
public struct YKSpinRandomMinValueKey: @preconcurrency EnvironmentKey {
    
    /// The default minimum random angle for the `YKSpinWheel`.
    ///
    /// The default value is `1.0`. This represents the lower bound of the random degree
    /// the wheel will add to its base rotations before stopping.
    @MainActor public static var defaultValue: Double = 1.0
}

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
public extension EnvironmentValues {
    
    /// The minimum random stopping angle of the `YKSpinWheel`.
    ///
    /// Use this value to restrict the wheel's stopping position to a specific range.
    /// By default, it allows the wheel to stop anywhere starting from `1.0` degree.
    ///
    /// - Note: This value is set using the ``View/ykSpinRandomMinValue(_:)`` modifier.
    var ykSpinRandomMinValue: Double {
        get { self[YKSpinRandomMinValueKey.self] }
        set { self[YKSpinRandomMinValueKey.self] = newValue }
    }
}
