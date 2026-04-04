//
//  YKSpinWheelUI.swift
//  YKSpinWheel
//
//  Created by Yakup Kavak on 1.04.2026.
//

import SwiftUI

// MARK: - YKSpinWheelUI View

/// A customizable visual component for rendering a spin wheel.
///
/// The `YKSpinWheelUI` struct provides a flexible and customizable wheel layout that iterates through an array of `SpinModel`s. It leverages SwiftUI's environment system to allow for extensive customization of its appearance, including the center hub's color, size, icon, and the top indicator pointer's properties.
///
/// `YKSpinWheelUI` supports various initializers to accommodate different configurations, allowing you to pass custom views for the center hub and the top pointer, or fall back to the default styling via empty views.
///
/// - Note: `YKSpinWheelUI` is marked with `@MainActor` to ensure that all UI updates occur on the main thread.
///
/// - Example:
/// ```swift
/// YKSpinWheelUI(spinModels: myModels, controller: myController)
///     .ykCenterHubColor(.black)
///     .ykCenterIconColor(.yellow)
///     .ykCenterIconName("play.fill")
///     .ykPointerColor(.orange)
/// ```
@MainActor
@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
public struct YKSpinWheelUI<Center: View, WheelTopPointer: View>: View {
    
    // MARK: - Properties
    
    /// The custom view for the center hub of the wheel.
    private let center: Center
    
    /// The custom view for the top indicator pointer of the wheel.
    private let wheelTopPointer: WheelTopPointer
    
    /// The controller managing the state and spin logic of the wheel.
    @ObservedObject var controller: YKSpinController
    
    /// The array of models representing the slices of the wheel.
    public let spinModels: [SpinModel]
    
    /// The dynamically calculated angle for each slice based on the total number of models.
    private var sliceAngle: Double {
        spinModels.isEmpty ? 360.0 : 360.0 / Double(spinModels.count)
    }
        
    // MARK: - Environment Variables (Center Hub)
    
    /// The background color of the center hub, sourced from the environment.
    @Environment(\.ykCenterHubColor) private var centerHubColor
    
    /// The size (width and height) of the center hub, sourced from the environment.
    @Environment(\.ykCenterHubSize) private var centerHubSize
    
    /// The shadow color of the center hub, sourced from the environment.
    @Environment(\.ykCenterHubShadowColor) private var centerHubShadowColor
    
    /// The shadow radius of the center hub, sourced from the environment.
    @Environment(\.ykCenterHubShadowRadius) private var centerHubShadowRadius
    
    /// The vertical shadow offset of the center hub, sourced from the environment.
    @Environment(\.ykCenterHubShadowY) private var centerHubShadowY
    
    /// The color of the icon inside the center hub, sourced from the environment.
    @Environment(\.ykCenterIconColor) private var centerIconColor
    
    /// The size of the icon inside the center hub, sourced from the environment.
    @Environment(\.ykCenterIconSize) private var centerIconSize
    
    /// The SF Symbol name for the center hub icon, sourced from the environment.
    @Environment(\.ykCenterIconName) private var centerIconName
    
    // MARK: - Environment Variables (Pointer)
    
    /// The color of the top indicator pointer, sourced from the environment.
    @Environment(\.ykPointerColor) private var pointerColor
    
    /// The width of the top indicator pointer, sourced from the environment.
    @Environment(\.ykPointerWidth) private var pointerWidth
    
    /// The height of the top indicator pointer, sourced from the environment.
    @Environment(\.ykPointerHeight) private var pointerHeight
    
    /// The Y offset of the top indicator pointer to adjust overlap, sourced from the environment.
    @Environment(\.ykPointerOffset) private var pointerOffset
    
    // MARK: - Animation
    
    /// The calculated animation curve based on the environment variables.
    private var spinAnimation: Animation {
        Animation
            .easeOut(duration: Double(controller.spinRepeatCount) * controller.spinTime)
            .repeatCount(controller.spinRepeatCount, autoreverses: false)
    }
    
    // MARK: - Initialization
    
    /// Initializes a `YKSpinWheelUI` with custom views for both the center hub and the top pointer.
    ///
    /// - Parameters:
    ///   - spinModels: An array of `SpinModel` representing the data for each slice.
    ///   - controller: The `YKSpinController` managing the spin state.
    ///   - center: A view builder that provides a custom center hub.
    ///   - wheelTopPointer: A view builder that provides a custom top pointer.
    @MainActor
    public init(
        spinModels: [SpinModel],
        controller: YKSpinController,
        @ViewBuilder center: () -> Center,
        @ViewBuilder wheelTopPointer: () -> WheelTopPointer
    ) {
        self.spinModels = spinModels
        self.controller = controller
        self.center = center()
        self.wheelTopPointer = wheelTopPointer()
    }
    
