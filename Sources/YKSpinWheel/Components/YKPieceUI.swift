//
//  YKPieceUI.swift
//  YKSpinWheel
//
//  Created by Yakup Kavak on 1.04.2026.
//

import SwiftUI

// MARK: - Constants

/// Internal layout constants to avoid magic numbers.
/// These ratios help scale the content relative to the wheel's radius.
private enum PieceLayoutConstants {
    /// The radial ratio used to position content closer to the outer edge on a thin slice.
    static let thinSliceContentRadiusRatio: CGFloat = 0.52
    
    /// The radial ratio used to position content closer to the outer edge on a normal (wide) slice.
    static let normalSliceContentRadiusRatio: CGFloat = 0.62
    
    /// The vertical offset ratio applied to the overall content to visually balance it within the slice shape.
    static let contentVerticalOffsetRatio: CGFloat = -0.07
    
    /// The vertical offset ratio applied specifically to the image when stacked vertically in a thin slice.
    static let thinSliceImageVerticalOffsetRatio: CGFloat = -0.22
    
    // MARK: Scaling Constants
    
    static let textScaleThinSliceOnly: CGFloat = 0.09
    static let textScaleNormalSliceOnly: CGFloat = 0.15
    static let textWidthScaleThinSlice: CGFloat = 0.28
    static let textWidthScaleNormalSlice: CGFloat = 0.5
    static let textScaleThinSliceCombined: CGFloat = 0.10
    static let textScaleNormalSliceCombined: CGFloat = 0.12
    static let imageWidthScaleThinSlice: CGFloat = 0.16
    static let imageWidthScaleNormalSlice: CGFloat = 0.30
    static let imageWidthScaleThinSliceCombined: CGFloat = 0.15
}

// MARK: - YKPieceUI View

/// A single customizable slice (piece) of the spin wheel.
///
/// The `YKPieceUI` struct provides a highly flexible and dynamic slice component. It manages the rendering of its background, an optional image, a custom view, and localized text.
/// It seamlessly integrates with SwiftUI's environment system, allowing extensive customization for dimensions, colors, shadows, layout thresholds, and even custom clipping shapes.
///
/// `YKPieceUI` calculates its own geometry and intelligently adapts its layout (e.g., horizontal vs. vertical text stacking) based on the slice's angle.
///
/// - Note: `YKPieceUI` is marked with `@MainActor` to ensure all UI updates happen securely on the main thread.
///
/// - Example:
/// ```swift
/// YKPieceUI(title: "Jackpot", systemImage: "star.fill", sliceAngle: 45.0, backgroundView: AnyView(Color.gold))
///     .ykPieceTextColor(.white)
///     .ykPieceThinSliceAngleThreshold(40.0)
///     .ykPieceNormalLineLimit(3)
///     .ykPieceShape(Capsule()) // Optional custom clipping shape
/// ```
@MainActor
@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
public struct YKPieceUI: View {
    
    // MARK: - Properties
    
    /// The angle of the slice in degrees.
    public let sliceAngle: Double
    
    /// The view used as the background of the slice, automatically clipped to the slice shape.
    public let backgroundView: AnyView
    
    /// The internal resolved image to display. Optional.
    fileprivate let resolvedImage: Image?
    
    /// The internal resolved custom view to display. Optional.
    fileprivate let resolvedCustomImage: AnyView?
    
    /// The internal resolved text to display, supporting localization. Optional.
    fileprivate let resolvedText: Text?
    
    /// An optional color to override the default text color for this specific slice.
    fileprivate let resolvedTextColor: Color?
    
    // MARK: - Environment Variables
    
    /// The vertical spacing between the image and the text.
    @Environment(\.ykPieceVerticalSpacing) private var verticalSpacing
    
    /// The spacing angle (gap) between adjacent slices.
    @Environment(\.ykPieceSpacingAngle) private var spacingAngle
    
    /// The radius of the inner hole of the wheel piece.
    @Environment(\.ykPieceInnerRadius) private var innerRadius
    
