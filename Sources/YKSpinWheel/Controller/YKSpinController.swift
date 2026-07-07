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
    
    /// Half of a full circle in degrees.
    static let halfCircleDegrees: Double = 180.0
    
    /// The ratio used to create a safe margin (padding) inside a slice.
    /// This prevents the pointer from stopping exactly on the line between two pieces.
    static let sliceSafeMarginRatio: Double = 0.15
    
    /// The multiplier used to convert seconds to nanoseconds.
    static let nanosecondsPerSecond: Double = 1_000_000_000.0
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
        animationDuration = spinTime
        
        let winningIndex = Int.random(in: 0..<models.count)
        let winningModel = models[winningIndex]
        let totalWeight = models.reduce(0.0) { $0 + $1.weight }
        let previousWeights = calculatePreviousWeights(upTo: winningIndex)
        let winningWeight = winningModel.weight
        let firstWeight = models.first?.weight ?? 0.0

        let centerWeightOffset = previousWeights + (winningWeight / 2.0) - (firstWeight / 2.0)
        let currentCenterAngle = (centerWeightOffset / totalWeight) * SpinPhysicsConstants.fullCircleDegrees
        let sliceAngle = (winningWeight / totalWeight) * SpinPhysicsConstants.fullCircleDegrees
        let safeMargin = sliceAngle * SpinPhysicsConstants.sliceSafeMarginRatio
        let baseTargetAngle = SpinPhysicsConstants.fullCircleDegrees - currentCenterAngle.truncatingRemainder(dividingBy: SpinPhysicsConstants.fullCircleDegrees)
        
        let halfSliceAngle = sliceAngle / 2.0
        let safeOffsetBound = halfSliceAngle - safeMargin
        let randomInternalOffset = Double.random(in: -safeOffsetBound...safeOffsetBound)
        let targetAngleMod = normalizeAngle(baseTargetAngle + randomInternalOffset)
        let currentAngleMod = spinDegrees.truncatingRemainder(dividingBy: SpinPhysicsConstants.fullCircleDegrees)
        let requiredShift = calculateRequiredShift(from: currentAngleMod, to: targetAngleMod)
        let addedRotationDegrees = (Double(spinTurns) * SpinPhysicsConstants.fullCircleDegrees) + requiredShift
        
        spinDegrees += addedRotationDegrees
        await performSpinDelay(duration: spinTime)
        isAnimating = false
        return winningModel
    }
    
}

// MARK: - Private Helpers

private extension YKSpinController {
    
    /// Calculates the sum of weights for all slices before the given index.
    func calculatePreviousWeights(upTo index: Int) -> Double {
        var total = 0.0
        for i in 0..<index {
            total += models[i].weight
        }
        return total
    }
    
    /// Normalizes an angle to ensure it falls within the 0 to 360 degrees range.
    func normalizeAngle(_ angle: Double) -> Double {
        var normalizedAngle = angle
        if normalizedAngle < 0 { normalizedAngle += SpinPhysicsConstants.fullCircleDegrees }
        if normalizedAngle >= SpinPhysicsConstants.fullCircleDegrees { normalizedAngle -= SpinPhysicsConstants.fullCircleDegrees }
        return normalizedAngle
    }
    
    /// Calculates the shortest positive degree shift required to reach the target angle.
    func calculateRequiredShift(from currentMod: Double, to targetMod: Double) -> Double {
        var shift = targetMod - currentMod
        if shift < 0 { shift += SpinPhysicsConstants.fullCircleDegrees }
        return shift
    }
    
    /// Delays the task execution for the specified duration to match the UI animation.
    func performSpinDelay(duration: Double) async {
        if #available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *) {
            try? await Task.sleep(for: .seconds(duration))
        } else {
            let sleepNanoseconds = UInt64(duration * SpinPhysicsConstants.nanosecondsPerSecond)
            try? await Task.sleep(nanoseconds: sleepNanoseconds)
        }
    }
}
