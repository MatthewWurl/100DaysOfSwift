//
//  ViewController.swift
//  WordScramble
//
//  Created by Matt X on 11/11/22.
//

import UIKit

class ViewController: UITableViewController {
    var allWords: [String] = []
    var usedWords: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .add,
            target: self,
            action: #selector(promptForAnswer)
        )
        
        if let startWordsURL = Bundle.main.url(forResource: "start",
                                               withExtension: "txt") {
            if let startWords = try? String(contentsOf: startWordsURL) {
                allWords = startWords.components(separatedBy: .newlines)
            }
        }
        
        if allWords.isEmpty {
            fatalError("There was an issue setting the array including all words.")
        }
        
        startGame()
    }
    
    func startGame() {
        title = allWords.randomElement()?.uppercased()
        usedWords.removeAll(keepingCapacity: true)
        tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return usedWords.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Word", for: indexPath)
        
        cell.textLabel?.text = usedWords[indexPath.row]
        
        return cell
    }
    
    @objc func promptForAnswer() {
        let ac = UIAlertController(
            title: "Enter answer",
            message: nil,
            preferredStyle: .alert
        )
        
        ac.addTextField()
        
        let submitAction = UIAlertAction(title: "Submit", style: .default) { [weak self, weak ac] _ in
            guard let answer = ac?.textFields?.first?.text else { return }
            
            self?.submit(answer)
        }
        
        ac.addAction(submitAction)
        
        present(ac, animated: true)
    }
    
    func submit(_ answer: String) {
        
    }
}

