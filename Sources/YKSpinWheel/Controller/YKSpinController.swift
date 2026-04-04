//
//  YKSpinController.swift
//  YKSpinWheel
//
//  Created by Yakup Kavak on 2.04.2026.
//

import SwiftUI

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
@MainActor
public class YKSpinController: ObservableObject {
    
    // MARK: - Published Properties
    
    /// The current rotation of the wheel in degrees.
    @Published public var spinDegrees: Double = 0.0
    
    /// A boolean indicating whether the wheel is currently spinning.
    @Published public var isAnimating: Bool = false

    // MARK: - Physics Configurations
    
    /// The base number of degrees the wheel will rotate for the visual show before landing.
    /// Default is 3600.0 (10 full rotations).
    public var baseRotationDegrees: Double = 720.0
    
    /// The duration of a single spin animation in seconds.
    public var spinTime: Double = 4.0
    
    /// The number of times the animation curve repeats.
    public var spinRepeatCount: Int = 1
    
    // MARK: - Initialization
    
    public init() {}
    
    // MARK: - Actions
    
    /// Starts the spinning animation asynchronously, calculates the winning slice safely avoiding the gaps,
    /// and returns the winning model after the animation completes.
    ///
    /// - Parameter models: The array of `SpinModel` items currently displayed on the wheel.
    /// - Returns: The winning `SpinModel`, or `nil` if the wheel is already spinning or models are empty.
    public func startSpin(models: [SpinModel]) async -> SpinModel? {
        guard !isAnimating, !models.isEmpty else { return nil }
        
        isAnimating = true
        
        let winningIndex = Int.random(in: 0..<models.count)
        let winningModel = models[winningIndex]
        let sliceAngle = 360.0 / Double(models.count)
        let safeMargin = sliceAngle * 0.15
        let baseTarget = 360.0 - (Double(winningIndex) * sliceAngle)
        let internalOffset = Double.random(in: safeMargin...(sliceAngle - safeMargin))
        var targetMod = baseTarget - internalOffset
        if targetMod < 0 { targetMod += 360.0 }
        let currentMod = spinDegrees.truncatingRemainder(dividingBy: 360.0)
        var shiftRequired = targetMod - currentMod
        if shiftRequired < 0 { shiftRequired += 360.0 }
        let totalSpinTime = spinTime * Double(spinRepeatCount)
        let totalBaseRotation = baseRotationDegrees * Double(spinRepeatCount)
        let addedRotation = totalBaseRotation + shiftRequired
        spinDegrees += addedRotation
        try? await Task.sleep(nanoseconds: UInt64(totalSpinTime * 1_000_000_000))
        isAnimating = false
        return winningModel
    }
}