    // MARK: - Body
    
    /// The body of the `YKSpinWheelUI` view.
    ///
    /// Composes the wheel slices, center hub, and top indicator pointer. Automatically calculates geometry to ensure the wheel is a perfect circle that fits its container.
    public var body: some View {
        GeometryReader { geometry in
            let minDimension = min(geometry.size.width, geometry.size.height)
            let wheelRadius = minDimension / 2.0
            
            ZStack {
                
                // MARK: Wheel Slices
                Group {
                    ForEach(Array(spinModels.enumerated()), id: \.element.id) { index, model in
                        buildPiece(for: model)
                            .rotationEffect(Angle(degrees: Double(index) * sliceAngle))
                    }
                }
                .rotationEffect(Angle(degrees: controller.spinDegrees))
                .animation(spinAnimation, value: controller.spinDegrees)
                
                // MARK: Center Hub Component
                if Center.self == EmptyView.self {
                    ZStack {
                        Circle()
                            .fill(centerHubColor)
                            .frame(width: centerHubSize, height: centerHubSize)
                            .shadow(color: centerHubShadowColor, radius: centerHubShadowRadius, x: 0, y: centerHubShadowY)
                        
                        Image(systemName: centerIconName)
                            .font(.system(size: centerIconSize, weight: .bold))
                            .foregroundColor(centerIconColor)
                    }
                    .accessibilityElement(children: .ignore)
                } else {
                    center
                }
                
                // MARK: Top Indicator Triangle
                if WheelTopPointer.self == EmptyView.self {
                    TriangleShape()
                        .fill(pointerColor)
                        .frame(width: pointerWidth, height: pointerHeight)
                        .offset(y: -wheelRadius + pointerOffset)
                } else {
                    wheelTopPointer
                }
            }
            .frame(width: minDimension, height: minDimension)
            .position(x: geometry.size.width / 2, y: geometry.size.height / 2)
        }
    }
}

// MARK: - View Builders

private extension YKSpinWheelUI {
    
    /// Constructs the individual slice (piece) based on the provided model data.
    ///
    /// Extracted into a separate `@ViewBuilder` to prevent SwiftUI compiler timeouts and keep the rendering tree clean.
    @ViewBuilder
    func buildPiece(for model: SpinModel) -> some View {
        if let sfImage = model.sfImageName {
            if let textKey = model.textKey {
                YKPieceUI(titleKey: textKey, systemImage: sfImage, sliceAngle: sliceAngle, backgroundView: model.background)
            } else if let textString = model.textString {
                YKPieceUI(title: textString, systemImage: sfImage, sliceAngle: sliceAngle, backgroundView: model.background)
            } else {
                YKPieceUI(systemImage: sfImage, sliceAngle: sliceAngle, backgroundView: model.background)
            }
        } else if let customIcon = model.customImage {
            if let textKey = model.textKey {
                YKPieceUI(titleKey: textKey, customImage: customIcon, sliceAngle: sliceAngle, backgroundView: model.background)
            } else if let textString = model.textString {
                YKPieceUI(title: textString, customImage: customIcon, sliceAngle: sliceAngle, backgroundView: model.background)
            } else {
                YKPieceUI(customImage: customIcon, sliceAngle: sliceAngle, backgroundView: model.background)
            }
        } else if let assetImage = model.image {
            if let textKey = model.textKey {
                YKPieceUI(titleKey: textKey, image: assetImage, sliceAngle: sliceAngle, backgroundView: model.background)
            } else if let textString = model.textString {
                YKPieceUI(title: textString, image: assetImage, sliceAngle: sliceAngle, backgroundView: model.background)
            } else {
                YKPieceUI(image: assetImage, sliceAngle: sliceAngle, backgroundView: model.background)
            }
        } else {
            if let textKey = model.textKey {
                YKPieceUI(titleKey: textKey, sliceAngle: sliceAngle, backgroundView: model.background)
            } else if let textString = model.textString {
                YKPieceUI(title: textString, sliceAngle: sliceAngle, backgroundView: model.background)
            }
        }
    }
}

