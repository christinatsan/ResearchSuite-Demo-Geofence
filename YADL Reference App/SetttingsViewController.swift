////
////  SettingsViewController.swift
////  YADL-Reference-App
////
////  Created by Christina Tsangouri on 11/7/17.
////  Copyright © 2017 Christina Tsangouri. All rights reserved.
////
//
//import UIKit
//import ResearchKit
//import ResearchSuiteTaskBuilder
//import Gloss
//import ResearchSuiteAppFramework
//import UserNotifications
//import MessageUI
//import ResearchSuiteResultsProcessor
//import sdlrkx
//
//
//class SettingsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, MFMailComposeViewControllerDelegate  {
//
//    @IBOutlet weak var backButton: UIBarButtonItem!
//
//    @IBOutlet
//    var tableView: UITableView!
//
//    var store: RSStore!
//
//    var items: [String] = ["Take Full Assessment", "Take Spot Assessment","Take PAM Assessment","Take Demographics Survey","Set Notification Time", "Go No Go", "Sign Out"]
//    var fullAssessmentItem: RSAFScheduleItem!
//    var spotAssessmentItem: RSAFScheduleItem!
//    var notificationItem: RSAFScheduleItem!
//    var pamAssessmentItem: RSAFScheduleItem!
//    var demographicsAssessmentItem: RSAFScheduleItem!
//    let delegate = UIApplication.shared.delegate as! AppDelegate
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
//        tableView.delegate = self
//        tableView.dataSource = self
//
//        self.store = RSStore()
//
//        // Do any additional setup after loading the view.
//    }
//
//    override func didReceiveMemoryWarning() {
//        super.didReceiveMemoryWarning()
//        // Dispose of any resources that can be recreated.
//    }
//
//    @IBAction func backAction(_ sender: Any) {
//        self.dismiss(animated: true, completion: nil)
//
//    }
//
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return self.items.count
//
//    }
//
//    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
//        let deselectedCell = tableView.cellForRow(at: indexPath)!
//        deselectedCell.backgroundColor = UIColor.clear
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell:UITableViewCell = self.tableView.dequeueReusableCell(withIdentifier: "cell")!
//
//        let notificationHour = self.store.valueInState(forKey: "notificationHour") as! String
//        let notificationMinutes = self.store.valueInState(forKey: "notificationMinutes") as! String
//
//        var convertedTime:[String]! = []
//
//        convertedTime = self.hourConversion(hour: notificationHour,minute: notificationMinutes)
//
//        let notificationString = self.items[4] + ":      " + convertedTime[0] + ":" + convertedTime[2] + " " + convertedTime[1]
//
//
//        if(indexPath.row == 4) {
//            cell.textLabel?.text = notificationString
//        }
//        else {
//
//            cell.textLabel?.text = self.items[indexPath.row]
//        }
//
//       // cell.textLabel?.textColor = UIColor.init(colorLiteralRed: 0, green: 0, blue: 0, alpha: 1.0)
//
//
//        return cell
//    }
//
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//
//        return 60.0
//
//    }
//
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//
//        tableView.deselectRow(at: indexPath, animated: true)
//
//
//        if indexPath.row == 0 {
//            self.launchFullAssessment()
//        }
//
//        if indexPath.row == 1 {
//            self.launchSpotAssessment()
//        }
//
//        if indexPath.row == 2 {
//            self.launchPamAssessment()
//        }
//
//        if indexPath.row == 3 {
//            self.launchDemographicsSurvey()
//        }
//
//        if indexPath.row == 4 {
//            self.setNotification()
//        }
//
//        if indexPath.row == 5 {
//            self.launchGoNoGo()
//        }
//
//
//        if indexPath.row == 6 {
//            self.signOut()
//        }
//
//
//    }
//
//    func launchFullAssessment() {
//        self.fullAssessmentItem = AppDelegate.loadScheduleItem(filename: "yadl_full.json")
//        self.launchActivity(forItem: fullAssessmentItem)
//    }
//
//    func launchSpotAssessment() {
//        self.spotAssessmentItem = AppDelegate.loadScheduleItem(filename: "yadl_spot.json")
//        self.launchActivity(forItem: spotAssessmentItem)
//    }
//
//    func setNotification() {
//        self.notificationItem = AppDelegate.loadScheduleItem(filename: "notification.json")
//        self.launchActivity(forItem: notificationItem)
//    }
//
//    func launchPamAssessment() {
//        self.pamAssessmentItem = AppDelegate.loadScheduleItem(filename: "pam.json")
//        self.launchActivity(forItem: pamAssessmentItem)
//    }
//
//    func launchDemographicsSurvey() {
//        self.demographicsAssessmentItem = AppDelegate.loadScheduleItem(filename: "demographics.json")
//        self.launchActivity(forItem: demographicsAssessmentItem)
//    }
//
//    func launchGoNoGo() {
//        guard let item = AppDelegate.loadScheduleItem(filename: "go_no_go_sample.json") else {
//            return
//        }
//
//        self.launchActivity(forItem: item)
//    }
//
//
//
//    func signOut() {
//        let appDelegate = UIApplication.shared.delegate as? AppDelegate
//        appDelegate?.signOut()
//    }
//
//    func launchActivity(forItem item: RSAFScheduleItem) {
//
//
//        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate,
//            let steps = appDelegate.taskBuilder.steps(forElement: item.activity as JsonElement) else {
//                return
//        }
//
//        let task = ORKOrderedTask(identifier: item.identifier, steps: steps)
//
//        let taskFinishedHandler: ((ORKTaskViewController, ORKTaskViewControllerFinishReason, Error?) -> ()) = { [weak self] (taskViewController, reason, error) in
//            //when finised, if task was successful (e.g., wasn't canceled)
//            //process results
//            if reason == ORKTaskViewControllerFinishReason.completed {
//                let taskResult = taskViewController.result
//                appDelegate.resultsProcessor.processResult(taskResult: taskResult, resultTransforms: item.resultTransforms)
//
//                if(item.identifier == "notification_date"){
//
//                    let result = taskResult.stepResult(forStepIdentifier: "notification_time_picker")
//                    let timeAnswer = result?.firstResult as? ORKTimeOfDayQuestionResult
//
//                    let resultAnswer = timeAnswer?.dateComponentsAnswer
//                    self?.setNotification(resultAnswer: resultAnswer!)
//                    DispatchQueue.main.async{
//                        self?.tableView.reloadData()
//                    }
//
//                }
//
//                if(item.identifier == "yadl_spot"){
//                    self?.store.setValueInState(value: true as NSSecureCoding, forKey: "spotFileExists")
//                }
//
//                if(item.identifier == "yadl_full"){
//
//                    // save date that full assessment was completed
//
//                    let date = Date()
//
//                    self?.store.setValueInState(value: date as NSSecureCoding, forKey: "dateFull")
//
//                    // save that a full file exists
//
//                    self?.store.setValueInState(value: true as NSSecureCoding, forKey: "fullFileExists")
//
//                    // save for spot assessment
//
//                    if let difficultActivities: [String]? = taskResult.results?.flatMap({ (stepResult) in
//                        if let stepResult = stepResult as? ORKStepResult,
//                            stepResult.identifier.hasPrefix("yadl_full."),
//                            let choiceResult = stepResult.firstResult as? ORKChoiceQuestionResult,
//                            let answer = choiceResult.choiceAnswers?.first as? String,
//                            answer == "hard" || answer == "moderate"
//                        {
//                            var tempResult = stepResult.identifier
//                            let index = tempResult.index(tempResult.startIndex, offsetBy: 10)
//                            tempResult = tempResult.substring(from:index)
//
//
//                            NSLog(tempResult)
//
//                            return tempResult.replacingOccurrences(of: "yadl_full.", with: "")
//
//                        }
//                        return nil
//                    }) {
//                        if let answers = difficultActivities {
//
//
//                            self?.store.setValueInState(value: answers as NSSecureCoding, forKey: "activity_identifiers")
//
//
//                        }
//                    }
//
//
//
//                }
//
//            }
//
//            self?.dismiss(animated: true, completion: nil)
//
//
//
//
//        }
//
//        let tvc = RSAFTaskViewController(
//            activityUUID: UUID(),
//            task: task,
//            taskFinishedHandler: taskFinishedHandler
//        )
//
//        self.present(tvc, animated: true, completion: nil)
//
//    }
//
//    func hourConversion (hour: String, minute: String) -> [String] {
//
//        var newHour: String!
//        var newMinute: String!
//        var am_pm: String!
//
//        var minuteInt: Int = Int(minute)!
//        if minuteInt < 10 {
//            newMinute = "0" + minute
//        }
//        else {
//            newMinute = minute
//        }
//
//        switch hour{
//        case "00":
//            newHour = "12"
//            am_pm = "am"
//        case "12":
//            newHour = "12"
//            am_pm = "pm"
//        case "13":
//            newHour = "1"
//            am_pm = "pm"
//        case "14":
//            newHour = "2"
//            am_pm = "pm"
//        case "15":
//            newHour = "3"
//            am_pm = "pm"
//        case "16":
//            newHour = "4"
//            am_pm = "pm"
//        case "17":
//            newHour = "5"
//            am_pm = "pm"
//        case "18":
//            newHour = "6"
//            am_pm = "pm"
//        case "19":
//            newHour = "7"
//            am_pm = "pm"
//        case "20":
//            newHour = "8"
//            am_pm = "pm"
//        case "21":
//            newHour = "9"
//            am_pm = "pm"
//        case "22":
//            newHour = "10"
//            am_pm = "pm"
//        case "23":
//            newHour = "11"
//            am_pm = "pm"
//        default:
//            newHour = hour
//            am_pm = "am"
//        }
//
//
//        return [newHour,am_pm,newMinute]
//
//    }
//
//    func setNotification(resultAnswer: DateComponents) {
//
//        var userCalendar = Calendar.current
//        userCalendar.timeZone = TimeZone(abbreviation: "EDT")!
//
//        var fireDate = NSDateComponents()
//
//        let hour = resultAnswer.hour
//        let minutes = resultAnswer.minute
//
//        fireDate.hour = hour!
//        fireDate.minute = minutes!
//
//        delegate.store.setValueInState(value: String(describing:hour!) as NSSecureCoding, forKey: "notificationHour")
//        delegate.store.setValueInState(value: String(describing:minutes!) as NSSecureCoding, forKey: "notificationMinutes")
//
//
//        if #available(iOS 10.0, *) {
//            let content = UNMutableNotificationContent()
//            content.title = "ResearchSuite"
//            content.body = "It'm time to complete your ResearchSuite Spot Assessments"
//            content.sound = UNNotificationSound.default()
//
//            let trigger = UNCalendarNotificationTrigger(dateMatching: fireDate as DateComponents,
//                                                        repeats: true)
//
//            let identifier = "UYLLocalNotification"
//            let request = UNNotificationRequest(identifier: identifier,
//                                                content: content, trigger: trigger)
//
//            let appDelegate = UIApplication.shared.delegate as? AppDelegate
//            appDelegate?.center.add(request, withCompletionHandler: { (error) in
//                if let error = error {
//                    // Something went wrong
//                }
//            })
//
//        } else {
//            // Fallback on earlier versions
//
//            let dateToday = Date()
//            let day = userCalendar.component(.day, from: dateToday)
//            let month = userCalendar.component(.month, from: dateToday)
//            let year = userCalendar.component(.year, from: dateToday)
//
//            fireDate.day = day
//            fireDate.month = month
//            fireDate.year = year
//
//            let fireDateLocal = userCalendar.date(from:fireDate as DateComponents)
//
//            let localNotification = UILocalNotification()
//            localNotification.fireDate = fireDateLocal
//            localNotification.alertTitle = "ResearchSuite"
//            localNotification.alertBody = "It's time to complete your ResearchSuite Spot Assessments"
//            localNotification.timeZone = TimeZone(abbreviation: "EDT")!
//            //set the notification
//            UIApplication.shared.scheduleLocalNotification(localNotification)
//        }
//
//
//    }
//
//
//
//
//
//}