    /// The corner radius of the slice's outer edges.
    @Environment(\.ykPieceCornerRadius) private var cornerRadius
    
    /// The color of the text within the slice.
    @Environment(\.ykPieceTextColor) private var textColor
    
    /// The shadow color applied to the content within the slice.
    @Environment(\.ykPieceShadowColor) private var shadowColor
    
    /// The shadow radius applied to the content within the slice.
    @Environment(\.ykPieceShadowRadius) private var shadowRadius
    
    /// The vertical shadow offset applied to the content within the slice.
    @Environment(\.ykPieceShadowY) private var shadowY
    
    /// The maximum angle (in degrees) for a slice to be considered "thin".
    @Environment(\.ykPieceThinSliceAngleThreshold) private var thinSliceAngleThreshold
    
    /// The maximum number of lines allowed for text when the slice is NOT thin.
    @Environment(\.ykPieceNormalLineLimit) private var normalLineLimit

    /// Determines if the slice is too thin to display text horizontally based on the environment threshold.
    private var isThinSlice: Bool {
        return sliceAngle <= thinSliceAngleThreshold
    }

    // MARK: - Body
    
    /// The body of the `YKPieceUI` view.
    ///
    /// It calculates the necessary geometry, applies either a default pie slice shape or a custom shape provided via the environment, and precisely positions the content along the central radial axis.
    public var body: some View {
        GeometryReader { geometry in
            let rect = CGRect(origin: .zero, size: geometry.size)
            let center = CGPoint(x: rect.midX, y: rect.midY)
            let outerRadius = min(rect.width, rect.height) / 2
            let startAngle = Angle(degrees: -90 - (sliceAngle / 2) + spacingAngle)
            let endAngle = Angle(degrees: -90 + (sliceAngle / 2) - spacingAngle)
            let midAngle = Angle(radians: (startAngle.radians + endAngle.radians) / 2)
            let contentRadiusRatio = isThinSlice ? PieceLayoutConstants.thinSliceContentRadiusRatio : PieceLayoutConstants.normalSliceContentRadiusRatio
            let contentRadius: CGFloat = innerRadius + (outerRadius - innerRadius) * contentRadiusRatio
            let contentX = center.x + contentRadius * CGFloat(cos(midAngle.radians))
            let contentY = center.y + contentRadius * CGFloat(sin(midAngle.radians))
            
            ZStack {
                Group {
                    backgroundView
                        .clipShape(
                            PieSliceShape(
                                sliceAngle: sliceAngle,
                                spacingAngle: spacingAngle,
                                innerRadius: innerRadius,
                                cornerRadius: cornerRadius
                            )
                        )
                }
                contentView(radius: outerRadius)
                    .position(x: contentX, y: contentY)
            }
        }
    }
}

// MARK: - Subviews & Modifiers

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
private extension YKPieceUI {
    
