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
        case teleporter = 16
        case finish = 32
    }
    
    var isGameOver = false
    var lastTouchPosition: CGPoint?
    var level = 1 {
        didSet {
            levelLabel.text = "Level: \(level)"
        }
    }
    var levelLabel: SKLabelNode!
    let maxLevel = 2
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
        
        levelLabel = SKLabelNode(fontNamed: "Chalkduster")
        levelLabel.horizontalAlignmentMode = .left
        levelLabel.position = CGPoint(x: 16, y: 768 - 36)
        levelLabel.zPosition = 2
        addChild(levelLabel)
        
        scoreLabel = SKLabelNode(fontNamed: "Chalkduster")
        scoreLabel.horizontalAlignmentMode = .left
        scoreLabel.position = CGPoint(x: 16, y: 16)
        scoreLabel.zPosition = 2
        addChild(scoreLabel)
        
        level = 1
        score = 0
        
        loadLevel()
        createPlayer()
        
        physicsWorld.contactDelegate = self
        
        motionManager = CMMotionManager()
        motionManager?.startAccelerometerUpdates()
    }
    
    func loadLevel() {
        let levelName = "level\(level)"
        
        guard let levelURL = Bundle.main.url(forResource: levelName, withExtension: "txt") else {
            fatalError("Could not find \(levelName).txt in the app bundle.")
        }
        guard let levelString = try? String(contentsOf: levelURL) else {
            fatalError("Could not load \(levelName).txt from the app bundle.")
        }
        
        let lines = levelString.split(separator: "\n")
        
        for (row, line) in lines.reversed().enumerated() {
            for (column, letter) in line.enumerated() {
                let xPos = (64 * column) + 32
                let yPos = (64 * row) + 32
                let position = CGPoint(x: xPos, y: yPos)
                
                switch letter {
                case "x":
                    addWall(at: position)
                case "s":
                    addStar(at: position)
                case "v":
                    addVortex(at: position)
                case "t":
                    addTeleporter(at: position)
                case "f":
                    addFinish(at: position)
                case " ": // An empty space, do nothing...
                    break
                default:
                    fatalError("Unknown level letter found: \(letter)")
                }
            }
        }
        
        physicsWorld.gravity = .zero // Set gravity to zero when level loads...
    }
    
    func addWall(at position: CGPoint) {
        let wall = SKSpriteNode(imageNamed: "block")
        wall.name = "wall"
        wall.position = position
        
        wall.physicsBody = SKPhysicsBody(rectangleOf: wall.size)
        wall.physicsBody?.categoryBitMask = CollisionTypes.wall.rawValue
        wall.physicsBody?.isDynamic = false
        
        addChild(wall)
    }
    
    func addStar(at position: CGPoint) {
        let star = SKSpriteNode(imageNamed: "star")
        star.name = "star"
        star.position = position
        
        star.physicsBody = SKPhysicsBody(circleOfRadius: star.size.width / 2)
        star.physicsBody?.categoryBitMask = CollisionTypes.star.rawValue
        star.physicsBody?.isDynamic = false
        star.physicsBody?.collisionBitMask = 0
        star.physicsBody?.contactTestBitMask = CollisionTypes.player.rawValue
        
        addChild(star)
    }
    
    func addVortex(at position: CGPoint) {
        let vortex = SKSpriteNode(imageNamed: "vortex")
        vortex.name = "vortex"
        vortex.position = position
        
        let rotation = SKAction.repeatForever(SKAction.rotate(byAngle: .pi, duration: 1))
        vortex.run(rotation)
        
        vortex.physicsBody = SKPhysicsBody(circleOfRadius: vortex.size.width / 2)
        vortex.physicsBody?.categoryBitMask = CollisionTypes.vortex.rawValue
        vortex.physicsBody?.isDynamic = false
        vortex.physicsBody?.collisionBitMask = 0
        
        addChild(vortex)
    }
    
    func addTeleporter(at position: CGPoint) {
        let teleporter = SKSpriteNode(imageNamed: "teleporter")
        teleporter.name = "teleporter"
        teleporter.position = position
        
        let rotation = SKAction.repeatForever(SKAction.rotate(byAngle: .pi, duration: 4))
        teleporter.run(rotation)
        
        teleporter.physicsBody = SKPhysicsBody(circleOfRadius: teleporter.size.width / 2)
        teleporter.physicsBody?.categoryBitMask = CollisionTypes.teleporter.rawValue
        teleporter.physicsBody?.isDynamic = false
        teleporter.physicsBody?.collisionBitMask = 0
        teleporter.physicsBody?.contactTestBitMask = CollisionTypes.player.rawValue
        
        addChild(teleporter)
    }
    
    func addFinish(at position: CGPoint) {
        let finish = SKSpriteNode(imageNamed: "finish")
        finish.name = "finish"
        finish.position = position
        
        finish.physicsBody = SKPhysicsBody(circleOfRadius: finish.size.width / 2)
        finish.physicsBody?.categoryBitMask = CollisionTypes.finish.rawValue
        finish.physicsBody?.isDynamic = false
        finish.physicsBody?.collisionBitMask = 0
        finish.physicsBody?.contactTestBitMask = CollisionTypes.player.rawValue
        
        addChild(finish)
    }
    
    func createPlayer() {
        player = SKSpriteNode(imageNamed: "player")
        player.name = "player"
        player.position = CGPoint(x: 96, y: 672) // Exact position for level 1...
        player.zPosition = 1
        
        player.physicsBody = SKPhysicsBody(circleOfRadius: player.size.width / 2)
        player.physicsBody?.allowsRotation = false
        player.physicsBody?.linearDamping = 0.5
        player.physicsBody?.categoryBitMask = CollisionTypes.player.rawValue
        player.physicsBody?.contactTestBitMask = CollisionTypes.star.rawValue | CollisionTypes.vortex.rawValue | CollisionTypes.teleporter.rawValue | CollisionTypes.finish.rawValue
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
        if node.name == "star" {
            node.removeFromParent()
            score += 1
        } else if node.name == "vortex" {
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
                self?.physicsWorld.gravity = .zero // Reset gravity when teleporting back...
            }
        } else if node.name == "teleporter" {
            // Teleport player...
        } else if node.name == "finish" {
            // Go to next level if possible...
            if level != maxLevel {
                goToNextLevel()
            } else {
                isGameOver = true
            }
        }
    }
    
    func goToNextLevel() {
        level += 1
        
        let nodesToRemove: [String?] = [
            "player", "wall", "star",
            "vortex", "teleporter", "finish"
        ]
        
        // Remove everything but background and label nodes...
        for node in children {
            if nodesToRemove.contains(node.name) {
                node.removeFromParent()
            }
        }
        
        // Recreate the level and player...
        loadLevel()
        createPlayer()
    }
}