// MARK: - YKSpinWheelUI Extensions for Specific Initializers

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension YKSpinWheelUI where Center == EmptyView, WheelTopPointer == EmptyView {
    
    /// Initializes a `YKSpinWheelUI` with the default center hub and default top pointer.
    ///
    /// - Parameters:
    ///   - spinModels: An array of `SpinModel` representing the data for each slice.
    ///   - controller: The `YKSpinController` managing the spin state.
    ///
    /// - Example:
    /// ```swift
    /// YKSpinWheelUI(spinModels: models, controller: myController)
    /// ```
    @MainActor
    public init(spinModels: [SpinModel], controller: YKSpinController) {
        self.spinModels = spinModels
        self.controller = controller
        self.center = EmptyView()
        self.wheelTopPointer = EmptyView()
    }
}

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension YKSpinWheelUI where Center == EmptyView {
    
    /// Initializes a `YKSpinWheelUI` with a custom top pointer and the default center hub.
    ///
    /// - Parameters:
    ///   - spinModels: An array of `SpinModel` representing the data for each slice.
    ///   - controller: The `YKSpinController` managing the spin state.
    ///   - wheelTopPointer: A view builder that provides a custom top pointer.
    ///
    /// - Example:
    /// ```swift
    /// YKSpinWheelUI(spinModels: models, controller: myController) {
    ///     Image(systemName: "arrow.down")
    /// }
    /// ```
    @MainActor
    public init(
        spinModels: [SpinModel],
        controller: YKSpinController,
        @ViewBuilder wheelTopPointer: () -> WheelTopPointer
    ) {
        self.spinModels = spinModels
        self.controller = controller
        self.center = EmptyView()
        self.wheelTopPointer = wheelTopPointer()
    }
}

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension YKSpinWheelUI where WheelTopPointer == EmptyView {
    
    /// Initializes a `YKSpinWheelUI` with a custom center hub and the default top pointer.
    ///
    /// - Parameters:
    ///   - spinModels: An array of `SpinModel` representing the data for each slice.
    ///   - controller: The `YKSpinController` managing the spin state.
    ///   - center: A view builder that provides a custom center hub.
    ///
    /// - Example:
    /// ```swift
    /// YKSpinWheelUI(spinModels: models, controller: myController) {
    ///     Text("SPIN")
    ///         .font(.caption)
    ///         .bold()
    /// }
    /// ```
    @MainActor
    public init(
        spinModels: [SpinModel],
        controller: YKSpinController,
        @ViewBuilder center: () -> Center
    ) {
        self.spinModels = spinModels
        self.controller = controller
        self.center = center()
        self.wheelTopPointer = EmptyView()
    }
}

// MARK: - Preview

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
struct YKSpinWheelUI_Previews: PreviewProvider {
    
    struct WheelTestContainer: View {
        
        @StateObject var spinController = YKSpinController()
        
        var body: some View {
            
            let sampleModels: [SpinModel] = [
                
                SpinModel(
                    id: 1,
                    text: "PASS",
                    background: Color.red
                ),
                
                SpinModel(
                    id: 2,
                    text: "1000",
                    sfImageName: "star.fill",
                    background: Color.orange
                ),
                
                SpinModel(
                    id: 3,
                    sfImageName: "gift.fill",
                    background: Color.green
                ),

                SpinModel(
                    id: 4,
                    text: "VIP",
                    customImage: AnyView(
                        ZStack {
                            Circle()
                                .fill(Color.white)
                                .shadow(radius: 2)
                            Text("KF")
                                .font(.caption2)
                                .bold()
                                .foregroundColor(.purple)
                        }.frame(width: 40, height: 40)
                    ),
                    background: Color.purple
                ),
                
                SpinModel(
                    id: 5,
                    text: "500",
                    image: Image(systemName: "bolt.fill"),
                    background: Color.blue
                ),
                
                SpinModel(
                    id: 6,
                    text: "BANKRUPT",
                    background: Color.black
                )
            ]
            
            ZStack {
                Color(red: 0.95, green: 0.95, blue: 0.97)
                    .ignoresSafeArea()
                
                VStack(spacing: 50) {
                    Text("YKSpinWheelUI")
                        .font(.largeTitle)
                        .fontWeight(.heavy)
                        .foregroundColor(.primary)
                    
                    // Çarkıfelek Görünümü
                    YKSpinWheelUI(spinModels: sampleModels, controller: spinController)
                        .shadow(color: .black.opacity(0.1), radius: 15, x: 0, y: 10)
                        // Özelleştirme Örnekleri (Görmek için yorum satırlarını kaldırabilirsiniz):
                        // .ykCenterHubColor(.black)
                        // .ykCenterIconColor(.yellow)
                        // .ykCenterIconName("play.fill")
                        // .ykPointerColor(.orange)
                        // .ykPointerOffset(8)
                        // .ykPointerWidth(40)
                    
                    Button("Test Spin") {
                        Task {
                            _ = await spinController.startSpin(models: sampleModels)
                        }
                    }
                    .padding()
                    .frame(width: 150)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(12)
                    .shadow(color: .blue.opacity(0.3), radius: 5, x: 0, y: 3)
                }
            }
        }
    }
    
    static var previews: some View {
        WheelTestContainer()
    }
}
