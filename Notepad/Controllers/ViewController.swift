//
//  ViewController.swift
//  Notepad
//
//  Created by Elmira on 12.03.21.
//

import UIKit
import RealmSwift
import SwipeCellKit

class ViewController: UIViewController {
    
    let realm = try! Realm()
    var notes: Results<Item>?
    
    
    @IBOutlet var table: UITableView!
    @IBOutlet var label: UILabel!
    @IBOutlet weak var searchField: UISearchBar!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Notes"
        table.delegate = self
        table.dataSource = self
        table.rowHeight = 70.0
        searchField.delegate = self
        loadItems()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        searchField.barTintColor = UIColor(named: "BeigeColor")
    }
    
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        guard let vc = storyboard?.instantiateViewController(identifier: "new") as? EntryViewController else {
            return
        }
        vc.title = "New Note"
        vc.completion = { noteTitle, note in
            self.navigationController?.popToRootViewController(animated: true)
            let newNote = Item()
            newNote.title = noteTitle
            newNote.note = note
            newNote.date = Date()
            self.save(item: newNote)
            self.label.isHidden = true
            self.table.reloadData()
        }
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func save (item: Item) {
        do {
            try realm.write{
                realm.add(item)
            }
        } catch {
            print(error)
        }
    }
    
    func loadItems () {
        notes = realm.objects(Item.self).sorted(byKeyPath: "date", ascending: false)
        table.reloadData()
    }
}



extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notes?.count ?? 1
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! SwipeTableViewCell
        cell.delegate = self
        cell.textLabel?.text = notes?[indexPath.row].title ?? "No notes yet"
        cell.detailTextLabel?.text = notes?[indexPath.row].note
        return cell
    }
    
}

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        guard let vc = storyboard?.instantiateViewController(identifier: "note") as? NoteViewController else {
            return
        }
        if let note = notes?[indexPath.row] {
            vc.title = "Note"
            vc.noteTitle = note.title
            vc.note = note.note
        }
        
        
        let currentNote = notes?[indexPath.row]
        vc.completion = { noteText, titleText in
            self.navigationController?.popToRootViewController(animated: true)
            do {
                try self.realm.write {
                    currentNote?.note = noteText
                    currentNote?.title = titleText
                }
            } catch {
                print(error)
            }
            
            self.table.reloadData()
        }
        
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension ViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        notes = notes?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "date", ascending: false)
        table.reloadData()
        
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadItems()
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
    }
    
}

extension ViewController: SwipeTableViewCellDelegate {
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        guard orientation == .right else { return nil }
        
        let deleteAction = SwipeAction(style: .destructive, title: "Delete") { action, indexPath in
            // handle action by updating model with deletion
            if let currentNote = self.notes?[indexPath.row] {
                do {
                    try self.realm.write {
                        self.realm.delete(currentNote)
                    }
                } catch {
                    print(error)
                }
                
            }
            
        }
        
        // customize the action appearance
        deleteAction.image = UIImage(named: "delete")
        return [deleteAction]
        
    }
    func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeOptions {
        var options = SwipeOptions()
        options.expansionStyle = .destructive
        options.transitionStyle = .border
        return options
    }
}


