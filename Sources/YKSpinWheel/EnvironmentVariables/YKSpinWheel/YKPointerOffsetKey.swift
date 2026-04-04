//
//  YKPointerOffsetKey.swift
//  YKSpinWheel
//
//  Created by Yakup Kavak on 4.04.2026.
//

import SwiftUI

/// An environment key for the top indicator pointer's vertical offset.
@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
public struct YKPointerOffsetKey: @preconcurrency EnvironmentKey {
    /// The default vertical offset for the top indicator pointer of `YKSpinWheelUI`.
    @MainActor public static var defaultValue: CGFloat = 0.0
}

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension EnvironmentValues {
    
    /// The vertical offset of the top indicator pointer.
    ///
    /// - Note: This value is set using the ``View/ykPointerOffset(_:)`` modifier.
    public var ykPointerOffset: CGFloat {
        get { self[YKPointerOffsetKey.self] }
        set { self[YKPointerOffsetKey.self] = newValue }
    }
}
