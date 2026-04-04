//
//  YKCenterHubShadowRadiusKey.swift
//  YKSpinWheel
//
//  Created by Yakup Kavak on 4.04.2026.
//

import SwiftUI

/// An environment key for the center hub's shadow radius.
@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
public struct YKCenterHubShadowRadiusKey: @preconcurrency EnvironmentKey {
    /// The default shadow radius for the center hub of `YKSpinWheelUI`.
    @MainActor public static var defaultValue: CGFloat = 5.0
}

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension EnvironmentValues {
    
    /// The shadow radius of the center hub.
    ///
    /// - Note: This value is set using the ``View/ykCenterHubShadowRadius(_:)`` modifier.
    public var ykCenterHubShadowRadius: CGFloat {
        get { self[YKCenterHubShadowRadiusKey.self] }
        set { self[YKCenterHubShadowRadiusKey.self] = newValue }
    }
}
