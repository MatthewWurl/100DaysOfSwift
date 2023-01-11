//
//  GameScene.swift
//  MarbleMaze
//
//  Created by Matt X on 1/9/23.
//

import CoreMotion
import SpriteKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    enum CollisionTypes: UInt32 {
        case player = 1
        case wall = 2
        case star = 4
        case vortex = 8
        case finish = 16
    }
    
    var isGameOver = false
    var lastTouchPosition: CGPoint?
    var motionManager: CMMotionManager?
    var player: SKSpriteNode!
    var score = 0 {
        didSet {
            scoreLabel.text = "Score: \(score)"
        }
    }
    var scoreLabel: SKLabelNode!
    
    override func didMove(to view: SKView) {
        let background = SKSpriteNode(imageNamed: "background")
        background.position = CGPoint(x: 512, y: 384)
        background.blendMode = .replace
        background.zPosition = -1
        addChild(background)
        
        scoreLabel = SKLabelNode(fontNamed: "Chalkduster")
        scoreLabel.text = "Score: 0"
        scoreLabel.horizontalAlignmentMode = .left
        scoreLabel.position = CGPoint(x: 16, y: 16)
        scoreLabel.zPosition = 2
        addChild(scoreLabel)
        
        loadLevel()
        createPlayer()
        
        physicsWorld.contactDelegate = self
        
        motionManager = CMMotionManager()
        motionManager?.startAccelerometerUpdates()
    }
    
    func loadLevel() {
        guard let levelURL = Bundle.main.url(forResource: "level1", withExtension: "txt") else {
            fatalError("Could not find level1.text in the app bundle.")
        }
        guard let levelString = try? String(contentsOf: levelURL) else {
            fatalError("Could not load level1.txt from the app bundle.")
        }
        
        let lines = levelString.split(separator: "\n")
        
        for (row, line) in lines.reversed().enumerated() {
            for (column, letter) in line.enumerated() {
                let xPos = (64 * column) + 32
                let yPos = (64 * row) + 32
                let position = CGPoint(x: xPos, y: yPos)
                
                if letter == "x" {
                    // Load wall...
                    let node = SKSpriteNode(imageNamed: "block")
                    node.position = position
                    
                    node.physicsBody = SKPhysicsBody(rectangleOf: node.size)
                    node.physicsBody?.categoryBitMask = CollisionTypes.wall.rawValue
                    node.physicsBody?.isDynamic = false
                    
                    addChild(node)
                } else if letter == "v" {
                    // Load vortex...
                    let node = SKSpriteNode(imageNamed: "vortex")
                    node.name = "vortex"
                    node.position = position
                    node.run(SKAction.repeatForever(SKAction.rotate(byAngle: .pi, duration: 1)))
                    
                    node.physicsBody = SKPhysicsBody(circleOfRadius: node.size.width / 2)
                    node.physicsBody?.categoryBitMask = CollisionTypes.vortex.rawValue
                    node.physicsBody?.isDynamic = false
                    node.physicsBody?.collisionBitMask = 0
                    
                    addChild(node)
                } else if letter == "s" {
                    // Load star...
                    let node = SKSpriteNode(imageNamed: "star")
                    node.name = "star"
                    node.position = position
                    
                    node.physicsBody = SKPhysicsBody(circleOfRadius: node.size.width / 2)
                    node.physicsBody?.categoryBitMask = CollisionTypes.star.rawValue
                    node.physicsBody?.isDynamic = false
                    node.physicsBody?.collisionBitMask = 0
                    node.physicsBody?.contactTestBitMask = CollisionTypes.player.rawValue
                    
                    addChild(node)
                } else if letter == "f" {
                    // Load finish point...
                    let node = SKSpriteNode(imageNamed: "finish")
                    node.name = "finish"
                    node.position = position
                    
                    node.physicsBody = SKPhysicsBody(circleOfRadius: node.size.width / 2)
                    node.physicsBody?.categoryBitMask = CollisionTypes.finish.rawValue
                    node.physicsBody?.isDynamic = false
                    node.physicsBody?.collisionBitMask = 0
                    node.physicsBody?.contactTestBitMask = CollisionTypes.player.rawValue
                    
                    addChild(node)
                } else if letter == " " {
                    // This is an empty space... Do nothing...
                } else {
                    fatalError("Unknown level letter found: \(letter)")
                }
            }
        }
    }
    
    func createPlayer() {
        player = SKSpriteNode(imageNamed: "player")
        player.position = CGPoint(x: 96, y: 672) // Exact position for level 1...
        player.zPosition = 1
        
        player.physicsBody = SKPhysicsBody(circleOfRadius: player.size.width / 2)
        player.physicsBody?.allowsRotation = false
        player.physicsBody?.linearDamping = 0.5
        player.physicsBody?.categoryBitMask = CollisionTypes.player.rawValue
        player.physicsBody?.contactTestBitMask = CollisionTypes.star.rawValue | CollisionTypes.vortex.rawValue | CollisionTypes.finish.rawValue
        player.physicsBody?.collisionBitMask = CollisionTypes.wall.rawValue
        
        addChild(player)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        lastTouchPosition = location
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        lastTouchPosition = location
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        lastTouchPosition = nil
    }
    
    override func update(_ currentTime: TimeInterval) {
        guard !isGameOver else { return }
        
        #if targetEnvironment(simulator) // Use touch for simulator...
        if let lastTouchPosition = lastTouchPosition {
            let xPosDiff = lastTouchPosition.x - player.position.x
            let yPosDiff = lastTouchPosition.y - player.position.y
            let diff = CGPoint(x: xPosDiff, y: yPosDiff)
            
            physicsWorld.gravity = CGVector(dx: diff.x / 100, dy: diff.y / 100)
        }
        #else // Use tilt information for real device...
        if let accelerometerData = motionManager?.accelerometerData {
            // dx and dy are flipped because the device is rotated by default...
            let dx = accelerometerData.acceleration.y
            let dy = accelerometerData.acceleration.x
            physicsWorld.gravity = CGVector(dx: dx * -50, dy: dy * 50)
        }
        #endif
    }

    func didBegin(_ contact: SKPhysicsContact) {
        guard let nodeA = contact.bodyA.node else { return }
        guard let nodeB = contact.bodyB.node else { return }
        
        if nodeA == player {
            playerCollided(with: nodeB)
        } else if nodeB == player {
            playerCollided(with: nodeA)
        }
    }
    
    func playerCollided(with node: SKNode) {
        if node.name == "vortex" {
            player.physicsBody?.isDynamic = false
            isGameOver = true
            score -= 1
            
            let move = SKAction.move(to: node.position, duration: 0.25)
            let scale = SKAction.scale(to: 0.0001, duration: 0.25)
            let remove = SKAction.removeFromParent()
            let sequence = SKAction.sequence([move, scale, remove])
            
            player.run(sequence) { [weak self] in
                self?.createPlayer()
                self?.isGameOver = false
                self?.physicsWorld.gravity = .zero // Reset gravity...
            }
        } else if node.name == "star" {
            node.removeFromParent()
            score += 1
        } else if node.name == "finish" {
            // Go to next level...
        }
    }
}
