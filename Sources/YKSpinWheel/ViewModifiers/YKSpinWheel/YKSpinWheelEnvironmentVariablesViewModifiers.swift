//
//  YKSpinWheelEnvironmentVariablesViewModifiers.swift
//  YKSpinWheel
//
//  Created by Yakup Kavak on 4.04.2026.
//

import SwiftUI

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
public extension View {
    
    /// Sets the background color of the `YKSpinWheelUI`'s center hub.
    ///
    /// - Parameter color: The color to set as the center hub's background. Default is `.white`.
    /// - Returns: A view that applies the specified color.
    ///
    /// - Example:
    /// ```swift
    /// YKSpinWheelUI(spinModels: models, controller: myController)
    ///     .ykCenterHubColor(.black)
    /// ```
    func ykCenterHubColor(_ color: Color) -> some View {
        environment(\.ykCenterHubColor, color)
    }
    
    /// Sets the size of the `YKSpinWheelUI`'s center hub.
    ///
    /// - Parameter size: The width and height of the circular hub. Default is `50.0`.
    /// - Returns: A view that applies the specified size.
    ///
    /// - Example:
    /// ```swift
    /// YKSpinWheelUI(spinModels: models, controller: myController)
    ///     .ykCenterHubSize(60)
    /// ```
    func ykCenterHubSize(_ size: CGFloat) -> some View {
        environment(\.ykCenterHubSize, size)
    }
    
    /// Sets the shadow color of the `YKSpinWheelUI`'s center hub.
    ///
    /// - Parameter color: The color of the shadow. Default is `.black.opacity(0.15)`.
    /// - Returns: A view that applies the specified shadow color.
    func ykCenterHubShadowColor(_ color: Color) -> some View {
        environment(\.ykCenterHubShadowColor, color)
    }
    
    /// Sets the shadow radius of the `YKSpinWheelUI`'s center hub.
    ///
    /// - Parameter radius: The blur radius of the shadow. Default is `5.0`.
    /// - Returns: A view that applies the specified shadow radius.
    func ykCenterHubShadowRadius(_ radius: CGFloat) -> some View {
        environment(\.ykCenterHubShadowRadius, radius)
    }
    
    /// Sets the vertical shadow offset of the `YKSpinWheelUI`'s center hub.
    ///
    /// - Parameter yOffset: The Y offset of the shadow. Default is `3.0`.
    /// - Returns: A view that applies the specified shadow offset.
    func ykCenterHubShadowY(_ yOffset: CGFloat) -> some View {
        environment(\.ykCenterHubShadowY, yOffset)
    }
    
    /// Sets the color of the icon inside the `YKSpinWheelUI`'s center hub.
    ///
    /// - Parameter color: The color of the SF Symbol icon. Default is a purple hue.
    /// - Returns: A view that applies the specified icon color.
    ///
    /// - Example:
    /// ```swift
    /// YKSpinWheelUI(spinModels: models, controller: myController)
    ///     .ykCenterIconColor(.yellow)
    /// ```
    func ykCenterIconColor(_ color: Color) -> some View {
        environment(\.ykCenterIconColor, color)
    }
    
    /// Sets the size of the icon inside the `YKSpinWheelUI`'s center hub.
    ///
    /// - Parameter size: The font size of the SF Symbol icon. Default is `28.0`.
    /// - Returns: A view that applies the specified icon size.
    func ykCenterIconSize(_ size: CGFloat) -> some View {
        environment(\.ykCenterIconSize, size)
    }
    
    /// Sets the SF Symbol name for the icon inside the `YKSpinWheelUI`'s center hub.
    ///
    /// - Parameter name: The exact string name of the SF Symbol. Default is `"sparkles"`.
    /// - Returns: A view that applies the specified icon.
    ///
    /// - Example:
    /// ```swift
    /// YKSpinWheelUI(spinModels: models, controller: myController)
    ///     .ykCenterIconName("play.fill")
    /// ```
    func ykCenterIconName(_ name: String) -> some View {
        environment(\.ykCenterIconName, name)
    }
    
    /// Sets the color of the `YKSpinWheelUI`'s top indicator pointer.
    ///
    /// - Parameter color: The fill color of the top pointer. Default is a dark purple hue.
    /// - Returns: A view that applies the specified pointer color.
    ///
    /// - Example:
    /// ```swift
    /// YKSpinWheelUI(spinModels: models, controller: myController)
    ///     .ykPointerColor(.red)
    /// ```
    func ykPointerColor(_ color: Color) -> some View {
        environment(\.ykPointerColor, color)
    }
    
    /// Sets the width of the `YKSpinWheelUI`'s top indicator pointer.
    ///
    /// - Parameter width: The width of the pointer shape. Default is `30.0`.
    /// - Returns: A view that applies the specified pointer width.
    func ykPointerWidth(_ width: CGFloat) -> some View {
        environment(\.ykPointerWidth, width)
    }
    
    /// Sets the height of the `YKSpinWheelUI`'s top indicator pointer.
    ///
    /// - Parameter height: The height of the pointer shape. Default is `30.0`.
    /// - Returns: A view that applies the specified pointer height.
    func ykPointerHeight(_ height: CGFloat) -> some View {
        environment(\.ykPointerHeight, height)
    }
    
    /// Sets the Y offset of the `YKSpinWheelUI`'s top indicator pointer.
    ///
    /// This modifier allows you to adjust how deep the pointer sits inside the wheel.
    ///
    /// - Parameter offset: The offset value to apply. Positive values push it downwards (into the wheel). Default is `0.0`.
    /// - Returns: A view that applies the specified pointer offset.
    ///
    /// - Example:
    /// ```swift
    /// YKSpinWheelUI(spinModels: models, controller: myController)
    ///     .ykPointerOffset(5) // Pushes the pointer 5 points deeper into the wheel
    /// ```
    func ykPointerOffset(_ offset: CGFloat) -> some View {
        environment(\.ykPointerOffset, offset)
    }
}
