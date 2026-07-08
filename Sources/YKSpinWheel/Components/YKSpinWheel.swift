//
//  YKSpinWheel.swift
//  YKSpinWheel
//
//  Created by Yakup Kavak on 1.04.2026.
//

import SwiftUI

// MARK: - Constants

/// Internal math constants for wheel calculations to avoid magic numbers.
private enum WheelMathConstants {
    /// A full circle in degrees.
    static let fullCircleDegrees: Double = 360.0
}

// MARK: - YKSpinWheel View

/// A customizable visual component for drawing a dynamic spin wheel.
///
/// The `YKSpinWheel` struct provides a flexible wheel layout that reads an array of `SpinModel` items directly from its controller.
/// It calculates the size of each piece dynamically based on its `weight` property, ensuring pieces are sized proportionally.
/// It uses SwiftUI's environment system to allow for easy appearance customization, including the center hub and the top indicator pointer.
///
/// `YKSpinWheel` supports various initializers to fit different needs, allowing you to pass custom views for the center hub and the top pointer, or just fall back to the default styles.
///
/// - Note: `YKSpinWheel` is marked with `@MainActor` to ensure that all UI updates happen safely on the main thread.
///
/// - Example:
/// ```swift
/// YKSpinWheel(controller: myController)
///     .ykCenterHubColor(.black)
///     .ykCenterIconColor(.yellow)
///     .ykCenterIconName("play.fill")
///     .ykPointerColor(.orange)
/// ```
@MainActor
@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
public struct YKSpinWheel<Center: View, WheelTopPointer: View>: View {
    
    // MARK: - Properties
    
    /// The custom view for the center hub of the wheel.
    private let center: Center
    
    /// The custom view for the top indicator pointer of the wheel.
    private let wheelTopPointer: WheelTopPointer
    
    /// The controller managing the state, models, and spin logic of the wheel.
    @ObservedObject var controller: YKSpinController
    
    // MARK: - Environment Variables (Center Hub)
    
    /// The background color of the center hub.
    @Environment(\.ykCenterHubColor) private var centerHubColor
    
    /// The size (width and height) of the center hub.
    @Environment(\.ykCenterHubSize) private var centerHubSize
    
    /// The shadow color of the center hub.
    @Environment(\.ykCenterHubShadowColor) private var centerHubShadowColor
    
    /// The shadow radius of the center hub.
    @Environment(\.ykCenterHubShadowRadius) private var centerHubShadowRadius
    
    /// The vertical shadow offset of the center hub.
    @Environment(\.ykCenterHubShadowY) private var centerHubShadowY
    
    /// The color of the icon inside the center hub.
    @Environment(\.ykCenterIconColor) private var centerIconColor
    
    /// The size of the icon inside the center hub.
    @Environment(\.ykCenterIconSize) private var centerIconSize
    
    /// The SF Symbol name for the center hub icon.
    @Environment(\.ykCenterIconName) private var centerIconName
    
    // MARK: - Environment Variables (Pointer)
    
    /// The color of the top indicator pointer.
    @Environment(\.ykPointerColor) private var pointerColor
    
    /// The width of the top indicator pointer.
    @Environment(\.ykPointerWidth) private var pointerWidth
    
    /// The height of the top indicator pointer.
    @Environment(\.ykPointerHeight) private var pointerHeight
    
    /// The vertical offset of the top indicator pointer.
    @Environment(\.ykPointerOffset) private var pointerOffset
    
    // MARK: - Animation
    
    /// The calculated animation curve based on the controller's active spin duration.
    private var spinAnimation: Animation {
        Animation
            .easeOut(duration: Double(controller.animationDuration))
    }
    
    // MARK: - Initialization
    
    /// Creates a `YKSpinWheel` with custom views for both the center hub and the top pointer.
    ///
    /// - Parameters:
    ///   - controller: The `YKSpinController` managing the spin state and holding the spin models.
    ///   - center: A view builder that provides a custom center hub.
    ///   - wheelTopPointer: A view builder that provides a custom top pointer.
    @MainActor
    public init(
        controller: YKSpinController,
        @ViewBuilder center: () -> Center,
        @ViewBuilder wheelTopPointer: () -> WheelTopPointer
    ) {
        self.controller = controller
        self.center = center()
        self.wheelTopPointer = wheelTopPointer()
    }
    
    // MARK: - Body
    
