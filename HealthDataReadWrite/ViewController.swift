//
//  ViewController.swift
//  HealthDataReadWrite
//
//  Created by Admin on 11/6/20.
//  Copyright © 2020 Admin. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        
        HealthKitSetupAssistant.authorizeHealthKit { (authorized, error) in
            guard authorized else {
                
                let baseMessage = "HealthKit Authorization Failed"
                
                if let error = error {
                    print("\(baseMessage). Reason: \(error.localizedDescription)")
                } else {
                    print(baseMessage)
                }
                
                return
            }
        }
    }
    
    @IBAction func save() {
        
        DataStore.save { [unowned self] (success, error) in
            if let error = error {
                print("Error Saving BMI Sample: \(error.localizedDescription)")
                self.displayAlert(error.localizedDescription)
                
            } else {
                self.displayAlert("Successfully saved Sample")
            }
        }
    }
    
    @IBAction func get() {
        DataStore.get { (msg) in
            self.displayAlert("result is =>\n \(msg ?? "na")")
        }
        
    }
    
    
    private func displayAlert(_ msg: String) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: nil,
                                          message: msg,
                                          preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok",
                                          style: .default,
                                          handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
}