    /// Constructs the content inside the slice based on available properties.
    ///
    /// - Parameter radius: The calculated outer radius of the wheel, used for scaling the content.
    /// - Returns: A composed view representing the slice's content.
    @ViewBuilder
    func contentView(radius: CGFloat) -> some View {
        let globalVerticalOffset = radius * PieceLayoutConstants.contentVerticalOffsetRatio
        
        // Scenario 1: Only Text
        if let resolvedText, resolvedImage == nil, resolvedCustomImage == nil {
            let scale = isThinSlice ? PieceLayoutConstants.textScaleThinSliceOnly : PieceLayoutConstants.textScaleNormalSliceOnly
            let widthScale = isThinSlice ? PieceLayoutConstants.textWidthScaleThinSlice : PieceLayoutConstants.textWidthScaleNormalSlice
            
            styledText(resolvedText, radius: radius, fontSizeScale: scale, minScale: 0.7, widthScale: widthScale)
                .offset(y: globalVerticalOffset)
        }
        // Scenario 2: Only Image
        else if let sliceImage = resolvedImage, resolvedText == nil {
            let widthScale = isThinSlice ? PieceLayoutConstants.imageWidthScaleThinSlice : PieceLayoutConstants.imageWidthScaleNormalSlice
            
            styledImage(sliceImage, radius: radius, widthScale: widthScale)
        }
        // Scenario 3: Only Custom View
        else if let customImage = resolvedCustomImage, resolvedText == nil {
            customImage
        }
        // Scenario 4: Custom View + Text
        else if let customImage = resolvedCustomImage, let resolvedText {
            let scale = isThinSlice ? 0.08 : PieceLayoutConstants.textScaleNormalSliceCombined
            let widthScale = isThinSlice ? PieceLayoutConstants.textWidthScaleThinSlice : 0.45
            
            VStack(spacing: verticalSpacing) {
                customImage
                styledText(resolvedText, radius: radius, fontSizeScale: scale, minScale: 0.2, widthScale: widthScale)
            }
            .compositingGroup()
            .offset(y: globalVerticalOffset)
        }
        // Scenario 5: Icon + Text (Most common usage)
        else if let sliceImage = resolvedImage, let textToDisplay = resolvedText {
            if isThinSlice {
                VStack(spacing: verticalSpacing) {
                    styledImage(sliceImage, radius: radius, widthScale: PieceLayoutConstants.imageWidthScaleThinSliceCombined)
                        .offset(y: radius * PieceLayoutConstants.thinSliceImageVerticalOffsetRatio)
                    
                    styledText(textToDisplay, radius: radius, fontSizeScale: PieceLayoutConstants.textScaleThinSliceCombined, minScale: 0.5, widthScale: 0.45)
                        .offset(y: globalVerticalOffset)
                }
                .frame(width: radius * 0.30, height: radius * 0.42)
                .compositingGroup()
            } else {
                VStack(spacing: verticalSpacing) {
                    styledImage(sliceImage, radius: radius, widthScale: PieceLayoutConstants.imageWidthScaleNormalSlice)
                    styledText(textToDisplay, radius: radius, fontSizeScale: PieceLayoutConstants.textScaleNormalSliceCombined, minScale: 0.2, widthScale: PieceLayoutConstants.textWidthScaleNormalSlice)
                }
            }
        }
    }
    
    /// Applies standardized typography, color, and scaling modifications to a text view.
    @ViewBuilder
    func styledText(_ text: Text, radius: CGFloat, fontSizeScale: CGFloat, minScale: CGFloat, widthScale: CGFloat) -> some View {
        text
            .font(.system(size: radius * fontSizeScale, weight: .heavy, design: .rounded))
            .foregroundColor(resolvedTextColor ?? textColor)
            .lineLimit(isThinSlice ? 1 : normalLineLimit)
            .minimumScaleFactor(minScale)
            .frame(width: radius * widthScale)
            .multilineTextAlignment(.center)
            .rotationEffect(.degrees(isThinSlice ? -90 : 0))
    }
    
    /// Applies standardized sizing and shadow modifiers to an image view.
    @ViewBuilder
    func styledImage(_ image: Image, radius: CGFloat, widthScale: CGFloat) -> some View {
        image
            .resizable()
            .scaledToFit()
            .frame(width: radius * widthScale)
            .shadow(color: shadowColor, radius: shadowRadius, x: 0, y: shadowY)
    }
}

// MARK: - YKPieceUI Extensions for Specific Initializers

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
public extension YKPieceUI {
    
    /// Initializes a `YKPieceUI` with a localized title, a system image, and a background.
    init(titleKey: LocalizedStringKey, systemImage: String, sliceAngle: Double, textColor: Color? = nil, backgroundView: AnyView) {
        self.resolvedText = Text(titleKey)
        self.resolvedImage = Image(systemName: systemImage)
        self.resolvedCustomImage = nil
        self.sliceAngle = sliceAngle
        self.resolvedTextColor = textColor
        self.backgroundView = backgroundView
    }
    
