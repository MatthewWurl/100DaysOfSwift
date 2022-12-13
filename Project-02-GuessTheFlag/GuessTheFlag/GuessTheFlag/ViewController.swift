//
//  ViewController.swift
//  GuessTheFlag
//
//  Created by Matt X on 11/4/22.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var button1: UIButton!
    @IBOutlet weak var button2: UIButton!
    @IBOutlet weak var button3: UIButton!
    
    var countries: [String] = []
    var score = 0
    var correctAnswer = 0
    var questionCount = 0
    var highScore = 0
    
    let NUMBER_OF_QUESTIONS = 10
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        countries = ["estonia", "france", "germany", "ireland",
                     "italy", "monaco", "nigeria", "poland",
                     "russia", "spain", "uk", "us"]
        
        button1.layer.borderWidth = 1
        button2.layer.borderWidth = 1
        button3.layer.borderWidth = 1
        
        button1.layer.borderColor = UIColor.lightGray.cgColor
        button2.layer.borderColor = UIColor.lightGray.cgColor
        button3.layer.borderColor = UIColor.lightGray.cgColor
        
        askQuestion()
        
        // Get high score from saved data if found...
        if let savedHighScore = UserDefaults.standard.data(forKey: "highScore") {
            do {
                highScore = try JSONDecoder().decode(Int.self, from: savedHighScore)
            } catch {
                print("Failed to load high score.")
            }
        }
    }
    
    func askQuestion(action: UIAlertAction! = nil) {
        resetFlagScales()
        
        if questionCount == NUMBER_OF_QUESTIONS {
            let scoreMessage: String
            
            switch score > highScore {
            case true:
                scoreMessage = "You got a new high score of \(score)!"
                saveHighScore(as: score)
            case false:
                scoreMessage = "Your score was \(score)."
            }
            
            let gameOverAlert = UIAlertController(
                title: "Game Over!",
                message: "You answered all \(NUMBER_OF_QUESTIONS) questions!\n\(scoreMessage)",
                preferredStyle: .alert
            )
            
            gameOverAlert.addAction(
                UIAlertAction(title: "Play Again", style: .default, handler: resetGame)
            )
            
            present(gameOverAlert, animated: true)
            
            return
        }
        
        questionCount += 1
        
        countries.shuffle()
        
        correctAnswer = Int.random(in: 0...2)
        
        button1.setImage(UIImage(named: countries[0]), for: .normal)
        button2.setImage(UIImage(named: countries[1]), for: .normal)
        button3.setImage(UIImage(named: countries[2]), for: .normal)
        
        let correctCountryAsTitle = countries[correctAnswer].uppercased()
        title = "\(correctCountryAsTitle) - Score: \(score)"
    }
    
    func resetGame(action: UIAlertAction! = nil) {
        score = 0
        questionCount = 0
        
        askQuestion()
    }
    
    @IBAction func buttonTapped(_ sender: UIButton) {
        var title: String
        var message = ""
        
        UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.35, initialSpringVelocity: 5) {
            sender.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
        }
        
        if sender.tag == correctAnswer {
            title = "Correct!"
            score += 1
        } else {
            title = "Incorrect!"
            message += "Sorry, that's the flag of \(countries[sender.tag].uppercased())!\n"
            score -= 1
        }
        
        message += "Your score is now \(score)."
        
        let scoreAlert = UIAlertController(
            title: title,
            message: message,
            preferredStyle: .alert
        )
        
        scoreAlert.addAction(
            UIAlertAction(title: "Continue", style: .default, handler: askQuestion)
        )
        
        present(scoreAlert, animated: true)
    }
    
    func saveHighScore(as newHighScore: Int) {
        highScore = newHighScore
        
        if let savedHighScore = try? JSONEncoder().encode(newHighScore) {
            UserDefaults.standard.set(savedHighScore, forKey: "highScore")
        } else {
            print("Failed to save high score.")
        }
    }
    
    func resetFlagScales() {
        button1.transform = .identity
        button2.transform = .identity
        button3.transform = .identity
    }
}
