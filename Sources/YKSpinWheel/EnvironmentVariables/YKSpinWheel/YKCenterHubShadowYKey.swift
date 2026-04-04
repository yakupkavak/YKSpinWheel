//
//  Untitled.swift
//  YKSpinWheel
//
//  Created by Yakup Kavak on 4.04.2026.
//

import SwiftUI

/// An environment key for the center hub's vertical shadow offset.
@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
public struct YKCenterHubShadowYKey: @preconcurrency EnvironmentKey {
    /// The default vertical shadow offset for the center hub of `YKSpinWheelUI`.
    @MainActor public static var defaultValue: CGFloat = 3.0
}

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension EnvironmentValues {
    
    /// The vertical shadow offset (Y-axis) of the center hub.
    ///
    /// - Note: This value is set using the ``View/ykCenterHubShadowY(_:)`` modifier.
    public var ykCenterHubShadowY: CGFloat {
        get { self[YKCenterHubShadowYKey.self] }
        set { self[YKCenterHubShadowYKey.self] = newValue }
    }
}