    /// Initializes a `YKPieceUI` with a localized title, a custom image asset, and a background.
    init(titleKey: LocalizedStringKey, image: Image, sliceAngle: Double, textColor: Color? = nil, backgroundView: AnyView) {
        self.resolvedText = Text(titleKey)
        self.resolvedImage = image
        self.resolvedCustomImage = nil
        self.sliceAngle = sliceAngle
        self.resolvedTextColor = textColor
        self.backgroundView = backgroundView
    }
    
    /// Initializes a `YKPieceUI` with a standard string title, a system image, and a background.
    init<S>(title: S, systemImage: String, sliceAngle: Double, textColor: Color? = nil, backgroundView: AnyView) where S: StringProtocol {
        self.resolvedText = Text(title)
        self.resolvedImage = Image(systemName: systemImage)
        self.resolvedCustomImage = nil
        self.sliceAngle = sliceAngle
        self.resolvedTextColor = textColor
        self.backgroundView = backgroundView
    }
    
    /// Initializes a `YKPieceUI` with a standard string title, a custom image asset, and a background.
    init<S>(title: S, image: Image, sliceAngle: Double, textColor: Color? = nil, backgroundView: AnyView) where S: StringProtocol {
        self.resolvedText = Text(title)
        self.resolvedImage = image
        self.resolvedCustomImage = nil
        self.sliceAngle = sliceAngle
        self.resolvedTextColor = textColor
        self.backgroundView = backgroundView
    }
    
    /// Initializes a `YKPieceUI` with a localized title, a custom SwiftUI view, and a background.
    init(titleKey: LocalizedStringKey, customImage: AnyView, sliceAngle: Double, textColor: Color? = nil, backgroundView: AnyView) {
        self.resolvedText = Text(titleKey)
        self.resolvedImage = nil
        self.resolvedCustomImage = customImage
        self.sliceAngle = sliceAngle
        self.resolvedTextColor = textColor
        self.backgroundView = backgroundView
    }
    
    /// Initializes a `YKPieceUI` with a standard string title, a custom SwiftUI view, and a background.
    init<S>(title: S, customImage: AnyView, sliceAngle: Double, textColor: Color? = nil, backgroundView: AnyView) where S: StringProtocol {
        self.resolvedText = Text(title)
        self.resolvedImage = nil
        self.resolvedCustomImage = customImage
        self.sliceAngle = sliceAngle
        self.resolvedTextColor = textColor
        self.backgroundView = backgroundView
    }
    
    /// Initializes a `YKPieceUI` with only a custom SwiftUI view and a background.
    init(customImage: AnyView, sliceAngle: Double, backgroundView: AnyView) {
        self.resolvedText = nil
        self.resolvedImage = nil
        self.resolvedCustomImage = customImage
        self.sliceAngle = sliceAngle
        self.resolvedTextColor = nil
        self.backgroundView = backgroundView
    }
    
    /// Initializes a `YKPieceUI` with only a system image and a background.
    init(systemImage: String, sliceAngle: Double, backgroundView: AnyView) {
        self.resolvedText = nil
        self.resolvedImage = Image(systemName: systemImage)
        self.resolvedCustomImage = nil
        self.sliceAngle = sliceAngle
        self.resolvedTextColor = nil
        self.backgroundView = backgroundView
    }
    
    /// Initializes a `YKPieceUI` with only a custom image asset and a background.
    init(image: Image, sliceAngle: Double, backgroundView: AnyView) {
        self.resolvedText = nil
        self.resolvedImage = image
        self.resolvedCustomImage = nil
        self.sliceAngle = sliceAngle
        self.resolvedTextColor = nil
        self.backgroundView = backgroundView
    }
    
    /// Initializes a `YKPieceUI` with only a localized title and a background.
    init(titleKey: LocalizedStringKey, sliceAngle: Double, textColor: Color? = nil, backgroundView: AnyView) {
        self.resolvedText = Text(titleKey)
        self.resolvedImage = nil
        self.resolvedCustomImage = nil
        self.sliceAngle = sliceAngle
        self.resolvedTextColor = textColor
        self.backgroundView = backgroundView
    }
    
