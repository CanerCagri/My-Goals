//
//  DetailsViewController.swift
//  My-Goals
//
//  Created by Caner Çağrı on 29.03.2022.
//

import UIKit
import CoreData

class DetailsViewController: UIViewController {

    @IBOutlet var `switch`: UISwitch!
    @IBOutlet var goalTextField: UITextField!
    @IBOutlet var explainTextView: UITextView!
    
    var selectedItemName = ""
    var selectedDescription = ""
    var selectedUUID : UUID?
    var selectedPriority = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        explainTextView.delegate = self
        explainTextView.textColor = UIColor.darkGray
        
        if selectedItemName == "" {
            goalTextField.text = ""
            explainTextView.text = ""
            selectedPriority = false
        } else {
            goalTextField.text = selectedItemName
            explainTextView.text = selectedDescription
            `switch`.isOn = selectedPriority
        }
       
    }
    override func viewDidAppear(_ animated: Bool) {
        
    }
   
    @IBAction func `switch`(_ sender: UISwitch) {
        if sender.isOn == true {
            selectedPriority = true
        } else {
            selectedPriority = false
        }
    }
    
   
    
    @IBAction func saveBtnTapped(_ sender: Any) {
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        let context = (appDelegate?.persistentContainer.viewContext)!
        let goals = NSEntityDescription.insertNewObject(forEntityName: "Goals", into: context)
        
        goals.setValue(goalTextField.text!, forKey: "goal")
        goals.setValue(explainTextView.text!, forKey: "goalDescription")
        goals.setValue(selectedPriority, forKey: "priority")
        goals.setValue(UUID(), forKey: "id")
        
        do {
            try context.save()
            print("Save completed!")
        }catch {
            print("Error , didnt save!")
        }
        NotificationCenter.default.post(name: NSNotification.Name("dataEntered"), object: nil)
        self.navigationController?.popViewController(animated: true)
    }
}

extension DetailsViewController : UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if (explainTextView.text == "For Success Your Goal")
            {
                explainTextView.text = nil
                explainTextView.textColor = UIColor.darkGray
            }
        textView.becomeFirstResponder()
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if explainTextView.text.isEmpty
            {
                explainTextView.text = "For Success Your Goal"
                explainTextView.textColor = UIColor.darkGray
            }
        textView.resignFirstResponder()
    }
  
}
