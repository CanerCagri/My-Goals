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
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var goalTextField: UITextField!
    @IBOutlet var explainTextView: UITextView!
    @IBOutlet var saveButton: UIButton!
    
    var selectedItemName = ""
    var selectedDescription = ""
    var selectedUUID : UUID?
    var selectedPriority = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        explainTextView.delegate = self
        title = "My Goals"
        explainTextView.textColor = UIColor.darkGray
        
        if selectedItemName == "" {
            goalTextField.text = ""
            selectedPriority = false
            saveButton.isEnabled = true
            `switch`.isEnabled = true
            goalTextField.isEnabled = true
            explainTextView.isEditable = true
            
        } else {
            goalTextField.text = selectedItemName
            explainTextView.text = selectedDescription
            `switch`.isOn = selectedPriority
            `switch`.isEnabled = false
            saveButton.isEnabled = false
            goalTextField.isEnabled = false
            explainTextView.isEditable = false
        }
    }
    
    @IBAction func `switch`(_ sender: UISwitch) {
        if sender.isOn == true {
            selectedPriority = true
        } else {
            selectedPriority = false
        }
    }
    @IBAction func cancelBtnTapped(_ sender: Any) {
        dismiss(animated: true)
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
            dismiss(animated: true)
        }catch {
            fatalError("Error when saving data.")
        }
        NotificationCenter.default.post(name: NSNotification.Name("dataEntered"), object: nil)
        self.navigationController?.popViewController(animated: true)
    }
}

extension DetailsViewController : UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if explainTextView.text == "What needs to be done to achieve your goal"
        {
            explainTextView.text = nil
            explainTextView.textColor = UIColor.darkGray
        }
        textView.becomeFirstResponder()
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if explainTextView.text.isEmpty
        {
            explainTextView.text = "What needs to be done to achieve your goal"
            explainTextView.textColor = UIColor.darkGray
        }
        textView.resignFirstResponder()
    }
    
}
