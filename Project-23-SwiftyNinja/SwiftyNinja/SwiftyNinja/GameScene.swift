//
//  GameScene.swift
//  SwiftyNinja
//
//  Created by Matt X on 1/1/23.
//

import AVFoundation
import SpriteKit

class GameScene: SKScene {
    enum ForceBomb {
        case always, never, random
    }
    
    var activeEnemies: [SKSpriteNode] = []
    var activeSliceBG: SKShapeNode!
    var activeSliceFG: SKShapeNode!
    var activeSlicePoints: [CGPoint] = []
    var bombSoundEffect: AVAudioPlayer?
    var isSwooshSoundActive = false
    var lives = 3
    var livesImages: [SKSpriteNode] = []
    var score = 0 {
        didSet {
            scoreLabel.text = "Score: \(score)"
        }
    }
    var scoreLabel: SKLabelNode!
    
    override func didMove(to view: SKView) {
        let background = SKSpriteNode(imageNamed: "sliceBackground")
        background.position = CGPoint(x: 512, y: 384)
        background.blendMode = .replace
        background.zPosition = -1
        addChild(background)
        
        physicsWorld.gravity = CGVector(dx: 0, dy: -6)
        physicsWorld.speed = 0.85
        
        createScore()
        createLives()
        createSlices()
    }
    
    func createScore() {
        scoreLabel = SKLabelNode(fontNamed: "Chalkduster")
        scoreLabel.horizontalAlignmentMode = .left
        scoreLabel.fontSize = 48
        scoreLabel.position = CGPoint(x: 8, y: 8)
        addChild(scoreLabel)
        
        score = 0
    }
    
    func createLives() {
        for i in 0..<3 {
            let spriteNode = SKSpriteNode(imageNamed: "sliceLife")
            let xPos = CGFloat(834 + (i * 70))
            spriteNode.position = CGPoint(x: xPos, y: 720)
            addChild(spriteNode)
            
            livesImages.append(spriteNode)
        }
    }
    
    func createSlices() {
        activeSliceBG = SKShapeNode()
        activeSliceBG.strokeColor = UIColor(red: 1, green: 0.9, blue: 0, alpha: 1)
        activeSliceBG.lineWidth = 9
        activeSliceBG.zPosition = 2
        addChild(activeSliceBG)
        
        activeSliceFG = SKShapeNode()
        activeSliceFG.strokeColor = .white
        activeSliceFG.lineWidth = 5
        activeSliceFG.zPosition = 3
        addChild(activeSliceFG)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        activeSlicePoints.removeAll(keepingCapacity: true)
        let location = touch.location(in: self)
        activeSlicePoints.append(location)
        
        redrawActiveSlice()
        
        activeSliceBG.removeAllActions()
        activeSliceBG.alpha = 1
        
        activeSliceFG.removeAllActions()
        activeSliceFG.alpha = 1
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        activeSlicePoints.append(location)
        
        redrawActiveSlice()
        
        if !isSwooshSoundActive {
            playSwooshSound()
        }
    }
    
    func playSwooshSound() {
        isSwooshSoundActive = true
        
        let randomNumber = Int.random(in: 1...3)
        let soundName = "swoosh\(randomNumber).caf"
        
        let swooshSound = SKAction.playSoundFileNamed(soundName, waitForCompletion: true)
        
        run(swooshSound) { [weak self] in
            self?.isSwooshSoundActive = false
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        activeSliceBG.run(.fadeOut(withDuration: 0.25))
        activeSliceFG.run(.fadeOut(withDuration: 0.25))
    }
    
    func redrawActiveSlice() {
        guard activeSlicePoints.count >= 2 else {
            activeSliceBG.path = nil
            activeSliceFG.path = nil
            return
        }
        
        if activeSlicePoints.count > 12 {
            activeSlicePoints.removeFirst(activeSlicePoints.count - 12)
        }
        
        let path = UIBezierPath()
        path.move(to: activeSlicePoints.first!)
        
        for i in 1..<activeSlicePoints.count {
            path.addLine(to: activeSlicePoints[i])
        }
        
        activeSliceBG.path = path.cgPath
        activeSliceFG.path = path.cgPath
    }
    
    func createEnemy(forceBomb: ForceBomb = .random) {
        let enemy: SKSpriteNode
        
        var enemyType = Int.random(in: 0...6)
        
        switch forceBomb {
        case .never:
            enemyType = 1
        case .always:
            enemyType = 0
        default:
            break
        }
        
        if enemyType == 0 {
            enemy = SKSpriteNode()
            enemy.zPosition = 1
            enemy.name = "BombContainer"
            
            let bombImage = SKSpriteNode(imageNamed: "sliceBomb")
            bombImage.name = "Bomb"
            enemy.addChild(bombImage)
            
            if bombSoundEffect != nil {
                bombSoundEffect?.stop()
                bombSoundEffect = nil
            }
            
            if let path = Bundle.main.url(forResource: "sliceBombFuse", withExtension: "caf") {
                if let sound = try? AVAudioPlayer(contentsOf: path) {
                    bombSoundEffect = sound
                    sound.play()
                }
            }
            
            if let emitter = SKEmitterNode(fileNamed: "sliceFuse") {
                emitter.position = CGPoint(x: 76, y: 64)
                enemy.addChild(emitter)
            }
        } else {
            enemy = SKSpriteNode(imageNamed: "penguin")
            let launchSound = SKAction.playSoundFileNamed("launch.caf", waitForCompletion: false)
            run(launchSound)
            enemy.name = "Enemy"
        }
        
        let randomX = Int.random(in: 64...960)
        let randomPosition = CGPoint(x: randomX, y: -128)
        enemy.position = randomPosition
        
        let randomAngularVelocity = CGFloat.random(in: -3...3)
        let randomXVelocity: Int
        
        if randomPosition.x < 256 {
            randomXVelocity = Int.random(in: 8...15)
        } else if randomPosition.x < 512 {
            randomXVelocity = Int.random(in: 3...5)
        } else if randomPosition.x < 768 {
            randomXVelocity = -1 * Int.random(in: 3...5)
        } else {
            randomXVelocity = -1 * Int.random(in: 8...15)
        }
        
        let randomYVelocity = Int.random(in: 24...32)
        
        enemy.physicsBody = SKPhysicsBody(circleOfRadius: 64)
        enemy.physicsBody?.velocity = CGVector(dx: randomXVelocity * 40, dy: randomYVelocity * 40)
        enemy.physicsBody?.angularVelocity = randomAngularVelocity
        enemy.physicsBody?.collisionBitMask = 0
        
        addChild(enemy)
        
        activeEnemies.append(enemy)
    }
    
    override func update(_ currentTime: TimeInterval) {
        var isActiveBombFound = false
        
        for node in activeEnemies {
            if node.name == "BombContainer" {
                isActiveBombFound = true
                break
            }
        }
        
        if isActiveBombFound == false {
            // No bombs - stop the fuse sound...
            bombSoundEffect?.stop()
            bombSoundEffect = nil
        }
    }
}
