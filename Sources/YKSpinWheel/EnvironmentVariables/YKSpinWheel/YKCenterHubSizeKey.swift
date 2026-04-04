//
//  YKCenterHubSizeKey.swift
//  YKSpinWheel
//
//  Created by Yakup Kavak on 4.04.2026.
//

import SwiftUI

/// An environment key for the center hub's size.
@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
public struct YKCenterHubSizeKey: @preconcurrency EnvironmentKey {
    /// The default size (width and height) for the center hub of `YKSpinWheelUI`.
    @MainActor public static var defaultValue: CGFloat = 50.0
}

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension EnvironmentValues {
    
    /// The size (width and height) of the center hub.
    ///
    /// - Note: This value is set using the ``View/ykCenterHubSize(_:)`` modifier.
    public var ykCenterHubSize: CGFloat {
        get { self[YKCenterHubSizeKey.self] }
        set { self[YKCenterHubSizeKey.self] = newValue }
    }
}
