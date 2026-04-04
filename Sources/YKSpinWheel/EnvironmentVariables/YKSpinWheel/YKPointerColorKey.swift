//
//  YKPointerColorKey.swift
//  YKSpinWheel
//
//  Created by Yakup Kavak on 4.04.2026.
//

import SwiftUI

/// An environment key for the top indicator pointer's color.
@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
public struct YKPointerColorKey: @preconcurrency EnvironmentKey {
    /// The default color for the top indicator pointer of `YKSpinWheelUI`.
    @MainActor public static var defaultValue: Color = Color(red: 0.4, green: 0.3, blue: 0.5)
}

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension EnvironmentValues {
    
    /// The color of the top indicator pointer.
    ///
    /// - Note: This value is set using the ``View/ykPointerColor(_:)`` modifier.
    public var ykPointerColor: Color {
        get { self[YKPointerColorKey.self] }
        set { self[YKPointerColorKey.self] = newValue }
    }
}
