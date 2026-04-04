//
//  YKPieceEnvironmentVariablesViewModifiers.swift
//  YKSpinWheel
//
//  Created by Yakup Kavak on 1.04.2026.
//

import SwiftUI

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
public extension View {
    
    /// Sets the vertical spacing for a `YKPieceUI`.
    ///
    /// Use this modifier to customize the distance between the image and the text inside a slice.
    ///
    /// - Parameter spacing: The vertical spacing value.
    /// - Returns: A view that applies the specified vertical spacing.
    ///
    /// - Example:
    /// ```swift
    /// YKPieceUI(...)
    ///     .ykPieceVerticalSpacing(12.0)
    /// ```
    func ykPieceVerticalSpacing(_ spacing: CGFloat) -> some View {
        environment(\.ykPieceVerticalSpacing, spacing)
    }
    
    /// Sets the gap angle between slices for a `YKPieceUI`.
    ///
    /// Use this modifier to increase or decrease the empty space between each wheel slice.
    ///
    /// - Parameter angle: The gap angle in degrees.
    /// - Returns: A view that applies the specified spacing angle.
    ///
    /// - Example:
    /// ```swift
    /// YKPieceUI(...)
    ///     .ykPieceSpacingAngle(3.0)
    /// ```
    func ykPieceSpacingAngle(_ angle: Double) -> some View {
        environment(\.ykPieceSpacingAngle, angle)
    }
    
    /// Sets the inner hole radius for a `YKPieceUI`.
    ///
    /// Use this modifier to adjust the size of the hole at the center of the wheel.
    ///
    /// - Parameter radius: The radius of the inner hole.
    /// - Returns: A view that applies the specified inner radius.
    func ykPieceInnerRadius(_ radius: CGFloat) -> some View {
        environment(\.ykPieceInnerRadius, radius)
    }
    
    /// Sets the outer corner radius for a `YKPieceUI`.
    ///
    /// Use this modifier to control how rounded the outer edges of the slice will appear.
    ///
    /// - Parameter radius: The corner radius value.
    /// - Returns: A view that applies the specified corner radius.
    func ykPieceCornerRadius(_ radius: CGFloat) -> some View {
        environment(\.ykPieceCornerRadius, radius)
    }
    
    /// Sets the text color for a `YKPieceUI`.
    ///
    /// - Parameter color: The color applied to the text inside the slice.
    /// - Returns: A view that applies the specified text color.
    func ykPieceTextColor(_ color: Color) -> some View {
        environment(\.ykPieceTextColor, color)
    }
    
    /// Sets the content shadow color for a `YKPieceUI`.
    ///
    /// - Parameter color: The shadow color for the inner content (text and icon).
    /// - Returns: A view that applies the specified shadow color.
    func ykPieceShadowColor(_ color: Color) -> some View {
        environment(\.ykPieceShadowColor, color)
    }
    
    /// Sets the content shadow radius for a `YKPieceUI`.
    ///
    /// - Parameter radius: The blur radius of the content's shadow.
    /// - Returns: A view that applies the specified shadow radius.
    func ykPieceShadowRadius(_ radius: CGFloat) -> some View {
        environment(\.ykPieceShadowRadius, radius)
    }
    
    /// Sets the vertical shadow offset for a `YKPieceUI`.
    ///
    /// - Parameter yOffset: The Y offset for the content's shadow.
    /// - Returns: A view that applies the specified vertical shadow offset.
    func ykPieceShadowY(_ yOffset: CGFloat) -> some View {
        environment(\.ykPieceShadowY, yOffset)
    }
    
    /// Sets the maximum number of text lines for a normal (wide) slice in `YKPieceUI`.
    ///
    /// By default, a normal slice limits text to 2 lines. You can use this modifier to allow more lines or restrict it to a single line.
    ///
    /// - Parameter limit: The maximum number of lines.
    /// - Returns: A view that applies the specified line limit.
    ///
    /// - Example:
    /// ```swift
    /// YKPieceUI(...)
    ///     .ykPieceNormalLineLimit(3)
    /// ```
    func ykPieceNormalLineLimit(_ limit: Int) -> some View {
        environment(\.ykPieceNormalLineLimit, limit)
    }
}
