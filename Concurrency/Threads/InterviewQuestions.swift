//
//  InterviewQuestions.swift
//  Concurrency
//
//  Created by 13401027 on 24/11/22.
//

import Foundation
import UIKit

/*
 Predict the output.
 
 Sync and Async
 Serial Vs Concurrent Queue.
 Serial VC Sync and Async vc Concurrent.
 
 Serial and concurrent affect the destination queue to which dispatch is being done. How will the execution take place their.
 
 Sync and Anync effects the current thread from which the dispacth is being done.
 
 
 Q1. How can you make an operation async?
 
 Tell about: States, when should we override start and cancel method.
 
 So the approach is:
 taht is isReady, isExecuting, isFinished etc.
 This tracking will be done using kvo.
 Using the state property overide the property of operation class and
 then override start and cancel method.
 and handle these properties in methods.
 
 Q2. Add dependency between tasks?
 
 In operaation queue this is oneliner.
 In GCD use barriers or semaphore.
 
 Q3. make a class Thread safe?
 Basically identify the critical section and handle it.
 
 Q4 are structs thread safe?
 structs are thread safe.
 
 Q5 . What else are thread safe?
 actors.
 
 ReadL
 Actors, Struct vc Class Vc Actors.
 
 */


class Predict {
    let queue = DispatchQueue(label: "printnumbers", attributes: .concurrent)
    var number: String = ""
    
    func execute() {
        for i in 50 ... 55 {
            number += "\(i) "
        }
        
        print(number)
        queue.async {
            var number: String = ""
            for i in 10 ... 15 {
                number += "\(i) "
            }
            print(number)
        }
        
        queue.async {
            var number: String = ""
            for i in 0 ... 5 {
                number += "\(i) "
            }
            print(number)
        }
        
        number = ""
        for i in 30 ... 35 {
            number += "\(i) "
        }
        
        print(number)
    }

}
