//
//  GameViewController.swift
//  ExplodingMonkeys
//
//  Created by Matt X on 1/18/23.
//

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {
    @IBOutlet weak var angleLabel: UILabel!
    @IBOutlet weak var angleSlider: UISlider!
    @IBOutlet weak var launchButton: UIButton!
    @IBOutlet weak var playerLabel: UILabel!
    @IBOutlet weak var velocityLabel: UILabel!
    @IBOutlet weak var velocitySlider: UISlider!
    
    var currentGame: GameScene?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let view = self.view as! SKView? {
            // Load the SKScene from 'GameScene.sks'
            if let scene = SKScene(fileNamed: "GameScene") {
                // Set the scale mode to scale to fit the window
                scene.scaleMode = .aspectFill
                
                // Present the scene
                view.presentScene(scene)
                
                currentGame = scene as? GameScene
                currentGame?.viewController = self
            }
            
            view.ignoresSiblingOrder = true
            
            view.showsFPS = true
            view.showsNodeCount = true
        }
        
        angleChanged(angleSlider)
        velocityChanged(velocitySlider)
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    @IBAction func angleChanged(_ sender: UISlider) {
        let angleValue = Int(angleSlider.value)
        angleLabel.text = "Angle: \(angleValue)°"
    }
    
    @IBAction func velocityChanged(_ sender: UISlider) {
        let velocityValue = Int(velocitySlider.value)
        velocityLabel.text = "Velocity: \(velocityValue)"
    }
    
    @IBAction func launchTapped(_ sender: UIButton) {
        angleSlider.isHidden = true
        angleLabel.isHidden = true
        
        velocitySlider.isHidden = true
        velocityLabel.isHidden = true
        
        launchButton.isHidden = true
        
        let angleValue = Int(angleSlider.value)
        let velocityValue = Int(velocitySlider.value)
        currentGame?.launch(angle: angleValue, velocity: velocityValue)
    }
    
    func activatePlayer(number: Int) {
        if number == 1 {
            playerLabel.text = "<<< PLAYER ONE"
        } else {
            playerLabel.text = "PLAYER TWO >>>"
        }
        
        angleSlider.isHidden = false
        angleLabel.isHidden = false
        
        velocitySlider.isHidden = false
        velocityLabel.isHidden = false
        
        launchButton.isHidden = false
    }
}
