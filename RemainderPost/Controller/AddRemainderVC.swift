//
//  AddRemainderVC.swift
//  RemainderPost
//
//  Created by bennoui ihab on 5/15/20.
//  Copyright © 2020 bennoui ihab. All rights reserved.
//

import UIKit

class AddRemainderVC: UIViewController , UIPickerViewDelegate, UIPickerViewDataSource , UITextFieldDelegate{
    
//variables
    let nums = [Int](1...100)
    var ChosenType : RemainderType = .SimpleRemainder

//MARK: @IBOutlets
    @IBOutlet weak var RemainderType: UISegmentedControl!
    @IBOutlet weak var titleField : UITextField!
    @IBOutlet weak var datePecker : UIDatePicker!
    @IBOutlet weak var completionValuePicker : UIPickerView!
    @IBOutlet weak var PointsQues: UILabel!
    @IBOutlet weak var goalStackView: UIStackView!
    @IBOutlet weak var RemainderStackView: UIStackView!
    @IBOutlet weak var SaveBtn: UIButton!

    
    
//MARK: functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        PointsQues.textColor = .label
        
        SaveBtn.layer.cornerRadius = 25.0
        SaveBtn.tintColor = .white
        SaveBtn.layer.shadowColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        SaveBtn.tintColor = .white 
        SaveBtn.layer.shadowOpacity = 0.75
        SaveBtn.layer.shadowOffset = CGSize(width: 0, height: 0)
        
        //delegate&DAtaSource Protocols
        completionValuePicker.delegate = self
        completionValuePicker.dataSource = self
        titleField.delegate = self
        
        //bind the button to the keyboard 
        SaveBtn.bindToKeyboard()
        
        //validationsMethod
        goalStackView.isHidden = true
        RemainderStackView.isHidden = false
        
        //action for the segment control
        RemainderType.addTarget(self, action: #selector(RemainderTypeView), for: .valueChanged)
    }
    
    @objc func RemainderTypeView(){
        switch RemainderType.selectedSegmentIndex {
        case 1:
            goalStackView.isHidden = false
            RemainderStackView.isHidden = true
            ChosenType = .GoalRemainder
            
        default:
           goalStackView.isHidden = true
           RemainderStackView.isHidden = false
           ChosenType = .SimpleRemainder
        }
    }
    
//MARK: Save Datas
    func save (completion :(_ complete : Bool )-> ()){
        guard let managedContext = appDelegate?.persistentContainer.viewContext else { return }
        
        let goal = Goal(context: managedContext)
        goal.theGoal = titleField.text
        goal.goalProgress = Int32(0)
        goal.date = datePecker.date
        goal.goalCompleteValue = Int32(completionValuePicker.tag)
        goal.type = ChosenType.rawValue
        
        do{
           try  managedContext.save()
            print("succuffuly saved")
            completion(true)
            
        }catch {
            debugPrint(error.localizedDescription)
            completion(false)
        }
    }
    
  
    
//MARK: IBActions
    @IBAction func SaveBtnWasPressed(_ sender: Any) {
        if titleField.text != "" {
          
            save { (complete) in
                if complete {
                    dismiss(animated: true, completion: nil)
                }
            }
        }
    }
    
    @IBAction func backBtnAction(_ sender: Any) {
        dismissDetail()
    }
    
    
    
    
//MARK: pickerView Protocols ->
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
           return 1
    }
       
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return nums.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return String(nums[row])
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let completionValue = Int(nums[row])
        completionValuePicker.tag = completionValue
    }
}
