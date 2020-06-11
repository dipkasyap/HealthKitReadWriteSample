//
//  DataStore.swift
//  HealthDataReadWrite
//
//  Created by Admin on 11/6/20.
//  Copyright © 2020 Admin. All rights reserved.
//

import Foundation


import HealthKit

class DataStore {
    
    class func get(completion: @escaping (String?) -> ()) {
        let startDateSort = NSSortDescriptor(key: HKSampleSortIdentifierStartDate, ascending: true)
        let query = HKSampleQuery(sampleType: HKObjectType.workoutType(), predicate: nil,
                                  limit: 10,
                                  sortDescriptors: [startDateSort]) { (sampleQuery, results, error) -> Void in
                                    
                                    if let results = results, results.count > 0 {
                                        completion(results.first?.description)
                                    } else {
                                        completion(error.debugDescription)
                                    }
                                    
                                    print("data from health kit", results?.first?.description)
                                    
        }
        
        HKHealthStore().execute(query)
        
    }
    
    class func save(completion: @escaping ((Bool, Error?) -> ())) {
        
        let end = Date()
        let start = Date().addingTimeInterval(-20)
        
        let energyBurned = HKQuantity(unit: HKUnit.kilocalorie(),
                                      doubleValue: 425.0)
        
        let distance = HKQuantity(unit: HKUnit.mile(),
                                  doubleValue: 0)
        
        let status = "felt okay...could have done more"
        let push_ups = 40
        let sit_ups = 50
        
        let s = ["push_ups": push_ups,
                 "sit_ups": sit_ups,
                 "notes": status
            ] as NSDictionary
        
        // Provide summary information when creating the workout.
        let wrkOut = HKWorkout(activityType: HKWorkoutActivityType.functionalStrengthTraining,
                               start: start, end: end, duration: 0,
                               totalEnergyBurned: energyBurned, totalDistance: distance, metadata: s as! [String : Any])
        
        //3.  Save the same to HealthKit
        HKHealthStore().save(wrkOut) { (success, error) in
            
            completion(success, error)
            
        }
        
        
    }
}
