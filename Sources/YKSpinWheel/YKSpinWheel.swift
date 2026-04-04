//
//  DailySpinUI.swift
//  YKSpinWheel
//
//  Created by Yakup Kavak on 1.04.2026.
//

import SwiftUI

// MARK: - DailySpinUI View

/// A functional, interactive view that wraps the `YKSpinWheelUI` and provides
/// the spinning animation, physics, and interaction logic.
@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
public struct DailySpinUI: View {
    
    // MARK: - Properties
    
    @ObservedObject var controller = YKSpinController()
    
    /// The list of models that represent the slices on the wheel.
    public let list: [SpinModel]
    
    // MARK: - Initialization
    
    public init(list: [SpinModel]) {
        self.list = list
    }
    
    // MARK: - Body
    
    public var body: some View {
        VStack(spacing: 50) {
            YKSpinWheelUI(spinModels: list, controller: controller)
        }
    }
    
}

// MARK: - Previews

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
struct DailySpinUI_Previews: PreviewProvider {
    static var previews: some View {
        
        let sampleModels: [SpinModel] = [
            SpinModel(id: 1, text: "100", sfImageName: "star.fill", background: Color.pink.opacity(0.4)),
            SpinModel(id: 2, text: "5", sfImageName: "bolt.fill", background: Color.cyan.opacity(0.3)),
            SpinModel(id: 3, text: "1", sfImageName: "gift.fill", background: Color.yellow.opacity(0.4)),
            SpinModel(id: 4, text: "5", sfImageName: "heart.fill", background: Color.purple.opacity(0.3)),
            SpinModel(id: 5, text: "50", sfImageName: "crown.fill", background: Color.cyan.opacity(0.5)),
            SpinModel(id: 6, text: "3", sfImageName: "diamond.fill", background: Color.orange.opacity(0.4)),
            SpinModel(id: 7, text: "5", sfImageName: "trophy.fill", background: Color.teal.opacity(0.3)),
            SpinModel(id: 8, text: "2", sfImageName: "flame.fill", background: Color.red.opacity(0.3))
        ]
        
        Group {
            ZStack {
                Color(red: 0.95, green: 0.97, blue: 1.0).ignoresSafeArea()
                
                VStack(spacing: 60) {
                    Text("Daily Spin")
                        .font(.system(size: 32, weight: .heavy, design: .rounded))
                        .foregroundColor(.gray.opacity(0.8))
                    
                    DailySpinUI(list: sampleModels)
                }
            }
            .previewDisplayName("Full Interactive Wheel")
            
            ZStack {
                Color.gray.opacity(0.1).ignoresSafeArea()
                YKPieceUI(
                    title: "100",
                    systemImage: "heart.fill",
                    sliceAngle: 45,
                    backgroundView: AnyView(
                        LinearGradient(
                            colors: [Color.pink.opacity(0.4), Color.cyan.opacity(0.3)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                )
                .frame(width: 300, height: 300)
            }
            .previewDisplayName("Single Piece Isolation")
        }
    }
}
