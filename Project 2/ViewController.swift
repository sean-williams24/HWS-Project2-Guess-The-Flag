//
//  ViewController.swift
//  Project 2
//
//  Created by Sean Williams on 24/06/2019.
//  Copyright © 2019 Sean Williams. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UNUserNotificationCenterDelegate {

    @IBOutlet var button1: UIButton!
    @IBOutlet var button2: UIButton!
    @IBOutlet var button3: UIButton!
    
    var countries = [String]()
    var correctAnswer = 0
    var score = 0
    var totalQuestions = 0
    var highestScore = Int()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .badge, .sound]) { (granted, error) in
            if granted {
                print("Granted Permission")
            } else {
                print("Permission denied")
            }
        }
        
        scheduleLocal()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Score", style: .done, target: self, action: #selector(scoreCheck))
        
        button1.layer.borderWidth = 1
        button2.layer.borderWidth = 1
        button3.layer.borderWidth = 1
        
        button1.layer.borderColor = UIColor.lightGray.cgColor
        button2.layer.borderColor = UIColor.lightGray.cgColor
        button3.layer.borderColor = UIColor.lightGray.cgColor

        countries += ["estonia", "france", "germany", "ireland", "italy", "monaco", "nigeria", "poland", "russia", "spain", "uk", "us"]
        
        highestScore = UserDefaults.standard.integer(forKey: "highestScore")
        
        askQuestion()
        
        print(highestScore)
        
    }
    
    //MARK: - Notification Center Delegates and Mehtods
    
    
    func scheduleLocal() {
        let center =  UNUserNotificationCenter.current()
        center.removeAllPendingNotificationRequests()
        
        //Define some content
        let content = UNMutableNotificationContent()
        content.title = "Guess The Flag"
        content.body = "We miss you! Come and have a game of guess the flag?"
        content.categoryIdentifier = "dailyReminder"
        content.launchImageName = "uk"
        content.sound = UNNotificationSound.default
        
        var dateComponents = DateComponents()
        dateComponents.hour = 12
        dateComponents.minute = 35
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        center.add(request)
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        
        switch response.actionIdentifier {
        case UNNotificationDefaultActionIdentifier:
            // the user swiped to unlock
            print("Default identifier")
        default:
            break
        }
    }
    

    
    
    //MARK: - Action & Private Methods
    
    func askQuestion(action: UIAlertAction! = nil) {
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
        
        button1.setImage(UIImage(named: countries[0]), for: .normal)
        button2.setImage(UIImage(named: countries[1]), for: .normal)
        button3.setImage(UIImage(named: countries[2]), for: .normal)
        
        title = "\(countries[correctAnswer].uppercased())"

    }
    
    @IBAction func buttonTapped(_ sender: UIButton) {
        
        var title: String
        
        UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 5, options: [], animations: {
            sender.transform = CGAffineTransform(scaleX: 0.6, y: 0.6)
            sender.transform = .identity

        }) { (fin) in
        }
        
        if sender.tag == correctAnswer {
                title = "Correct \n☺️"
                score += 1
                totalQuestions += 1
        } else {
                title = "Wrong \n😭"
                totalQuestions += 1

        }
        
        if totalQuestions < 5 {
            let ac = UIAlertController(title: title, message: "That's the flag of \(countries[sender.tag].uppercased())!", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "Continue", style: .default, handler: askQuestion))
            present(ac, animated: true, completion: nil)
        } else {
            
            if score > highestScore {
                highestScore = score
                
                UserDefaults.standard.set(highestScore, forKey: "highestScore")
                print(highestScore)
                let finalAC = UIAlertController(title: "CONGRATULATIONS", message: "Highest score reached! Your final score is \(score) / \(totalQuestions)", preferredStyle: .alert)
                finalAC.addAction(UIAlertAction(title: "Play Again", style: .default, handler: resetGame))
                present(finalAC, animated: true, completion: nil)
                
            } else {
                let finalAC = UIAlertController(title: "Game Over", message: "Your final score is \(score) / \(totalQuestions)", preferredStyle: .alert)
                finalAC.addAction(UIAlertAction(title: "Play Again", style: .default, handler: resetGame))
                present(finalAC, animated: true, completion: nil)
            }
        }

    }
    
    func resetGame(action: UIAlertAction! = nil) {
        score = 0
        totalQuestions = 0
        askQuestion()
    }
    
    @objc func scoreCheck() {
        let vc = UIAlertController(title: "Score", message: "\(score) / \(totalQuestions)", preferredStyle: .alert)
        vc.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(vc, animated: true)
    }
}

