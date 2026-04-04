//
//  YKPointerHeightKey.swift
//  YKSpinWheel
//
//  Created by Yakup Kavak on 4.04.2026.
//

import SwiftUI

/// An environment key for the top indicator pointer's height.
@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
public struct YKPointerHeightKey: @preconcurrency EnvironmentKey {
    /// The default height for the top indicator pointer of `YKSpinWheelUI`.
    @MainActor public static var defaultValue: CGFloat = 30.0
}

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension EnvironmentValues {
    
    /// The height of the top indicator pointer.
    ///
    /// - Note: This value is set using the ``View/ykPointerHeight(_:)`` modifier.
    public var ykPointerHeight: CGFloat {
        get { self[YKPointerHeightKey.self] }
        set { self[YKPointerHeightKey.self] = newValue }
    }
}
