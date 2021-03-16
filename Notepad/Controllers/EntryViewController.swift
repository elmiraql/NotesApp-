//
//  EntryViewController.swift
//  Notepad
//
//  Created by Elmira on 12.03.21.
//

import UIKit

class EntryViewController: UIViewController {
    
    @IBOutlet weak var titleField: UITextField!
    @IBOutlet var noteField: UITextView!
    
    public var completion: ((String, String) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        titleField.becomeFirstResponder()
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .done, target: self, action: #selector(saveButtonPressed))
    }
    
    @objc func saveButtonPressed (){
        if let text = titleField.text, !text.isEmpty, !noteField.text.isEmpty {
            completion?(text, noteField.text)
        }
    }
}
