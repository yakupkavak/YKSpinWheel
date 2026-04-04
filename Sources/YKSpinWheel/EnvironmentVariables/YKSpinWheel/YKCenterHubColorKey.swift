//
//  YKCenterHubColorKey.swift
//  YKSpinWheel
//
//  Created by Yakup Kavak on 4.04.2026.
//

import SwiftUI

/// An environment key for the center hub's background color.
@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
public struct YKCenterHubColorKey: @preconcurrency EnvironmentKey {
    /// The default background color for the center hub of `YKSpinWheelUI`.
    @MainActor public static var defaultValue: Color = .white
}

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension EnvironmentValues {
    
    /// The background color of the center hub.
    ///
    /// - Note: This value is set using the ``View/ykCenterHubColor(_:)`` modifier.
    public var ykCenterHubColor: Color {
        get { self[YKCenterHubColorKey.self] }
        set { self[YKCenterHubColorKey.self] = newValue }
    }
}
