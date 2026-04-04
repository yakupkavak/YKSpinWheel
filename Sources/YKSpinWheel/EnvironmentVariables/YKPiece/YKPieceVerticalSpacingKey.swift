//
//  YKSpinPieceVerticalSpacingKey.swift
//  YKSpinWheel
//
//  Created by Yakup Kavak on 1.04.2026.
//

import SwiftUI

/// An environment key for the spin's time duration.
@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
public struct YKPieceVerticalSpacingKey: @preconcurrency EnvironmentKey  {
    /// The default spin time for `YKSpinWheel`.
    @MainActor public static var defaultValue: CGFloat = 8
}

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension EnvironmentValues {
    
    /// The background color of the `YKPiece`.
    ///
    /// - Note: This value is set using the ``View/cardBackgroundColor(_:)`` modifier.
    public var ykPieceVerticalSpacing: CGFloat {
        get { self[YKPieceVerticalSpacingKey.self] }
        set { self[YKPieceVerticalSpacingKey.self] = newValue }
    }
}
