//
//  YKPieceUI.swift
//  YKSpinWheel
//
//  Created by Yakup Kavak on 1.04.2026.
//

import SwiftUI

// MARK: - YKPieceUI View

/// A single customizable slice (piece) of the spin wheel.
///
/// The `YKPieceUI` struct provides a flexible slice component that handles the rendering
/// of its background, an optional image, a custom view (like KFImage), and an optional localized text.
/// It leverages SwiftUI's environment system to allow for customization, such as the vertical
/// spacing between the image and text.
@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
public struct YKPieceUI: View {
    
    // MARK: - Properties
    
    /// The angle of the slice in degrees.
    public let sliceAngle: Double
    
    /// The view used as the background of the slice, automatically clipped to the slice shape.
    public let backgroundView: AnyView
    
    /// The internal resolved image to display. Optional.
    fileprivate let resolvedImage: Image?
    
    /// The internal resolved custom view (like KFImage) to display. Optional.
    fileprivate let resolvedCustomImage: AnyView?
    
    /// The internal resolved text to display, supporting localization. Optional.
    fileprivate let resolvedText: Text?
    
    /// The vertical spacing between the image and the text, sourced from the environment.
    @Environment(\.ykPieceVerticalSpacing) private var verticalSpacing

    // MARK: - Body
    
    public var body: some View {
        GeometryReader { geometry in
            let radius = min(geometry.size.width, geometry.size.height) / 2
            
            ZStack {
                backgroundView
                    .clipShape(AnyShapeWrapper(shape: PieSliceShape(sliceAngle: sliceAngle)))
                
                VStack(spacing: verticalSpacing) {
                    
                    if let sliceImage = resolvedImage {
                        sliceImage
                            .resizable()
                            .scaledToFit()
                            .frame(width: radius * 0.35)
                            .shadow(color: .black.opacity(0.2), radius: 5, x: 0, y: 5)
                    }
                    else if let customImage = resolvedCustomImage {
                        customImage
                    }
                    
                    if let textToDisplay = resolvedText {
                        textToDisplay
                            .font(.system(size: radius * 0.12, weight: .heavy, design: .rounded))
                            .foregroundColor(Color(red: 0.4, green: 0.3, blue: 0.5))
                            .lineLimit(2)
                            .frame(maxWidth: radius * 0.5)
                            .multilineTextAlignment(.center)
                    }
                }
                .position(x: geometry.size.width / 2, y: geometry.size.height / 2)
                .offset(y: -radius * 0.6)
            }
        }
    }
}

// MARK: - YKPieceUI Extensions for Specific Initializers

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
public extension YKPieceUI {
    
    // MARK: LocalizedStringKey + Standard Image Initializers
    
    init(
        titleKey: LocalizedStringKey,
        systemImage: String,
        sliceAngle: Double,
        backgroundView: AnyView
    ) {
        self.resolvedText = Text(titleKey)
        self.resolvedImage = Image(systemName: systemImage)
        self.resolvedCustomImage = nil
        self.sliceAngle = sliceAngle
        self.backgroundView = backgroundView
    }
    
    init(
        titleKey: LocalizedStringKey,
        image: Image,
        sliceAngle: Double,
        backgroundView: AnyView
    ) {
        self.resolvedText = Text(titleKey)
        self.resolvedImage = image
        self.resolvedCustomImage = nil
        self.sliceAngle = sliceAngle
        self.backgroundView = backgroundView
    }
    
    // MARK: StringProtocol + Standard Image Initializers
    
    init<S>(
        title: S,
        systemImage: String,
        sliceAngle: Double,
        backgroundView: AnyView
    ) where S: StringProtocol{
        self.resolvedText = Text(title)
        self.resolvedImage = Image(systemName: systemImage)
        self.resolvedCustomImage = nil
        self.sliceAngle = sliceAngle
        self.backgroundView = backgroundView
    }
    
