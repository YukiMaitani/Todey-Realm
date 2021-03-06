//
//  ItemListViewController.swift
//  Todoey-Realm
//
//  Created by 米谷裕輝 on 2022/06/25.
//

import UIKit
import RealmSwift

class ToDoListViewController: UITableViewController {
    
    let realm = try! Realm()
    var items:Results<Item>!
    var selectedCategory:Category? {
        didSet {
            loadItems()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        items.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "ToDoItemCell")
        let item = items[indexPath.row]
        var content = cell.defaultContentConfiguration()
        content.text = item.title
        cell.accessoryType = item.done ? .checkmark : .none
        cell.contentConfiguration = content
        return cell
    }
    
    // MARK: - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        do {
            try realm.write{
                items[indexPath.row].done = !items[indexPath.row].done
            }
        } catch {
            print("アイテムの更新に失敗しました\(error)")
        }
        self.tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle,
                            forRowAt indexPath: IndexPath) {
        do {
            try realm.write {
                realm.delete(items[indexPath.row])
            }
        } catch {
            print("アイテムの削除に失敗しました\(error)")
        }
        tableView.reloadData()
    }

    // MARK: - Model Manupulation Methods
    
    func loadItems() {
        items = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)
        tableView.reloadData()
    }
    
    // MARK: - Add New Item
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        let alert = UIAlertController(title: "アイテムを追加します", message: nil, preferredStyle: .alert)
        let action = UIAlertAction(title: "追加", style: .default) { _ in
            if let currentCategory = self.selectedCategory {
                do {
                    try self.realm.write{
                        let newItem = Item()
                        newItem.title = textField.text!
                        newItem.dateCreated = Date()
                        currentCategory.items.append(newItem)
                    }
                }catch {
                    print("アイテムの保存に失敗しました\(error)")
                }
            }
            self.tableView.reloadData()
        }
        alert.addAction(action)
        alert.addTextField { alertTextField in
            alertTextField.placeholder = "アイテムを記入してください"
            textField = alertTextField
        }
        present(alert, animated: true)
    }
    
}

// MARK: - Search Bar Methods

extension ToDoListViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        items = items.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: false)
        tableView.reloadData()
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

