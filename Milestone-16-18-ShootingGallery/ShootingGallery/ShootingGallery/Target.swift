//
//  Target.swift
//  ShootingGallery
//
//  Created by Matt X on 12/21/22.
//

import SpriteKit

class Target: SKNode {
    var stick: SKSpriteNode!
    var target: SKSpriteNode!
    
    func configure() {
        let stickTypeIndex = Int.random(in: 0...2)
        let targetTypeIndex = Int.random(in: 0...3)
        
        stick = SKSpriteNode(imageNamed: "stick\(stickTypeIndex)")
        target = SKSpriteNode(imageNamed: "target\(targetTypeIndex)")
        
        stick.position = CGPoint(x: 0, y: 0)
        target.position = CGPoint(x: 0, y: 116)
        
        addChild(stick)
        addChild(target)
    }
}
