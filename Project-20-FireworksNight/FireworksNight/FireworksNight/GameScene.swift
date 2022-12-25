//
//  GameScene.swift
//  FireworksNight
//
//  Created by Matt X on 12/24/22.
//

import SpriteKit

class GameScene: SKScene {
    var fireworks: [SKNode] = []
    var gameTimer: Timer?
    
    let leftEdge = -22
    let bottomEdge = -22
    let rightEdge = 1024 + 22
    
    var score = 0 {
        didSet {
            
        }
    }
    
    override func didMove(to view: SKView) {
        let background = SKSpriteNode(imageNamed: "background")
        background.position = CGPoint(x: 512, y: 384)
        background.blendMode = .replace
        background.zPosition = -1
        addChild(background)
        
        gameTimer = Timer.scheduledTimer(
            timeInterval: 6,
            target: self,
            selector: #selector(launchFireworks),
            userInfo: nil,
            repeats: true
        )
    }
    
    func createFirework(at position: CGPoint, withDeltaX xMovement: CGFloat) {
        let node = SKNode()
        node.position = position
        
        let firework = SKSpriteNode(imageNamed: "rocket")
        firework.colorBlendFactor = 1
        firework.name = "Firework"
        node.addChild(firework)
        
        switch Int.random(in: 0...2) {
        case 0:
            firework.color = .cyan
        case 1:
            firework.color = .green
        default:
            firework.color = .red
        }
        
        let path = UIBezierPath()
        path.move(to: .zero)
        path.addLine(to: CGPoint(x: xMovement, y: 1000))
        
        let move = SKAction.follow(
            path.cgPath,
            asOffset: true,
            orientToPath: true,
            speed: 200
        )
        node.run(move)
        
        let emitter = SKEmitterNode(fileNamed: "fuse")!
        emitter.position = CGPoint(x: 0, y: -22)
        node.addChild(emitter)
        
        fireworks.append(node)
        addChild(node)
    }
    
    @objc func launchFireworks() {
        let movementAmount: CGFloat = 1800
        
        switch Int.random(in: 0...3) {
        case 0:
            // Fire five, straight up
            createFirework(at: CGPoint(x: 512, y: bottomEdge), withDeltaX: 0)
            createFirework(at: CGPoint(x: 512 - 200, y: bottomEdge), withDeltaX: 0)
            createFirework(at: CGPoint(x: 512 - 100, y: bottomEdge), withDeltaX: 0)
            createFirework(at: CGPoint(x: 512 + 100, y: bottomEdge), withDeltaX: 0)
            createFirework(at: CGPoint(x: 512 + 200, y: bottomEdge), withDeltaX: 0)
        case 1:
            // Fire five, in a fan
            createFirework(at: CGPoint(x: 512, y: bottomEdge), withDeltaX: 0)
            createFirework(at: CGPoint(x: 512 - 200, y: bottomEdge), withDeltaX: -200)
            createFirework(at: CGPoint(x: 512 - 100, y: bottomEdge), withDeltaX: -100)
            createFirework(at: CGPoint(x: 512 + 100, y: bottomEdge), withDeltaX: 100)
            createFirework(at: CGPoint(x: 512 + 200, y: bottomEdge), withDeltaX: 200)
        case 2:
            // Fire five, from the left to the right
            createFirework(at: CGPoint(x: leftEdge, y: bottomEdge + 400), withDeltaX: movementAmount)
            createFirework(at: CGPoint(x: leftEdge, y: bottomEdge + 300), withDeltaX: movementAmount)
            createFirework(at: CGPoint(x: leftEdge, y: bottomEdge + 200), withDeltaX: movementAmount)
            createFirework(at: CGPoint(x: leftEdge, y: bottomEdge + 100), withDeltaX: movementAmount)
            createFirework(at: CGPoint(x: leftEdge, y: bottomEdge), withDeltaX: movementAmount)
        case 3:
            // Fire five, from the right to the left
            createFirework(at: CGPoint(x: rightEdge, y: bottomEdge + 400), withDeltaX: -movementAmount)
            createFirework(at: CGPoint(x: rightEdge, y: bottomEdge + 300), withDeltaX: -movementAmount)
            createFirework(at: CGPoint(x: rightEdge, y: bottomEdge + 200), withDeltaX: -movementAmount)
            createFirework(at: CGPoint(x: rightEdge, y: bottomEdge + 100), withDeltaX: -movementAmount)
            createFirework(at: CGPoint(x: rightEdge, y: bottomEdge), withDeltaX: -movementAmount)
        default:
            break
        }
    }
    
    func checkTouches(_ touches: Set<UITouch>) {
        guard let touch = touches.first else { return }
        
        let location = touch.location(in: self)
        let nodesAtPoint = nodes(at: location)
        
        for case let node as SKSpriteNode in nodesAtPoint {
            guard node.name == "Firework" else { continue }
            
            for parent in fireworks {
                guard let firework = parent.children.first as? SKSpriteNode else { continue }
                
                if firework.name == "Selected" && firework.color != node.color {
                    firework.name = "Firework"
                    firework.colorBlendFactor = 1
                }
            }
            
            node.name = "Selected"
            node.colorBlendFactor = 0
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        
        checkTouches(touches)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesMoved(touches, with: event)
        
        checkTouches(touches)
    }
    
    override func update(_ currentTime: TimeInterval) {
        for (index, firework) in fireworks.enumerated().reversed() {
            if firework.position.y > 900 {
                fireworks.remove(at: index)
                firework.removeFromParent()
            }
        }
    }
}
