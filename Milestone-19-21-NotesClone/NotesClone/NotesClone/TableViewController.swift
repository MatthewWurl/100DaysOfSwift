//
//  TableViewController.swift
//  NotesClone
//
//  Created by Matt X on 12/28/22.
//

import UIKit

class TableViewController: UITableViewController {
    var notes: [Note] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Notes"
        
        // Set up navigation bar...
        let editButton = UIBarButtonItem(
            barButtonSystemItem: .edit,
            target: self,
            action: nil
        )
        
        navigationItem.rightBarButtonItem = editButton
        
        // Set up bottom toolbar...
        let spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        
        let newNoteButton = UIBarButtonItem(
            barButtonSystemItem: .compose,
            target: self,
            action: #selector(createNewNote)
        )
        
        toolbarItems = [spacer, newNoteButton]
        navigationController?.isToolbarHidden = false
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notes.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let note = notes[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "NoteCell", for: indexPath)
        
        cell.textLabel?.text = note.title
        cell.detailTextLabel?.text = note.content.isEmpty ? "No additional content" : note.content
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let note = notes[indexPath.row]
        
        if let noteVC = storyboard?.instantiateViewController(withIdentifier: "NoteVC") as? NoteViewController {
            noteVC.note = note
            noteVC.saveCallback = { [weak self] note in
                self?.notes.append(note)
                
                self?.tableView.reloadData()
            }
            
            navigationController?.pushViewController(noteVC, animated: true)
        }
    }
    
    @objc func createNewNote() {
        if let noteVC = storyboard?.instantiateViewController(withIdentifier: "NoteVC") as? NoteViewController {
            noteVC.note = Note() // New default note...
            noteVC.saveCallback = { [weak self] note in
                self?.notes.append(note)
                
                self?.tableView.reloadData()
            }
            
            navigationController?.pushViewController(noteVC, animated: true)
        }
    }
}
