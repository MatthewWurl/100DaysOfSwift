//
//  GameScene.swift
//  ExplodingMonkeys
//
//  Created by Matt X on 1/18/23.
//

import SpriteKit

enum CollisionTypes: UInt32 {
    case banana = 1
    case building = 2
    case player = 4
}

class GameScene: SKScene {
    var buildings: [BuildingNode] = []
    weak var viewController: GameViewController?
    
    override func didMove(to view: SKView) {
        backgroundColor = UIColor(hue: 0.669, saturation: 0.99, brightness: 0.67, alpha: 1)
        
        createBuildings()
    }
    
    func createBuildings() {
        var currentX: CGFloat = -15
        
        while currentX < 1024 {
            let randomWidth = Int.random(in: 2...4) * 40
            let randomHeight = Int.random(in: 300...600)
            let size = CGSize(width: randomWidth, height: randomHeight)
            
            currentX += size.width + 2
            
            let building = BuildingNode(color: .red, size: size)
            let xPos = currentX - (size.width / 2)
            let yPos = size.height / 2
            building.position = CGPoint(x: xPos, y: yPos)
            building.setup()
            addChild(building)
            
            buildings.append(building)
        }
    }
    
    func launch(angle: Int, velocity: Int) {
        
    }
}
