//
//  YKCenterIconSizeKey.swift
//  YKSpinWheel
//
//  Created by Yakup Kavak on 4.04.2026.
//

import SwiftUI

/// An environment key for the center hub's icon size.
@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
public struct YKCenterIconSizeKey: @preconcurrency EnvironmentKey {
    /// The default icon size for the center hub of `YKSpinWheelUI`.
    @MainActor public static var defaultValue: CGFloat = 28.0
}

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension EnvironmentValues {
    
    /// The size of the icon inside the center hub.
    ///
    /// - Note: This value is set using the ``View/ykCenterIconSize(_:)`` modifier.
    public var ykCenterIconSize: CGFloat {
        get { self[YKCenterIconSizeKey.self] }
        set { self[YKCenterIconSizeKey.self] = newValue }
    }
}
