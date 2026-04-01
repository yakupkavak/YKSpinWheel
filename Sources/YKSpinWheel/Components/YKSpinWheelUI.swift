//
//  YKSpinWheelUI.swift
//  YKSpinWheel
//
//  Created by Yakup Kavak on 1.04.2026.
//

import SwiftUI

struct DailySpinWheelUI: View {
    
    let spinModels: [SpinModel]
    
    var numberOfSlices: Int {
        spinModels.count
    }
    var sliceAngle: Double {
        360.0 / Double(spinModels.count)
    }
    
    let texts = ["100", "5", "1", "5", "5", "3", "5", "2"]
    
    let backgrounds: [Color] = [
        .pink.opacity(0.4), .cyan.opacity(0.3), .yellow.opacity(0.4), .purple.opacity(0.3),
        .cyan.opacity(0.5), .orange.opacity(0.4), .teal.opacity(0.3), .red.opacity(0.3)
    ]
    
    var body: some View {
        ZStack {
            ForEach(Array(spinModels.enumerated()), id: \.element.id) { index, model in
                YKSpinPieceUI(
                    text: model.text ?? "",
                    systemImage: model.image ?? "",
                    sliceAngle: sliceAngle,
                    backgroundView: model.background ?? backgrounds.randomElement() ?? .pink
                )
                .rotationEffect(Angle(degrees: Double(index) * sliceAngle))
            }
            ZStack {
                Circle()
                    .fill(Color.white)
                    .frame(width: 50, height: 50)
                    .shadow(color: .black.opacity(0.15), radius: 5, x: 0, y: 3)
                Image(systemName: "sparkles")
                    .font(.system(size: 28, weight: .bold))
                    .foregroundColor(Color(red: 0.6, green: 0.4, blue: 0.8))
            }
            
            TriangleShape()
                .fill(Color(red: 0.4, green: 0.3, blue: 0.5))
                .frame(width: 30, height: 30)
                .offset(y: -160)
        }
        .frame(width: 300, height: 300)
    }
}
