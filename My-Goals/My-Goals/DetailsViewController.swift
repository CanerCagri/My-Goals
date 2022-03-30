//
//  DetailsViewController.swift
//  My-Goals
//
//  Created by Caner Çağrı on 29.03.2022.
//

import UIKit

class DetailsViewController: UIViewController {

    @IBOutlet var goalTextField: UITextField!
    
    @IBOutlet var explainTextView: UITextView!
    
    @IBOutlet var picker: UIPickerView!
    
    let pickerValues = ["5", "4", "3", "2", "1"]
   
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        picker.dataSource = self
        picker.delegate = self
        explainTextView.delegate = self
        
        explainTextView.textColor = UIColor.darkGray
        
        

        
       
    }
    override func viewDidAppear(_ animated: Bool) {
        
    }
   
    @IBAction func saveBtnTapped(_ sender: Any) {
        
       
    }
    

}

extension DetailsViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    //row count
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerValues.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        return pickerValues[row]
        
        
    }
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        
        let pickerLabel = UILabel()
            let titleData = pickerValues[row]
        let myTitle = NSAttributedString(string: titleData, attributes: [NSAttributedString.Key.font:UIFont(name: "Georgia", size: 26.0)!,NSAttributedString.Key.foregroundColor:UIColor.black])
            pickerLabel.attributedText = myTitle
        
        let hue = CGFloat(row)/CGFloat(pickerValues.count)
        pickerLabel.backgroundColor = UIColor(hue: hue, saturation: 1.0, brightness:1.0, alpha: 1.0)
        pickerLabel.textAlignment = .center
        
        return pickerLabel
    }
    
}
extension DetailsViewController : UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if (explainTextView.text == "What You Wanna Do For Success Your Goal")
            {
                explainTextView.text = nil
                explainTextView.textColor = UIColor.darkGray
            }
        textView.becomeFirstResponder()
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        
        if explainTextView.text.isEmpty
            {
                explainTextView.text = "What You Wanna Do For Success Your Goal"
                explainTextView.textColor = UIColor.darkGray
            }
            textView.resignFirstResponder()
    }
}
