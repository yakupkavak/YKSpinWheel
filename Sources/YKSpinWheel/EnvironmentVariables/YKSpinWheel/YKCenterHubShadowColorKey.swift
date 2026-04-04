//
//  YKCenterHubShadowColorKey.swift
//  YKSpinWheel
//
//  Created by Yakup Kavak on 4.04.2026.
//

import SwiftUI

/// An environment key for the center hub's shadow color.
@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
public struct YKCenterHubShadowColorKey: @preconcurrency EnvironmentKey {
    /// The default shadow color for the center hub of `YKSpinWheelUI`.
    @MainActor public static var defaultValue: Color = .black.opacity(0.15)
}

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension EnvironmentValues {
    
    /// The shadow color of the center hub.
    ///
    /// - Note: This value is set using the ``View/ykCenterHubShadowColor(_:)`` modifier.
    public var ykCenterHubShadowColor: Color {
        get { self[YKCenterHubShadowColorKey.self] }
        set { self[YKCenterHubShadowColorKey.self] = newValue }
    }
}
