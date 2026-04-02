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
/// `YKSpinWheelUI` constructs a complete circular wheel by iterating through an array of `SpinModel`s.
/// It delegates the complex conditional rendering of each slice to a separate ViewBuilder method
/// to ensure fast and reliable compiler type-checking.
@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
public struct YKSpinWheelUI: View {
    
    // MARK: - Properties
    
    /// The array of models representing the slices of the wheel.
    public let spinModels: [SpinModel]
    
    /// The dynamically calculated angle for each slice.
    private var sliceAngle: Double {
        spinModels.isEmpty ? 360.0 : 360.0 / Double(spinModels.count)
    }
    
    // MARK: - Initialization
    
    public init(spinModels: [SpinModel]) {
        self.spinModels = spinModels
    }
    
    // MARK: - Body
    
    public var body: some View {
        ZStack {
            
            // MARK: Wheel Slices
            ForEach(Array(spinModels.enumerated()), id: \.element.id) { index, model in
                buildPiece(for: model)
                    .rotationEffect(Angle(degrees: Double(index) * sliceAngle))
            }
            
            // MARK: Center Hub Component
            ZStack {
                Circle()
                    .fill(Color.white)
                    .frame(width: 50, height: 50)
                    .shadow(color: .black.opacity(0.15), radius: 5, x: 0, y: 3)
                
                Image(systemName: "sparkles")
                    .font(.system(size: 28, weight: .bold))
                    .foregroundColor(Color(red: 0.6, green: 0.4, blue: 0.8))
            }
            .accessibilityElement(children: .ignore)
            
            // MARK: Top Indicator Triangle
            TriangleShape()
                .fill(Color(red: 0.4, green: 0.3, blue: 0.5))
                .frame(width: 30, height: 30)
                .offset(y: -160)
        }
        .frame(width: 300, height: 300)
    }
    
    // MARK: - View Builders
    
    /// Constructs the individual slice (piece) based on the provided model data.
    ///
    /// Extracted into a separate `@ViewBuilder` to prevent SwiftUI compiler timeouts
    @ViewBuilder
    private func buildPiece(for model: SpinModel) -> some View {
        
        if let sfImage = model.sfImageName {
            
            if let textKey = model.textKey {
                YKPieceUI(titleKey: textKey, systemImage: sfImage, sliceAngle: sliceAngle, backgroundView: model.background)
            } else if let textString = model.textString {
                YKPieceUI(title: textString, systemImage: sfImage, sliceAngle: sliceAngle, backgroundView: model.background)
            } else {
                YKPieceUI(systemImage: sfImage, sliceAngle: sliceAngle, backgroundView: model.background)
            }
            
        }
        else if let customIcon = model.customImage {
            
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

// MARK: - Preview

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
struct YKSpinWheelUI_Previews: PreviewProvider {
    static var previews: some View {
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
                customImage: ZStack {
                    Circle()
                        .fill(Color.white)
                        .shadow(radius: 2)
                    Text("KF")
                        .font(.caption2)
                        .bold()
                        .foregroundColor(.purple)
                }.frame(width: 40, height: 40),
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
                
                YKSpinWheelUI(spinModels: sampleModels)
                    .shadow(color: .black.opacity(0.1), radius: 15, x: 0, y: 10)
            }
        }
    }
}