    /// The body of the `YKSpinWheel` view.
    ///
    /// It puts together the wheel slices, center hub, and top indicator pointer. It automatically calculates geometry to ensure the wheel is a perfect circle that fits its container.
    public var body: some View {
        GeometryReader { geometry in
            let minDimension = min(geometry.size.width, geometry.size.height)
            let wheelRadius = minDimension / 2.0
            
            ZStack {
                
                Group {
                    ForEach(Array(controller.spinModels.enumerated()), id: \.element.id) { index, model in
                        buildPiece(for: model, sliceAngle: spinSliceAngle(for: model))
                            .rotationEffect(Angle(degrees: centerAngle(for: index)))
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
                        .frame(width: centerHubSize, height: centerHubSize)
                        .shadow(color: centerHubShadowColor, radius: centerHubShadowRadius, x: 0, y: centerHubShadowY)
                        .clipShape(Circle())
                }
                
                // MARK: Top Indicator Triangle
                if WheelTopPointer.self == EmptyView.self {
                    TriangleShape()
                        .fill(pointerColor)
                        .frame(width: pointerWidth, height: pointerHeight)
                        .offset(y: -wheelRadius + pointerOffset)
                } else {
                    wheelTopPointer
                        .frame(width: pointerWidth, height: pointerHeight)
                        .offset(y: -wheelRadius + pointerOffset)
                }
            }
            .frame(width: minDimension, height: minDimension)
            .position(x: geometry.size.width / 2, y: geometry.size.height / 2)
        }
    }
}

// MARK: - Math Helpers

private extension YKSpinWheel {
    
    /// The total combined weight of all models in the wheel.
    var totalWeight: Double {
        controller.spinModels.reduce(0.0) { $0 + $1.weight }
    }
    
    /// Calculates how wide a single piece should be based on its weight.
    func spinSliceAngle(for model: SpinModel) -> Double {
        totalWeight == 0 ? 0 : (model.weight / totalWeight) * WheelMathConstants.fullCircleDegrees
    }
    
    /// Calculates the exact rotation angle needed to place a piece perfectly on the wheel.
    /// It keeps the very first piece centered at the top.
    func centerAngle(for index: Int) -> Double {
        if totalWeight == 0 { return 0 }
        
        var previousWeights = 0.0
        for i in 0..<index {
            previousWeights += controller.spinModels[i].weight
        }
        
        let currentWeight = controller.spinModels[index].weight
        let firstWeight = controller.spinModels.first?.weight ?? 0
        let offsetWeight = previousWeights + (currentWeight / 2.0) - (firstWeight / 2.0)
        
        return (offsetWeight / totalWeight) * WheelMathConstants.fullCircleDegrees
    }
}

// MARK: - View Builders

private extension YKSpinWheel {
    
    /// Creates the individual slice (piece) based on the provided model data and its calculated angle.
    @ViewBuilder
    func buildPiece(for model: SpinModel, sliceAngle: Double) -> some View {
        if let sfImage = model.sfImageName {
            if let textKey = model.textKey {
                YKPieceUI(titleKey: textKey, systemImage: sfImage, sliceAngle: sliceAngle, textColor: model.textColor, backgroundView: model.background)
            } else if let textString = model.textString {
                YKPieceUI(title: textString, systemImage: sfImage, sliceAngle: sliceAngle, textColor: model.textColor, backgroundView: model.background)
            } else {
                YKPieceUI(systemImage: sfImage, sliceAngle: sliceAngle, backgroundView: model.background)
            }
        } else if let customIcon = model.customImage {
            if let textKey = model.textKey {
                YKPieceUI(titleKey: textKey, customImage: customIcon, sliceAngle: sliceAngle, textColor: model.textColor, backgroundView: model.background)
            } else if let textString = model.textString {
                YKPieceUI(title: textString, customImage: customIcon, sliceAngle: sliceAngle, textColor: model.textColor, backgroundView: model.background)
            } else {
                YKPieceUI(customImage: customIcon, sliceAngle: sliceAngle, backgroundView: model.background)
            }
        } else if let assetImage = model.image {
            if let textKey = model.textKey {
                YKPieceUI(titleKey: textKey, image: assetImage, sliceAngle: sliceAngle, textColor: model.textColor, backgroundView: model.background)
            } else if let textString = model.textString {
                YKPieceUI(title: textString, image: assetImage, sliceAngle: sliceAngle, textColor: model.textColor, backgroundView: model.background)
            } else {
                YKPieceUI(image: assetImage, sliceAngle: sliceAngle, backgroundView: model.background)
            }
        } else {
            if let textKey = model.textKey {
                YKPieceUI(titleKey: textKey, sliceAngle: sliceAngle, textColor: model.textColor, backgroundView: model.background)
            } else if let textString = model.textString {
                YKPieceUI(title: textString, sliceAngle: sliceAngle, textColor: model.textColor, backgroundView: model.background)
            }
        }
    }
}

// MARK: - Extensions for Specific Initializers

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
public extension YKSpinWheel where Center == EmptyView, WheelTopPointer == EmptyView {
    
