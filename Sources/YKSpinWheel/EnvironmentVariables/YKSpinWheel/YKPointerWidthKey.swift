//
//  Untitled.swift
//  YKSpinWheel
//
//  Created by Yakup Kavak on 4.04.2026.
//

import SwiftUI

/// An environment key for the top indicator pointer's width.
@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
public struct YKPointerWidthKey: @preconcurrency EnvironmentKey {
    /// The default width for the top indicator pointer of `YKSpinWheelUI`.
    @MainActor public static var defaultValue: CGFloat = 30.0
}

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension EnvironmentValues {
    
    /// The width of the top indicator pointer.
    ///
    /// - Note: This value is set using the ``View/ykPointerWidth(_:)`` modifier.
    public var ykPointerWidth: CGFloat {
        get { self[YKPointerWidthKey.self] }
        set { self[YKPointerWidthKey.self] = newValue }
    }
}
