// The Swift Programming Language
// https://docs.swift.org/swift-book
/*
import SwiftUI

struct DailySpinUI: View {
    
    // MARK: - PROPERTIES
    
    let list: [SpinModel]
    //let centerView: CenterView
    
    // MARK: - ENVIRONMENT VARIABLES
    
    /// The background color of the card, sourced from the environment.
    @Environment(\.ykBaseSpinRotationDegrees) private var baseRotationRegrees
    
    /// The background color of the card, sourced from the environment.
    @Environment(\.ykSpinTime) private var spinTime
    
    /// The background color of the card, sourced from the environment.
    @Environment(\.ykSpinRepeatCount) private var spinRepeatCount
    
    /// The background color of the card, sourced from the environment.
    @Environment(\.ykSpinRandomMinValue) private var minRandomSpinValue
    
    /// The background color of the card, sourced from the environment.
    @Environment(\.ykSpinRandomMaxValue) private var maxRandomSpinValue
    
    // MARK: - PRIVATE VARIABLES
    
    
    @State private var isAnimating = false
    @State private var spinDegrees = 0.0
    @State private var rand = 0.0
    @State private var newAngle = 0.0
    
    var spinAnimation: Animation {
       Animation.easeOut(duration: spinTime)
         .repeatCount(spinRepeatCount, autoreverses: false)
   }
    
    // MARK: - UI
    
    var body: some View {
        VStack {
            Image(".dailySpinIcon")
                        .resizable()
                        .scaledToFit()
                        .rotationEffect(Angle(degrees: spinDegrees))
                        .frame(width: 245, height: 245, alignment: .center)
                        .animation(spinAnimation)
            Button("ClickForSpin") {
                isAnimating = true
                rand = Double.random(in: minRandomSpinValue...maxRandomSpinValue)
                spinDegrees += baseRotationRegrees + rand
                //newAngle = getAngle(angle: spinDegrees)
                DispatchQueue.main.asyncAfter(deadline: .now() + spinTime - 0.1) {
                    isAnimating = false
                }
            }
        }
    }
}

// MARK: - PREVIEW

#Preview("Full Wheel UI") {
    let sampleSpinModels: [SpinModel] = [
        SpinModel(id: 1, image: "star.fill", text: "100", background: .pink.opacity(0.4)),
        SpinModel(id: 2, image: "bolt.fill", text: "5", background: .cyan.opacity(0.3)),
        SpinModel(id: 3, image: "gift.fill", text: "1", background: .yellow.opacity(0.4)),
        SpinModel(id: 4, image: "heart.fill", text: "5", background: .purple.opacity(0.3)),
        SpinModel(id: 5, image: "crown.fill", text: "50", background: .cyan.opacity(0.5)),
        SpinModel(id: 6, image: "diamond.fill", text: "3", background: .orange.opacity(0.4)),
        SpinModel(id: 7, image: "trophy.fill", text: "5", background: .teal.opacity(0.3)),
        SpinModel(id: 8, image: "burn", text: "2", background: .red.opacity(0.3))
    ]
    ZStack {
        Color(red: 0.95, green: 0.97, blue: 1.0).ignoresSafeArea()
        
        VStack(spacing: 40) {
            Text("Congratulations!")
                .font(.system(size: 32, weight: .heavy, design: .rounded))
                .foregroundColor(.gray.opacity(0.8))
            
            DailySpinWheelUI(spinModels: sampleSpinModels)
        }
    }
}

#Preview("Full Spin UI") {
    let list: [SpinModel] = [.init(id: 1)]
    DailySpinUI(list: list)
}

#Preview("Single Piece") {
    ZStack {
        Color.gray.opacity(0.1).ignoresSafeArea()
        YKPieceUI(
            text: "100",
            systemImage: "heart.fill",
            sliceAngle: 45,
            backgroundView: LinearGradient(
                colors: [Color.pink.opacity(0.4), Color.cyan.opacity(0.3)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
    }
}

*/
