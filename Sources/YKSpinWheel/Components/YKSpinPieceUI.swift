//
//  YKSpinPieceUI.swift
//  YKSpinWheel
//
//  Created by Yakup Kavak on 1.04.2026.
//

import SwiftUI

/// A single slice (piece) of the spin wheel.
///
/// This view handles the rendering of an individual slice, including its background,
/// text, and an optional image (either a system symbol or a custom image).
@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
public struct YKSpinPieceUI<BackgroundView: View>: View {
    
    // MARK: - Properties
    
    public let text: String
    public let sliceAngle: Double
    public let backgroundView: BackgroundView
    
    /// The internal resolved image to display.
    fileprivate let resolvedImage: Image?
    
    // MARK: - Body
    
    public var body: some View {
        GeometryReader { geometry in
            let radius = min(geometry.size.width, geometry.size.height) / 2
            
            ZStack {
                backgroundView
                    .clipShape(PieSliceShape(sliceAngle: sliceAngle))
                VStack(spacing: 8) {
                    if let sliceImage = resolvedImage {
                        sliceImage
                            .resizable()
                            .scaledToFit()
                            .frame(width: radius * 0.35)
                            .shadow(color: .black.opacity(0.2), radius: 5, x: 0, y: 5)
                    }                    
                    Text(text)
                        .font(.system(size: radius * 0.12, weight: .heavy, design: .rounded))
                        .foregroundColor(Color(red: 0.4, green: 0.3, blue: 0.5))
                }
                .position(x: geometry.size.width / 2, y: geometry.size.height / 2)
                .offset(y: -radius * 0.6)
            }
        }
    }
}

// MARK: - Extensions for Initializers

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
public extension YKSpinPieceUI {
    
    /// Initializes a spin piece with a system image (SF Symbols).
    ///
    /// - Parameters:
    ///   - text: The text to display on the slice.
    ///   - systemImage: The name of the SF Symbol.
    ///   - sliceAngle: The angle of the slice in degrees.
    ///   - backgroundView: The view to use as the slice's background.
    init(
        text: String,
        systemImage: String,
        sliceAngle: Double,
        backgroundView: BackgroundView
    ) {
        self.text = text
        self.resolvedImage = Image(systemName: systemImage)
        self.sliceAngle = sliceAngle
        self.backgroundView = backgroundView
    }
    
    /// Initializes a spin piece with a custom SwiftUI `Image`.
    ///
    /// - Parameters:
    ///   - text: The text to display on the slice.
    ///   - image: A custom SwiftUI `Image`.
    ///   - sliceAngle: The angle of the slice in degrees.
    ///   - backgroundView: The view to use as the slice's background.
    init(
        text: String,
        image: Image,
        sliceAngle: Double,
        backgroundView: BackgroundView
    ) {
        self.text = text
        self.resolvedImage = image
        self.sliceAngle = sliceAngle
        self.backgroundView = backgroundView
    }
    
    /// Initializes a spin piece with text only (No image).
    ///
    /// - Parameters:
    ///   - text: The text to display on the slice.
    ///   - sliceAngle: The angle of the slice in degrees.
    ///   - backgroundView: The view to use as the slice's background.
    init(
        text: String,
        sliceAngle: Double,
        backgroundView: BackgroundView
    ) {
        self.text = text
        self.resolvedImage = nil
        self.sliceAngle = sliceAngle
        self.backgroundView = backgroundView
    }
}
