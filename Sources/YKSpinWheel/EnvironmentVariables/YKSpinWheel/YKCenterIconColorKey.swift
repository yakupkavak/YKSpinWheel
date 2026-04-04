//
//  YKCenterIconColorKey.swift
//  YKSpinWheel
//
//  Created by Yakup Kavak on 4.04.2026.
//

import SwiftUI

/// An environment key for the center hub's icon color.
@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
public struct YKCenterIconColorKey: @preconcurrency EnvironmentKey {
    /// The default icon color for the center hub of `YKSpinWheelUI`.
    @MainActor public static var defaultValue: Color = Color(red: 0.6, green: 0.4, blue: 0.8)
}

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension EnvironmentValues {
    
    /// The color of the icon inside the center hub.
    ///
    /// - Note: This value is set using the ``View/ykCenterIconColor(_:)`` modifier.
    public var ykCenterIconColor: Color {
        get { self[YKCenterIconColorKey.self] }
        set { self[YKCenterIconColorKey.self] = newValue }
    }
}
