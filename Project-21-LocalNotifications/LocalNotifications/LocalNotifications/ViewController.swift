//
//  ViewController.swift
//  LocalNotifications
//
//  Created by Matt X on 12/27/22.
//

import UIKit
import UserNotifications

class ViewController: UIViewController, UNUserNotificationCenterDelegate {
    let center = UNUserNotificationCenter.current()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let registerLocalButton = UIBarButtonItem(
            title: "Register",
            style: .plain,
            target: self,
            action: #selector(registerLocal)
        )
        
        let scheduleLocalButton = UIBarButtonItem(
            title: "Schedule",
            style: .plain,
            target: self,
            action: #selector(scheduleLocal)
        )
        
        navigationItem.leftBarButtonItem = registerLocalButton
        navigationItem.rightBarButtonItem = scheduleLocalButton
    }
    
    @objc func registerLocal() {
        center.requestAuthorization(options: [.alert, .badge, .sound]) { hasGranted, error in
            if hasGranted {
                print("Granted.")
            } else {
                print("D-oh!")
            }
        }
    }
    
    @objc func scheduleLocal() {
        registerCategories()
        
        center.removeAllPendingNotificationRequests()
        
        let content = UNMutableNotificationContent()
        content.title = "Late wake up call"
        content.body = "The early bird catches the worm, but the second mouse gets the cheese."
        content.categoryIdentifier = "alarm"
        content.userInfo = ["customData": "fizzbuzz"]
        content.sound = .default
        
        // let dateComponents = DateComponents(hour: 10, minute: 30) // Triggers at 10:30 am...
        // let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
        
        let request = UNNotificationRequest(
            identifier: UUID().uuidString,
            content: content,
            trigger: trigger
        )
        
        center.add(request)
    }
    
    func registerCategories() {
        center.delegate = self
        
        let show = UNNotificationAction(
            identifier: "show",
            title: "Tell me more...",
            options: .foreground
        )
        let category = UNNotificationCategory(identifier: "alarm", actions: [show], intentIdentifiers: [])
        
        center.setNotificationCategories([category])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = response.notification.request.content.userInfo
        
        if let customData = userInfo["customData"] as? String {
            print("Custom data received: \(customData)")
            
            switch response.actionIdentifier {
            case UNNotificationDefaultActionIdentifier:
                // The user swiped to unlock...
                print("Default identifier.")
            case "show":
                print("Show more information...")
            default:
                break
            }
        }
        
        completionHandler()
    }
}
