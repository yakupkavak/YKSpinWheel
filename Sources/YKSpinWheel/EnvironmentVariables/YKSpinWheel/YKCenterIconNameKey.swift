//
//  YKCenterIconNameKey.swift
//  YKSpinWheel
//
//  Created by Yakup Kavak on 4.04.2026.
//

import SwiftUI

/// An environment key for the center hub's icon name.
@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
public struct YKCenterIconNameKey: @preconcurrency EnvironmentKey {
    /// The default SF Symbol name for the center hub of `YKSpinWheelUI`.
    @MainActor public static var defaultValue: String = "sparkles"
}

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension EnvironmentValues {
    
    /// The SF Symbol name of the icon inside the center hub.
    ///
    /// - Note: This value is set using the ``View/ykCenterIconName(_:)`` modifier.
    public var ykCenterIconName: String {
        get { self[YKCenterIconNameKey.self] }
        set { self[YKCenterIconNameKey.self] = newValue }
    }
}