    init<S>(
        title: S,
        image: Image,
        sliceAngle: Double,
        backgroundView: AnyView
    ) where S: StringProtocol {
        self.resolvedText = Text(title)
        self.resolvedImage = image
        self.resolvedCustomImage = nil
        self.sliceAngle = sliceAngle
        self.backgroundView = backgroundView
    }
    
    // MARK: Custom Image (AnyView) Initializers
    
    init(
        titleKey: LocalizedStringKey,
        customImage: AnyView,
        sliceAngle: Double,
        backgroundView: AnyView
    ) {
        self.resolvedText = Text(titleKey)
        self.resolvedImage = nil
        self.resolvedCustomImage = customImage
        self.sliceAngle = sliceAngle
        self.backgroundView = backgroundView
    }
    
    init<S>(
        title: S,
        customImage: AnyView,
        sliceAngle: Double,
        backgroundView: AnyView
    )where S: StringProtocol {
        self.resolvedText = Text(title)
        self.resolvedImage = nil
        self.resolvedCustomImage = customImage
        self.sliceAngle = sliceAngle
        self.backgroundView = backgroundView
    }
    
    init(
        customImage: AnyView,
        sliceAngle: Double,
        backgroundView: AnyView
    ) {
        self.resolvedText = nil
        self.resolvedImage = nil
        self.resolvedCustomImage = customImage
        self.sliceAngle = sliceAngle
        self.backgroundView = backgroundView
    }
    
    // MARK: Standard Image-Only Initializers
    
    init(
        systemImage: String,
        sliceAngle: Double,
        backgroundView: AnyView
    ) {
        self.resolvedText = nil
        self.resolvedImage = Image(systemName: systemImage)
        self.resolvedCustomImage = nil
        self.sliceAngle = sliceAngle
        self.backgroundView = backgroundView
    }
    
    init(
        image: Image,
        sliceAngle: Double,
        backgroundView: AnyView
    ) {
        self.resolvedText = nil
        self.resolvedImage = image
        self.resolvedCustomImage = nil
        self.sliceAngle = sliceAngle
        self.backgroundView = backgroundView
    }
    
    // MARK: Title-Only Initializers
    
    init(
        titleKey: LocalizedStringKey,
        sliceAngle: Double,
        backgroundView: AnyView
    ) {
        self.resolvedText = Text(titleKey)
        self.resolvedImage = nil
        self.resolvedCustomImage = nil
        self.sliceAngle = sliceAngle
        self.backgroundView = backgroundView
    }
    
    init<S>(
        title: S,
        sliceAngle: Double,
        backgroundView: AnyView
    ) where S: StringProtocol {
        self.resolvedText = Text(title)
        self.resolvedImage = nil
        self.resolvedCustomImage = nil
        self.sliceAngle = sliceAngle
        self.backgroundView = backgroundView
    }
}

// MARK: - Helpers

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
fileprivate struct AnyShapeWrapper: Shape {
    let shape: any Shape

    func path(in rect: CGRect) -> Path {
        shape.path(in: rect)
    }
}
// MARK: - View Modifiers

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
public extension View {
    func ykPieceVerticalSpacing(_ spacing: CGFloat) -> some View {
        environment(\.ykPieceVerticalSpacing, spacing)
    }
}

// MARK: - Preview

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
struct YKPieceUI_Previews: PreviewProvider {
    static var previews: some View {
        ScrollView {
            VStack(spacing: 50) {
                
                Text("YKPieceUI Isolation Test")
                    .font(.title)
                    .fontWeight(.bold)
                    .padding(.top, 20)
                
                VStack {
                    Text("1. Text Only").font(.caption).foregroundColor(.gray)
                    YKPieceUI(
                        title: "BANKRUPT",
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
                    Text("4. Text + Asset Image").font(.caption).foregroundColor(.gray)
                    YKPieceUI(
                        title: "500",
                        image: Image(systemName: "bolt.fill"),
                        sliceAngle: 60.0,
                        backgroundView: AnyView(Color.blue)
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
