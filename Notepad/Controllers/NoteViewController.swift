//
//  NoteViewController.swift
//  Notepad
//
//  Created by Elmira on 12.03.21.
//

import UIKit

class NoteViewController: UIViewController {
    
    
    //@IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var titleLabel: UITextField!
    @IBOutlet weak var noteLabel: UITextView!
    
    public var completion: ((String, String) -> Void)?
    
    public var noteTitle: String = ""
    public var note: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleLabel.text = noteTitle
        noteLabel.text = note
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .done, target: self, action: #selector(saveButtonPressed))
        
    }
    
    @objc func saveButtonPressed(){
        if let text = noteLabel.text, let titleText = titleLabel.text {
            completion?(text, titleText)
        }
    }
    
}
