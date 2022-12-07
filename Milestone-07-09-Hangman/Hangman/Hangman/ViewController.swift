//
//  ViewController.swift
//  Hangman
//
//  Created by Matt X on 11/26/22.
//

import UIKit

class ViewController: UIViewController {
    private var promptLabel: UILabel!
    private var incorrectGuessesLabel: UILabel!
    private var letterButtons: [UIButton] = []
    
    private var layoutConstraints: [NSLayoutConstraint] = []
    private var words: [String] = []
    private var wordToGuess: String?
    
    private var promptArray: [String] = [] {
        didSet {
            promptLabel.text = promptArray.joined()
        }
    }
    
    private var incorrectGuesses = 0 {
        didSet {
            incorrectGuessesLabel.text = "Incorrect guesses: \(incorrectGuesses)/7"
        }
    }
    
    override func loadView() {
        view = UIView()
        view.backgroundColor = .systemBackground
        
        navigationItem.title = "Hangman"
        
        setupBarButtonItems()
        
        buildPromptLabel()
        buildIncorrectGuessesLabel()
        buildButtonsView()
        
        NSLayoutConstraint.activate(layoutConstraints)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadWordsFile()
        
        restartGame()
    }
    
    func loadWordsFile() {
        guard let fileURL = Bundle.main.url(forResource: "words", withExtension: "txt") else {
            fatalError("Could not find words.txt in bundle.")
        }
        
        guard let fileContents = try? String(contentsOf: fileURL) else {
            fatalError("Could not get contents of words.txt from bundle.")
        }
        
        words = fileContents.trimmingCharacters(in: .newlines).components(separatedBy: .newlines)
    }
    
    @objc func restartGame(_ action: UIAlertAction? = nil) {
        wordToGuess = words.randomElement()
        
        promptArray = Array<String>(repeating: "?", count: wordToGuess!.count)
        
        incorrectGuesses = 0
        
        for button in letterButtons {
            button.isHidden = false
        }
    }
    
    func setupBarButtonItems() {
        let restartButton = UIBarButtonItem(
            barButtonSystemItem: .refresh,
            target: self,
            action: #selector(restartGame)
        )
        
        navigationItem.leftBarButtonItem = restartButton
    }
    
    func buildPromptLabel() {
        promptLabel = UILabel()
        promptLabel.translatesAutoresizingMaskIntoConstraints = false
        promptLabel.textAlignment = .center
        promptLabel.font = UIFont.systemFont(ofSize: 32, weight: .semibold)
        
        view.addSubview(promptLabel)
        
        layoutConstraints += [
            promptLabel.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor, constant: 20),
            promptLabel.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor),
            promptLabel.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor)
        ]
    }
    
    func buildIncorrectGuessesLabel() {
        incorrectGuessesLabel = UILabel()
        incorrectGuessesLabel.translatesAutoresizingMaskIntoConstraints = false
        incorrectGuessesLabel.textAlignment = .center
        incorrectGuessesLabel.text = "Incorrect guesses: \(incorrectGuesses)/7"
        
        view.addSubview(incorrectGuessesLabel)
        
        layoutConstraints += [
            incorrectGuessesLabel.topAnchor.constraint(equalTo: promptLabel.bottomAnchor, constant: 20),
            incorrectGuessesLabel.centerXAnchor.constraint(equalTo: view.layoutMarginsGuide.centerXAnchor)
        ]
    }
    
    func buildButtonsView() {
        let buttonsView = UIView()
        let buttonSize = 44
        
        buttonsView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(buttonsView)
        
        layoutConstraints += [
            buttonsView.heightAnchor.constraint(equalToConstant: CGFloat(buttonSize) * 4),
            buttonsView.widthAnchor.constraint(equalToConstant: CGFloat(buttonSize) * 7),
            buttonsView.centerXAnchor.constraint(equalTo: view.layoutMarginsGuide.centerXAnchor),
            buttonsView.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor, constant: -20)
        ]
        
        let letters = (97...122).map { Character(UnicodeScalar($0)) } // Returns an array of 26 characters a-z
        var charIndex = 0
        
        for row in 0..<4 {
            for col in 0..<7 {
                guard charIndex < 26 else { return }
                
                let letterButton = UIButton(type: .system)
                letterButton.setTitle(String(letters[charIndex]), for: .normal)
                letterButton.titleLabel?.font = UIFont.systemFont(ofSize: 24, weight: .semibold)
                letterButton.tintColor = .label
                
                let frame = CGRect(
                    x: col * 44, y: row * 44,
                    width: 44, height: 44
                )
                
                letterButton.frame = frame
                letterButton.layer.borderColor = UIColor.lightGray.cgColor
                letterButton.layer.borderWidth = 1
                letterButton.layer.cornerRadius = 12
                
                letterButton.addTarget(self, action: #selector(letterButtonTapped), for: .touchUpInside)
                
                letterButtons.append(letterButton)
                buttonsView.addSubview(letterButton)
                
                charIndex += 1
            }
        }
    }
    
    @objc func letterButtonTapped(_ sender: UIButton) {
        guard let wordToGuess = wordToGuess else { return }
        guard let senderTitle = sender.currentTitle else { return }
        
        sender.isHidden = true
        
        let charTapped = Character(senderTitle)
        var charFound = false
        
        // Replace any question marks with char...
        for (index, char) in wordToGuess.enumerated() {
            if char == charTapped {
                promptArray[index] = String(char)
                charFound = true
            }
        }
        
        // Char does not exist in the word...
        if !charFound {
            incorrectGuesses += 1
            
            if incorrectGuesses == 7 {
                showGameOverAlert(
                    title: "Out of guesses!",
                    message: "The word was \(wordToGuess). Play again?"
                )
            }
        }
        
        // Player has found the word...
        if wordToGuess == promptArray.joined() {
            showGameOverAlert(
                title: "Congrats!",
                message: "You correctly guessed the word. Play again?"
            )
        }
    }
    
    func showGameOverAlert(title: String, message: String) {
        let ac = UIAlertController(
            title: title,
            message: message,
            preferredStyle: .alert
        )
        
        ac.addAction(
            UIAlertAction(title: "OK", style: .default, handler: restartGame)
        )
        
        present(ac, animated: true)
    }
}
