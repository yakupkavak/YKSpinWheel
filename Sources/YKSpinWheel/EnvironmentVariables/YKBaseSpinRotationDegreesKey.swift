//
//  YKBaseSpinRotationDegrees.swift
//  YKSpinWheel
//
//  Created by Yakup Kavak on 1.04.2026.
//

import SwiftUI

/// An environment key for the spin's rotation degrees.
@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
public struct YKBaseSpinRotationDegreesKey: @preconcurrency EnvironmentKey  {
    /// The default spin time for `YKSpinWheel`.
    @MainActor public static var defaultValue: Double = 2880
}

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension EnvironmentValues {
    
    /// The background color of the `PKSCard`.
    ///
    /// - Note: This value is set using the ``View/cardBackgroundColor(_:)`` modifier.
    public var ykBaseSpinRotationDegrees: Double {
        get { self[YKBaseSpinRotationDegreesKey.self] }
        set { self[YKBaseSpinRotationDegreesKey.self] = newValue }
    }
}
