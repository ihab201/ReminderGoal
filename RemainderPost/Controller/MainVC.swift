//
//  MainVC.swift
//  RemainderPost
//
//  Created by bennoui ihab on 5/15/20.
//  Copyright © 2020 bennoui ihab. All rights reserved.
//
import UserNotifications
import UIKit
import CoreData

let appDelegate = UIApplication.shared.delegate as? AppDelegate

class MainVC: UIViewController ,UITableViewDelegate , UITableViewDataSource{
    
    var goals = [Goal]()
    var goalType : RemainderType!
    var goalTitle : String?
    var Date : Date!
    var completionValue : Int32!
    
//MARK: IBOUtlets
    @IBOutlet weak var tableView : UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.isHidden = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchCoreDataObjects()
        tableView.reloadData()
    }
    
    func initData(Title : String , Date : Date , type : RemainderType , completionValue :Int32){
          self.goalType = type
          self.goalTitle = Title
          self.Date = Date
          self.completionValue = completionValue
      }
    
    //fetch function
    func fetchCoreDataObjects(){
        self.fetch { (complete) in
            if complete {
                if goals.count >= 1 {
                    tableView.isHidden = false
                } else { tableView.isHidden = true }
            }
        }
    }
    
//MARK: IBActions 
    @IBAction func AddGoalBtnWasPressed (_ sender : Any){
        guard let addRemainder = storyboard?.instantiateViewController(withIdentifier: "AddRemainderVC")as? AddRemainderVC else {return }
        presentDetail(addRemainder)
        
        DispatchQueue.main.async {
        }
    }
    
    func test(){
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert , .sound , .badge], completionHandler: {success , error in
            if success {
                self.scheduleTest()
            }else if let error = error {
                debugPrint(error.localizedDescription)
            }
        })
        
    }
    func scheduleTest(){
         let content = UNMutableNotificationContent()
        content.title = "RemainderPost"
        content.body = goalTitle!
        content.sound = .default
        let dateTriger = Date.addingTimeInterval(10)
        let triger = UNCalendarNotificationTrigger(dateMatching: Calendar.current.dateComponents([.year , .month,.day,.hour , .second], from: dateTriger), repeats: false)
        let request = UNNotificationRequest(identifier: "some_ID", content: content, trigger: triger)
        UNUserNotificationCenter.current().add(request) { error in
            if error != nil {
                debugPrint(error!.localizedDescription)
            }
        }
    }
    
    
//MARK: tableView Protocols ->
    func numberOfSections(in tableView: UITableView) -> Int {
           return 1
       }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return goals.count
       }
       
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    if let cell = tableView.dequeueReusableCell(withIdentifier: "RemainderCell" , for: indexPath) as? RemainderCell {
        let goal = goals[indexPath.row]
        cell.configureCell(goal: goal)
        return cell
    }
    else { return UITableViewCell() }
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .none
    }
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let deleteAction = UITableViewRowAction(style: .destructive, title: "DELETE") { (rowAction, indexPath) in
            self.deleteRow(atIndexPath: indexPath)
            self.fetchCoreDataObjects()
            tableView.deleteRows(at: [indexPath], with: .automatic)
            
        }
        
        return [deleteAction]
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let managedContext = appDelegate?.persistentContainer.viewContext else { return }
        
        let ChosenGoal = goals[indexPath.row]
        if ChosenGoal.goalCompleteValue != 0 {
        if ChosenGoal.goalProgress < ChosenGoal.goalCompleteValue {
            ChosenGoal.goalProgress = ChosenGoal.goalProgress + 1
        }else { return }
        self.fetchCoreDataObjects()
        tableView.reloadRows(at: [indexPath], with: .automatic)
        tableView.reloadData()
        do{
            try managedContext.save()
            print("succuffuly added")
        }catch {
            debugPrint("Could not delete : \(error.localizedDescription)")
        }
        }
    }
    
    
    
    
}


extension MainVC {
    func deleteRow(atIndexPath indexPath : IndexPath){
        guard let managedContext = appDelegate?.persistentContainer.viewContext else { return }
        managedContext.delete(goals[indexPath.row])
        
        do{
            try managedContext.save()
            print("succuffuly deleted")
        }catch {
            debugPrint("Could not delete : \(error.localizedDescription)")
        }
    }

    func fetch (completion : (_ complete : Bool) -> ()){
        guard let managedContext = appDelegate?.persistentContainer.viewContext else { return }
        let fetchRequest = NSFetchRequest<Goal>(entityName: "Goal")
        do{
          goals =  try managedContext.fetch(fetchRequest)
          completion(true)
        }catch{
            debugPrint(error.localizedDescription)
            completion(false)
        }
    }
}


