//
//  NoteViewController.swift
//  NotesClone
//
//  Created by Matt X on 12/28/22.
//

import UIKit

class NoteViewController: UIViewController {
    @IBOutlet weak var noteTextView: UITextView!
    
    var note: Note!
    var saveCallback: ((Note) -> ())?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        noteTextView.becomeFirstResponder() // Focus UITextView...
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let shareButton = UIBarButtonItem(
            barButtonSystemItem: .action,
            target: self,
            action: #selector(shareNoteContent)
        )

        navigationItem.rightBarButtonItem = shareButton
        navigationItem.rightBarButtonItem?.isEnabled = !note.content.isEmpty
        
        noteTextView.layer.borderColor = UIColor.black.cgColor
        noteTextView.layer.borderWidth = 2
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        saveCallback?(note)
    }
    
    @objc func shareNoteContent() {
        let noteContent = note.content
        
        let activityVC = UIActivityViewController(
            activityItems: [noteContent],
            applicationActivities: nil
        )
        
        present(activityVC, animated: true)
    }
}
