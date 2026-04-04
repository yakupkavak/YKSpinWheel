//
//  YKPieceNormalLineLimitKey.swift
//  YKSpinWheel
//
//  Created by Yakup Kavak on 1.04.2026.
//

import SwiftUI

/// An environment key for the maximum number of lines allowed in a normal slice.
@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
public struct YKPieceNormalLineLimitKey: @preconcurrency EnvironmentKey {
    /// The default line limit for text in a standard (non-thin) slice.
    @MainActor public static var defaultValue: Int = 2
}

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
public extension EnvironmentValues {
    
    /// The maximum number of lines allowed for text when the slice is NOT thin.
    ///
    /// - Note: This value is set using the ``View/ykPieceNormalLineLimit(_:)`` modifier.
    var ykPieceNormalLineLimit: Int {
        get { self[YKPieceNormalLineLimitKey.self] }
        set { self[YKPieceNormalLineLimitKey.self] = newValue }
    }
}
