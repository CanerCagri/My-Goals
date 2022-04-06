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
    
    var selectedName = ""
    var selectedUUID : UUID?
    var selectedPriority : Bool?

    @IBOutlet var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(rightBarButtonTapped))
        
        tableView.delegate = self
        tableView.dataSource = self
        
        
        loadData()
    }
    override func viewWillAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self, selector: #selector(loadData), name: NSNotification.Name(rawValue: "dataEntered") , object: nil)
    }
    @objc func loadData() {
        goalArray.removeAll(keepingCapacity: false)
        idArray.removeAll(keepingCapacity: false)
        priorityArray.removeAll(keepingCapacity: false)
        descriptionArray.removeAll(keepingCapacity: false)
        
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
        return goalArray.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! GoalsTableViewCell
        
        cell.titleLabel.text = goalArray[indexPath.row]
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
        selectedName = goalArray[indexPath.row]
        selectedUUID = idArray[indexPath.row]
        selectedPriority = priorityArray[indexPath.row]
        
        performSegue(withIdentifier: "toDetailsVC", sender: nil)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toDetailsVC" {
            let destination = segue.destination as! DetailsViewController
            destination.selectedItemName = selectedName
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
                                idArray.remove(at: indexPath.row)
                                priorityArray.remove(at: indexPath.row)
                                
                                
                                self.tableView.reloadData()
                                
                                do {
                                    try context.save()
                                }catch {
                                    
                                }
                                
                                break
                            }
                        }
                    }
                }
                
            }catch {
                
            }
            
        }
    }
    //Using for clearing Coredata database
    func deleteAll() {
        let delegate = UIApplication.shared.delegate as! AppDelegate
           let context = delegate.persistentContainer.viewContext

           let deleteFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "Goals")
           let deleteRequest = NSBatchDeleteRequest(fetchRequest: deleteFetch)

           do {
               try context.execute(deleteRequest)
               try context.save()
           } catch {
               print ("There was an error")
           }
    }
}

