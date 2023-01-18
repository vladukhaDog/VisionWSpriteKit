//
//  Particles.swift
//  HandPlaying
//
//  Created by Permyakov Vladislav on 18.01.2023.
//

import Foundation
import SwiftUI

struct WaterParticle: Particle{
    var percentToAddPerParticle: Double = 0.1
    
    var percentToRemovePerSecond: Double = 8
    
    var maxPercentToUse: Double = 30
    var id: String = "1"
    var size: CGSize = .init(width: 20, height: 20)
    var barColor: Color = .blue
    
    var delayBeforePhysics: Double = 0
    
    var sprite: String = "waterDrop"
    var restitution: CGFloat = 0.6
    var hasPhysics: Bool = true
    var secondsToDissapear: Double = 3
    var spreadMultiplier: Int = 3
    var maxAmount: Int = 4
    var shouldMoveWithFingerVector: Bool = true
}
struct FertilizeParticle: Particle{
    var percentToAddPerParticle: Double = 0.5
    var maxPercentToUse: Double = 10
    var percentToRemovePerSecond: Double = 5
    
    var id: String = "2"
    var size: CGSize = .init(width: 20, height: 20)
    var delayBeforePhysics: Double = 3.2
    var barColor: Color = Color(UIColor.brown)
    var sprite: String = "fert"
    var restitution: CGFloat = 0
    var hasPhysics: Bool = false
    var secondsToDissapear: Double = 2.35
    var spreadMultiplier: Int = 4
    var collidesWithOtherParticles: Bool = false
}

struct LeafParticle: Particle{
    var id: String = "3"
    
    var sprite: String = "leaf"
    
    var hasPhysics: Bool = true
    
    var secondsToDissapear: Double = 7
    
    var delayBeforePhysics: Double = 0
    
    var size: CGSize = .init(width: 30, height: 30)
    
    var barColor: Color = .clear
    var restitution: CGFloat = 0
    var percentToAddPerParticle: Double = 0.0
    var maxAmount: Int = 1
    var percentToRemovePerSecond: Double = 0.0
    var collidesWithOtherParticles: Bool = false
    var physicsSizeMultiplier: Double = 0.7
    
}

struct SnowParticle: Particle{
    var id: String = "4"
    
    var sprite: String = "snowflake"
    
    var hasPhysics: Bool = true
    
    var secondsToDissapear: Double = 7
    
    var delayBeforePhysics: Double = 0
    
    var size: CGSize = .init(width: 30, height: 30)
    
    var barColor: Color = .clear
    
    var percentToAddPerParticle: Double = 0.0
    
    var percentToRemovePerSecond: Double = 0.0
    var collidesWithOtherParticles: Bool = false
    
}