    /// Creates a `YKSpinWheel` with the default center hub and default top pointer.
    ///
    /// - Parameters:
    ///   - controller: The `YKSpinController` managing the spin state.
    @MainActor
    init(controller: YKSpinController) {
        self.controller = controller
        self.center = EmptyView()
        self.wheelTopPointer = EmptyView()
    }
}

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
public extension YKSpinWheel where Center == EmptyView {
    
    /// Creates a `YKSpinWheel` with a custom top pointer and the default center hub.
    ///
    /// - Parameters:
    ///   - controller: The `YKSpinController` managing the spin state.
    ///   - wheelTopPointer: A view builder that provides a custom top pointer.
    @MainActor
    init(
        controller: YKSpinController,
        @ViewBuilder wheelTopPointer: () -> WheelTopPointer
    ) {
        self.controller = controller
        self.center = EmptyView()
        self.wheelTopPointer = wheelTopPointer()
    }
}

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
public extension YKSpinWheel where WheelTopPointer == EmptyView {
    
    /// Creates a `YKSpinWheel` with a custom center hub and the default top pointer.
    ///
    /// - Parameters:
    ///   - controller: The `YKSpinController` managing the spin state.
    ///   - center: A view builder that provides a custom center hub.
    @MainActor
    init(
        controller: YKSpinController,
        @ViewBuilder center: () -> Center
    ) {
        self.controller = controller
        self.center = center()
        self.wheelTopPointer = EmptyView()
    }
}

// MARK: - Preview

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
struct YKSpinWheel_Previews: PreviewProvider {
    
    struct WheelTestContainer: View {
        
        @State var spinControllers: [YKSpinController]
        @State private var isSpinningAll: Bool = false
        
        init() {
            let models = [
                SpinModel(id: 1, text: "PASS", weight: 1.0, background: Color.red),
                SpinModel(id: 2, text: "1000", sfImageName: "star.fill", weight: 2.5, textColor: .black, background: Color.orange),
                SpinModel(id: 3, sfImageName: "gift.fill", weight: 1.0, background: Color.green),
                SpinModel(
                    id: 4,
                    text: "VIP",
                    customImage: AnyView(
                        ZStack {
                            Circle().fill(Color.white).shadow(radius: 2)
                            Text("KF").font(.caption2).bold().foregroundColor(.purple)
                        }.frame(width: 40, height: 40)
                    ),
                    weight: 1.5,
                    textColor: .yellow,
                    background: Color.purple
                ),
                SpinModel(id: 5, text: "5000000", image: Image(systemName: "bolt.fill"), weight: 1.0, textColor: .white, background: Color.blue),
                SpinModel(id: 6, text: "BANKRUPT", weight: 2.0, textColor: .red, background: Color.black)
            ]
            _spinControllers = State(initialValue: (0..<100).map { _ in YKSpinController(models: models) })
        }
        
        var body: some View {
            ZStack {
                Color(red: 0.95, green: 0.95, blue: 0.97)
                    .ignoresSafeArea()
                
                VStack(spacing: 20) {
                    
                    Text("100 Spins Test")
                        .font(.largeTitle)
                        .fontWeight(.heavy)
                        .foregroundColor(.primary)
                        .padding(.top, 20)
                    
                    Button("Test All 100 Spins") {
                        isSpinningAll = true
                        
                        Task { @MainActor in
                            var spinTasks: [Task<Void, Never>] = []
                            for controller in spinControllers {
                                let task = Task { @MainActor in
                                    _ = await controller.startSpin(spinTime: 3.0, spinTurns: 5)
                                }
                                spinTasks.append(task)
                            }
                            for task in spinTasks {
                                await task.value
                            }
                            isSpinningAll = false
                        }
                    }
                    .padding()
                    .frame(width: 220)
                    .background(isSpinningAll ? Color.gray : Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(12)
                    .shadow(color: .blue.opacity(0.3), radius: 5, x: 0, y: 3)
                    .disabled(isSpinningAll)
                    
                    ScrollView {
                        LazyVStack(spacing: 60) {
                            ForEach(Array(spinControllers.enumerated()), id: \.offset) { index, controller in
                                VStack(spacing: 15) {
                                    Text("Wheel #\(index + 1)")
                                        .font(.headline)
                                        .foregroundColor(.gray)
                                    
                                    YKSpinWheel(controller: controller)
                                        .frame(width: 250, height: 250)
                                        .shadow(color: .black.opacity(0.1), radius: 10, x: 0, y: 5)
                                        .ykPieceNormalLineLimit(2)
                                        .ykCenterHubColor(.black)
                                        .ykCenterIconColor(.yellow)
                                        .ykCenterIconName("play.fill")
                                        .ykPointerColor(.orange)
                                        .ykPointerOffset(8)
                                        .ykPointerWidth(30)
                                }
                            }
                        }
                        .padding(.vertical, 20)
                    }
                }
            }
        }
    }
    
    static var previews: some View {
        WheelTestContainer()
    }
}
