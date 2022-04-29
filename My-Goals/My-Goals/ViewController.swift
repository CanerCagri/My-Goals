//
//  ViewController.swift
//  My-Goals
//
//  Created by Caner Çağrı on 29.03.2022.
//

import UIKit
import CoreData

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var goalArray : [String] = []
    var descriptionArray : [String] = []
    var idArray : [UUID] = []
    var priorityArray : [Bool] = []
    
    var filteredGoals : [String] = []
    
    var selectedName = ""
    var selectedDesc = ""
    var selectedUUID : UUID?
    var selectedPriority : Bool? = false
    
    let searchController = UISearchController()
    @IBOutlet var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadingDatas()
        loadData()
        initSearchController()
    }
    
    func loadingDatas() {
        title = "My Goals"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(rightBarButtonTapped))
        
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func initSearchController() {
        
        searchController.loadViewIfNeeded()
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.enablesReturnKeyAutomatically = false
        searchController.searchBar.returnKeyType = UIReturnKeyType.done
        definesPresentationContext = true
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        searchController.searchBar.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self, selector: #selector(loadData), name: NSNotification.Name(rawValue: "dataEntered") , object: nil)
    }
    
    @objc func loadData() {
        
        goalArray.removeAll(keepingCapacity: false)
        idArray.removeAll(keepingCapacity: false)
        priorityArray.removeAll(keepingCapacity: false)
        descriptionArray.removeAll(keepingCapacity: false)
        
        initSearchController()
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Goals")
        fetchRequest.returnsObjectsAsFaults = false
        do {
            let results = try context.fetch(fetchRequest)
            
            if results.count > 0 {
                for result in results as! [NSManagedObject] {
                    if let goal = result.value(forKey: "goal") as? String {
                        goalArray.append(goal)
                    }
                    if let id = result.value(forKey: "id") as? UUID {
                        idArray.append(id)
                    }
                    if let description = result.value(forKey: "goalDescription") as? String {
                        descriptionArray.append(description)
                    }
                    if let priority = result.value(forKey: "priority") as? Bool {
                        priorityArray.append(priority)
                    }
                }
                tableView.reloadData()
            }
        } catch {
            print("Get error when loading data")
        }
    }
    
    @objc func rightBarButtonTapped() {
        selectedName = ""
        performSegue(withIdentifier: "toDetailsVC", sender: self)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(searchController.isActive) {
            return filteredGoals.count
        }
        return goalArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! GoalsTableViewCell
        
        var goalArrayItems = goalArray[indexPath.row]
        if searchController.isActive {
            goalArrayItems = filteredGoals[indexPath.row]
        } else if searchController.searchBar.text == nil {
            goalArrayItems = goalArray[indexPath.row]
        } else {
            goalArrayItems = goalArray[indexPath.row]
        }
        
        cell.titleLabel.text = goalArrayItems
        if priorityArray[indexPath.row] == true {
            cell.cellimageview.isHidden = false
            cell.titleLabel.textColor = .red
        } else {
            cell.cellimageview.isHidden = true
            cell.titleLabel.textColor = .black
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if searchController.isActive {
            selectedName = filteredGoals[indexPath.row]
        } else {
            selectedName = goalArray[indexPath.row]
        }
        performSegue(withIdentifier: "toDetailsVC", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toDetailsVC" {
            let destination = segue.destination as! DetailsViewController
            destination.selectedItemName = selectedName
            destination.selectedDescription = selectedDesc
            destination.selectedUUID = selectedUUID
            destination.selectedPriority = selectedPriority ?? false
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let uuidString = idArray[indexPath.row].uuidString
            
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let context = appDelegate.persistentContainer.viewContext
            
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Goals")
            fetchRequest.predicate = NSPredicate(format: "id = %@", uuidString)
            fetchRequest.returnsObjectsAsFaults = false
            
            do {
                let results = try context.fetch(fetchRequest)
                
                if results.count > 0 {
                    for result in results as! [NSManagedObject]{
                        if let id = result.value(forKey: "id") as? UUID {
                            if id == idArray[indexPath.row] {
                                context.delete(result)
                                
                                goalArray.remove(at: indexPath.row)
                                descriptionArray.remove(at: indexPath.row)
                                idArray.remove(at: indexPath.row)
                                priorityArray.remove(at: indexPath.row)
                                self.tableView.reloadData()
                                do {
                                    try context.save()
                                }catch {
                                    print(error.localizedDescription)
                                }
                                break
                            }
                        }
                    }
                }
            }catch {
                print(error.localizedDescription)
            }
        }
    }
}

extension ViewController : UISearchBarDelegate, UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        let searchText = searchBar.text!
        filterForSearch(searchText: searchText)
    }
    
    func filterForSearch(searchText: String) {
        filteredGoals = goalArray.filter {
            shape in
            
            if(searchController.searchBar.text != "") {
                let searchTextMatch = shape.lowercased().contains(searchText.lowercased())
                return searchTextMatch
            } else {
                return true
            }
        }
        tableView.reloadData()
    }
}