    /// Initializes a `YKPieceUI` with only a standard string title and a background.
    init<S>(title: S, sliceAngle: Double, textColor: Color? = nil, backgroundView: AnyView) where S: StringProtocol {
        self.resolvedText = Text(title)
        self.resolvedImage = nil
        self.resolvedCustomImage = nil
        self.sliceAngle = sliceAngle
        self.resolvedTextColor = textColor
        self.backgroundView = backgroundView
    }
}

// MARK: - Preview

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
struct YKPieceUI_Previews: PreviewProvider {
    static var previews: some View {
        ScrollView {
            VStack(spacing: 0) {
                
                Text("YKPieceUI Isolation Test")
                    .font(.title)
                    .fontWeight(.bold)
                    .padding(.top, 20)
                
                VStack {
                    Text("7. Thin Slice (Vertical Text)").font(.caption).foregroundColor(.red)
                    YKPieceUI(
                        title: "SUPERRRR",
                        systemImage: "sparkles",
                        sliceAngle: 25.0,
                        backgroundView: AnyView(Color.teal)
                    )
                    .frame(width: 300, height: 300)
                }
                
                VStack {
                    Text("4. Text + Asset Image").font(.caption).foregroundColor(.gray)
                    YKPieceUI(
                        title: "5000000",
                        image: Image(systemName: "bolt.fill"),
                        sliceAngle: 60.0,
                        backgroundView: AnyView(Color.blue)
                    )
                    .frame(width: 300, height: 300)
                }
                
                VStack {
                    Text("1. Text Only").font(.caption).foregroundColor(.gray)
                    YKPieceUI(
                        title: "BANKRUPTBANKRUPTBANKRUPTBANKRUPTBANKRUPT",
                        sliceAngle: 60.0,
                        backgroundView: AnyView(Color.black)
                    )
                    .frame(width: 300, height: 300)
                }
                
                VStack {
                    Text("2. SF Icon Only").font(.caption).foregroundColor(.gray)
                    YKPieceUI(
                        systemImage: "gift.fill",
                        sliceAngle: 60.0,
                        backgroundView: AnyView(Color.green)
                    )
                    .frame(width: 300, height: 300)
                }
                
                VStack {
                    Text("3. Text + SF Icon").font(.caption).foregroundColor(.gray)
                    YKPieceUI(
                        title: "1000",
                        systemImage: "star.fill",
                        sliceAngle: 60.0,
                        backgroundView: AnyView(Color.orange)
                    )
                    .frame(width: 300, height: 300)
                }
                 
                VStack {
                    Text("5. Custom View Only").font(.caption).foregroundColor(.gray)
                    YKPieceUI(
                        customImage: AnyView(
                            Circle()
                                .fill(Color.yellow)
                                .frame(width: 40, height: 40)
                                .overlay(Text("VIP").font(.caption).bold())
                        ),
                        sliceAngle: 60.0,
                        backgroundView: AnyView(Color.purple)
                    )
                    .frame(width: 300, height: 300)
                }
                
                VStack {
                    Text("6. Text + Custom View").font(.caption).foregroundColor(.gray)
                    YKPieceUI(
                        title: "SPECIAL",
                        customImage: AnyView(
                            ZStack {
                                RoundedRectangle(cornerRadius: 8)
                                    .fill(Color.white)
                                    .frame(width: 45, height: 45)
                                Text("KF")
                                    .font(.headline)
                                    .foregroundColor(.red)
                            }
                        ),
                        sliceAngle: 60.0,
                        backgroundView: AnyView(Color.red)
                    )
                    .frame(width: 300, height: 300)
                }
            }
            .padding(.bottom, 50)
        }
        .background(Color(red: 0.95, green: 0.95, blue: 0.97).ignoresSafeArea())
    }
}
