//
//  YKSpinController.swift
//  YKSpinWheel
//
//  Created by Yakup Kavak on 2.04.2026.
//

import SwiftUI

// MARK: - Constants

/// Internal physics and math constants to avoid magic numbers.
private enum SpinPhysicsConstants {
    /// A full circle in degrees.
    static let fullCircleDegrees: Double = 360.0
    
    /// The ratio used to create a safe margin (padding) inside a slice.
    /// This prevents the pointer from stopping exactly on the line between two pieces.
    static let sliceSafeMarginRatio: Double = 0.15
}

// MARK: - YKSpinController

/// A controller responsible for managing the state and physics calculations of the spin wheel.
///
/// `YKSpinController` handles the logic of calculating a winning slice, determining the exact angle required to land safely within that slice's boundaries, and managing the state of the wheel's animation.
///
/// - Note: Marked with `@MainActor` to guarantee thread-safe state updates for the UI.
@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
@MainActor
public class YKSpinController: ObservableObject {
    
    // MARK: - Published Properties
    
    /// The current rotation of the wheel in degrees.
    @Published public var spinDegrees: Double = 0.0
    
    /// A boolean indicating whether the wheel is currently spinning.
    @Published public var isAnimating: Bool = false
    
    /// The array of models currently displayed on the wheel.
    @Published public var spinModels: [SpinModel]
    
    /// The current active duration of the spin animation.
    @Published public var animationDuration: Double = 4.0

    // MARK: - Private Properties
    
    /// The internal safe copy of the models provided when the controller is created.
    private let models: [SpinModel]
    
    // MARK: - Initialization
    
    /// Initializes a new spin controller.
    ///
    /// - Parameter models: The pieces (`SpinModel`) that will be on the wheel.
    public init(models: [SpinModel]) {
        self.models = models
        self.spinModels = models
    }
    
    // MARK: - Actions
    
    /// Starts the spinning animation asynchronously, calculates the winning slice safely avoiding the gaps,
    /// and returns the winning model after the animation completes.
    ///
    /// - Parameters:
    ///   - spinTime: The duration of the spin animation in seconds. Default is 4.0.
    ///   - spinTurns: The number of full rotations the wheel will make before stopping. Default is 4.
    /// - Returns: The winning `SpinModel`, or `nil` if the wheel is already spinning or models are empty.
    public func startSpin(
            spinTime: Double = 4.0,
            spinTurns: Int = 4
        ) async -> SpinModel? {
            guard !isAnimating, !models.isEmpty else { return nil }
            
            isAnimating = true
            
            let winningIndex = Int.random(in: 0..<models.count)
            let winningModel = models[winningIndex]
            
            let totalWeight = models.reduce(0.0) { $0 + $1.weight }
            var previousWeights = 0.0
            for i in 0..<winningIndex {
                previousWeights += models[i].weight
            }
            
            let winningWeight = winningModel.weight
            let firstWeight = models[0].weight
            
            let centerWeightOffset = previousWeights + (winningWeight / 2.0) - (firstWeight / 2.0)
            let currentCenterAngle = (centerWeightOffset / totalWeight) * 360.0
            
            let sliceAngle = (winningWeight / totalWeight) * 360.0
            let safeMargin = sliceAngle * 0.15
            let baseTarget = 360.0 - currentCenterAngle.truncatingRemainder(dividingBy: 360.0)
            
            let halfSlice = sliceAngle / 2.0
            let safeOffsetBound = halfSlice - safeMargin
            let internalOffset = Double.random(in: -safeOffsetBound...safeOffsetBound)
            
            var targetMod = baseTarget + internalOffset
            if targetMod < 0 { targetMod += 360.0 }
            if targetMod >= 360.0 { targetMod -= 360.0 }
            
            let currentMod = spinDegrees.truncatingRemainder(dividingBy: 360.0)
            var shiftRequired = targetMod - currentMod
            if shiftRequired < 0 { shiftRequired += 360.0 }
            
            let addedRotation = (Double(spinTurns) * 360.0) + shiftRequired
            spinDegrees += addedRotation
            
            if #available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *) {
                try? await Task.sleep(for: .seconds(spinTime))
            } else {
                let sleepNanoseconds = UInt64(spinTime * 1_000_000_000)
                try? await Task.sleep(nanoseconds: sleepNanoseconds)
            }
            
            isAnimating = false
            return winningModel
        }
}
