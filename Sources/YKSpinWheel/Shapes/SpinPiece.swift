//
//  SpinPiece.swift
//  YKSpinWheel
//
//  Created by Yakup Kavak on 1.04.2026.
//

import SwiftUI

struct PieSliceShape: Shape {
    let sliceAngle: Double
    var spacingAngle: Double = 2.0
    var innerRadius: CGFloat = 10
    var cornerRadius: CGFloat = 15
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let center = CGPoint(x: rect.midX, y: rect.midY)
        let outerRadius = min(rect.width, rect.height) / 2
        
        let startAngle = Angle(degrees: -90 - (sliceAngle / 2) + spacingAngle)
        let endAngle = Angle(degrees: -90 + (sliceAngle / 2) - spacingAngle)
        
        let angleDifference = endAngle.radians - startAngle.radians
        let maxSafeCornerRadius: CGFloat = angleDifference > 0 ? outerRadius * CGFloat(sin(angleDifference / 2.0)) / (1 + CGFloat(sin(angleDifference / 2.0))) : 0
        
        let safeCornerRadius = min(cornerRadius, (outerRadius - innerRadius) / 2, maxSafeCornerRadius)
        let radiusDifference = outerRadius - safeCornerRadius
        
        let cornerAngleOffsetRadians = asin(Double(safeCornerRadius / radiusDifference))
        let cornerAngleOffset = Angle(radians: cornerAngleOffsetRadians)
        
        let straightLineLength = radiusDifference * CGFloat(cos(cornerAngleOffsetRadians))
        
        let leftCornerCenterAngle = startAngle + cornerAngleOffset
        let leftCornerCenter = CGPoint(
            x: center.x + radiusDifference * CGFloat(cos(leftCornerCenterAngle.radians)),
            y: center.y + radiusDifference * CGFloat(sin(leftCornerCenterAngle.radians))
        )
        
        let rightCornerCenterAngle = endAngle - cornerAngleOffset
        let rightCornerCenter = CGPoint(
            x: center.x + radiusDifference * CGFloat(cos(rightCornerCenterAngle.radians)),
            y: center.y + radiusDifference * CGFloat(sin(rightCornerCenterAngle.radians))
        )

        let leftInnerPoint = CGPoint(
            x: center.x + innerRadius * CGFloat(cos(startAngle.radians)),
            y: center.y + innerRadius * CGFloat(sin(startAngle.radians))
        )
        path.move(to: leftInnerPoint)
        
        let leftOuterStraightPoint = CGPoint(
            x: center.x + straightLineLength * CGFloat(cos(startAngle.radians)),
            y: center.y + straightLineLength * CGFloat(sin(startAngle.radians))
        )
        path.addLine(to: leftOuterStraightPoint)
        
        path.addArc(
            center: leftCornerCenter,
            radius: safeCornerRadius,
            startAngle: startAngle - Angle(degrees: 90),
            endAngle: leftCornerCenterAngle,
            clockwise: false
        )
        
        path.addArc(
            center: center,
            radius: outerRadius,
            startAngle: leftCornerCenterAngle,
            endAngle: rightCornerCenterAngle,
            clockwise: false
        )
        
        path.addArc(
            center: rightCornerCenter,
            radius: safeCornerRadius,
            startAngle: rightCornerCenterAngle,
            endAngle: endAngle + Angle(degrees: 90),
            clockwise: false
        )
        
        path.addArc(
            center: center,
            radius: innerRadius,
            startAngle: endAngle,
            endAngle: startAngle,
            clockwise: true
        )
        
        path.closeSubpath()
        return path
    }
}

struct TriangleShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.midX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.minY))
        path.closeSubpath()
        return path
    }
}
