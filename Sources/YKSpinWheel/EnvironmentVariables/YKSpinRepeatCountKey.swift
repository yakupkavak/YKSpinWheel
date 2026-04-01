//
//  YKSpinRepeatCount.swift
//  YKSpinWheel
//
//  Created by Yakup Kavak on 1.04.2026.
//

import SwiftUI

/// An environment key for the spin's time duration.
@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
public struct YKSpinRepeatCountKey: @preconcurrency EnvironmentKey  {
    /// The default spin time for `YKSpinWheel`.
    @MainActor public static var defaultValue: Int = 1
}

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension EnvironmentValues {
    
    /// The background color of the `YK`.
    ///
    /// - Note: This value is set using the ``View/cardBackgroundColor(_:)`` modifier.
    public var ykSpinRepeatCount: Int {
        get { self[YKSpinRepeatCountKey.self] }
        set { self[YKSpinRepeatCountKey.self] = newValue }
    }
}
