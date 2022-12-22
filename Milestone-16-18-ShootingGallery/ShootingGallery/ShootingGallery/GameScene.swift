//
//  GameScene.swift
//  ShootingGallery
//
//  Created by Matt X on 12/20/22.
//

import SpriteKit

class GameScene: SKScene {
    enum Row: Int {
        case bottom = 50
        case middle = 250
        case top = 450
    }
    
    static let WIDTH = 1024
    static let HEIGHT = 768
    
    var shotsRemainingLabel: SKLabelNode!
    var gameOverNode: SKSpriteNode!
    var scoreLabel: SKLabelNode!
    var timeRemainingLabel: SKLabelNode!
    
    var gameTimer: Timer?
    var targetTimer: Timer?
    
    var shotsRemaining = 5 {
        didSet {
            shotsRemainingLabel.text = "Shots: \(shotsRemaining)"
        }
    }
    
    var score = 0 {
        didSet {
            scoreLabel.text = "Score: \(score)"
        }
    }
    
    var timeRemaining = 60 {
        didSet {
            timeRemainingLabel.text = "Time: \(timeRemaining)s"
        }
    }
    
    override func didMove(to view: SKView) {
        let background = SKSpriteNode(imageNamed: "wood-background")
        background.position = CGPoint(x: GameScene.WIDTH / 2, y: GameScene.HEIGHT / 2)
        background.size = frame.size
        background.zPosition = -1
        background.blendMode = .replace
        addChild(background)
        
        scoreLabel = SKLabelNode(fontNamed: "Chalkduster")
        scoreLabel.position = CGPoint(x: 25, y: GameScene.HEIGHT - 60)
        scoreLabel.horizontalAlignmentMode = .left
        scoreLabel.fontSize = 36
        addChild(scoreLabel)
        
        shotsRemainingLabel = SKLabelNode(fontNamed: "Chalkduster")
        shotsRemainingLabel.position = CGPoint(x: GameScene.WIDTH - 25, y: GameScene.HEIGHT - 60)
        shotsRemainingLabel.horizontalAlignmentMode = .right
        shotsRemainingLabel.fontSize = 36
        addChild(shotsRemainingLabel)
        
        timeRemainingLabel = SKLabelNode(fontNamed: "Chalkduster")
        timeRemainingLabel.position = CGPoint(x: GameScene.WIDTH / 2, y: GameScene.HEIGHT - 60)
        timeRemainingLabel.horizontalAlignmentMode = .center
        timeRemainingLabel.fontSize = 36
        addChild(timeRemainingLabel)
        
        physicsWorld.gravity = .zero
        
        startGame()
    }
    
    func startGame() {
        score = 0
        shotsRemaining = 5
        timeRemaining = 60
        
        gameTimer = Timer.scheduledTimer(
            timeInterval: 1,
            target: self,
            selector: #selector(decreaseGameTime),
            userInfo: nil,
            repeats: true
        )
        
        targetTimer = Timer.scheduledTimer(
            timeInterval: 0.5,
            target: self,
            selector: #selector(generateTargets),
            userInfo: nil,
            repeats: true
        )
    }
    
    func createTarget(atRow row: Row) {
        let target = Target()
        target.configure()
        target.target.name = "Target"
        
        var xMovement: CGFloat
        var xPosition: Int
        
        switch row {
        case .bottom:
            target.zPosition = 3
            xMovement = CGFloat(GameScene.WIDTH) + 80
            xPosition = 0 - 30
        case .middle:
            target.zPosition = 2
            target.setScale(0.75)
            xMovement = -1 * CGFloat(GameScene.WIDTH) - 80
            xPosition = 1024 + 30
            target.xScale *= -1 // Mirror target to face other direction
        case .top:
            target.zPosition = 1
            target.setScale(0.50)
            xMovement = CGFloat(GameScene.WIDTH) + 80
            xPosition = 0 - 30
        }
        
        target.position = CGPoint(x: xPosition, y: row.rawValue)
        
        let moveAction = SKAction.moveBy(x: xMovement, y: 0, duration: 3)
        let deleteAction = SKAction.customAction(withDuration: 1) { node, _ in
            node.removeFromParent()
        }
        let sequence = SKAction.sequence([moveAction, deleteAction])
        target.run(sequence)
        
        addChild(target)
    }
    
    @objc func generateTargets() {
        // 2/5 chances to spawn a target...
        if Int.random(in: 1...5) <= 2 {
            createTarget(atRow: .bottom)
        }
        if Int.random(in: 1...5) <= 2 {
            createTarget(atRow: .middle)
        }
        if Int.random(in: 1...5) <= 2 {
            createTarget(atRow: .top)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard timeRemaining > 0 else { return }
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        let tappedNodes = nodes(at: location)
        
        if shotsRemaining == 0 {
            run(emptySound)
            return
        }
        
        shotsRemaining -= 1
        run(shotSound)
        
        for node in tappedNodes {
            if node.name == "Target" {
                score += 1
                
                node.parent?.removeFromParent()
            }
        }
    }
    
    @objc func decreaseGameTime() {
        timeRemaining -= 1
        
        if timeRemaining <= 0 {
            gameOver()
        }
    }
    
    func gameOver() {
        gameTimer?.invalidate()
        targetTimer?.invalidate()
        
        gameOverNode = SKSpriteNode(imageNamed: "game-over")
        gameOverNode.position = CGPoint(x: GameScene.WIDTH / 2, y: GameScene.HEIGHT / 2)
        gameOverNode.zPosition = 100
        addChild(gameOverNode)
        
        run(gameOverSound)
    }
}
