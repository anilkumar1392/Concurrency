//
//  DispatchFlags.swift
//  Concurrency
//
//  Created by 13401027 on 24/11/22.
//

import Foundation

/*
 DispatchWorkItemFlags:
 
 Flags are the attributes through which we define the behaviour of our Dispatch Work item.
 Set of behaviour for work item.
 
 It's quality of service class, Whether to create a barrier or spawn a new detached thread.
 
 we have six flags:
 
 public static let barrier: DispatchWorkItemFlags
 
 where you want to add the barrier or control the access.
 - No other task should be executed at that time when this task is being executed.

 @available(macOS 10.10, iOS 8.0, *)
 public static let detached: DispatchWorkItemFlags
 
 Disassociate the work item's attributes from the current execution context.

 @available(macOS 10.10, iOS 8.0, *)
 public static let assignCurrentContext: DispatchWorkItemFlags
 
 Set the attributes of the work item to match the attributes of the current execution context.

 @available(macOS 10.10, iOS 8.0, *)
 public static let noQoS: DispatchWorkItemFlags

 @available(macOS 10.10, iOS 8.0, *)
 public static let inheritQoS: DispatchWorkItemFlags
 
 Prefer the quality-of-service class associated with the current execution context.

 @available(macOS 10.10, iOS 8.0, *)
 public static let enforceQoS: DispatchWorkItemFlags
 
 Prefer the quality-of-service class associated with the block.
  
 */


/*
 Dispatch Semaphore is solution to race conditions.
 Access to critical section.
 
 Joint account example.
 
 In case of barrier we were areating a barier but in semaphonr we can control it.
 if we want n no of threads to access at a time.
 
 wait(), Signal()
 */

class DFlags {
    let purchaseQueue: DispatchQueue = DispatchQueue(label: "com.concurrent.queue", attributes: .concurrent)
    var totalBalance: Int = 30
    var count: Int = 0
    let semaphore: DispatchSemaphore = DispatchSemaphore(value: 1)
    
    func shop() {
        /*
        DispatchQueue.main.async(group: <#T##DispatchGroup?#>, qos: <#T##DispatchQoS#>, flags: .barrier, execute: <#T##() -> Void#>)
         */
        
        for _ in 0..<2 {
//            purchaseQueue.async(flags: .barrier) {
//                self.doPurchase()
//            }
            
            purchaseQueue.async {
                self.doPurchase()
            }
        }
    }
    
    private func doPurchase(with amount: Int = 20) {
        semaphore.wait()
        self.count += 1
        if totalBalance > amount { // no balance
            MakePurchase().buy(data: count) { data in
                DispatchQueue.main.async {
                    self.totalBalance -= 20
                    print("Purchase made remaining balance \(data): \(self.totalBalance)")
                    self.semaphore.signal()
                }
            }
        } else {
            print("no sufficient balacnce")
            self.semaphore.signal()
        }
    }
}

class MakePurchase {
    func buy(data: Int, _ completion: @escaping (Int) -> Void) {
        DispatchQueue.global().asyncAfter(deadline: .now() + 5) {
            completion(data)
        }
    }
}
