//
//  GCD.swift
//  Concurrency
//
//  Created by 13401027 on 23/11/22.
//

import Foundation

/*
 Dispatch is a framework that execute code concurrently on multicore hardware by submitting work to dispatchQueues managed by the system.
 
 GCD is a queue based api that allows to execute closures on workers pools In the First In first out order.
 
 we can submit the tasks.
 Those tasks are submitted in a queue.
 and then GCD is an api that takes carre of that queue.
 and our submitted tasks are taken care in FIFO manner.
 
 Now execution is done in a workers pool.
 Their is a pool of threads which actually executes the task.
 
 GCD: Which thread is used to execute a task is handled by GCD and execute them on appropraite dispatch Queue.
 
 ***** Dispatch Queue?  *****
 
 It is an abstraction on the top of Queues.
 
 GCD manages a collection of Dispatch Queue.
 Which is usually refered to as queue.
 The work submitted to these Dispatch queues is executed on a pool of threads.
 Which thread is used to execute a task is handled by GCD and execute them on appropraite dispatch Queue.
 A Dispatch Queue executes tasks serially or concurrently but in FIFO mannar.
 
 ***** How work is sumbitted to dispatch Queue? ******
 
 We can sumbmit task in the form of Closures or blocks.
 and those submissions can be sync or async.
 
 
 ***** Diff between (Sync and Async) ans serial and concurrent Queue
 
 Sync and Async determine the manner of exection.
 (How job will be executed wheater it will block your current execution or keep on executing current taks and new task will execute async.)
 
 Serial and Concurrent determine the Order of execution.
 (Decides task will be picked serially or concurrently)

 */

class GCD {
    func serial() {
        var counter = 1
        
        DispatchQueue.main.async {
            for i in 0...3 {
                counter = i
                print("\(counter)")
            }
        }
        
        for i in 4...6 {
            counter = i
            print("\(counter)")
        }
        
        DispatchQueue.main.async {
            counter = 9
            print("\(counter)")
        }
    }
    
    func concurrent() {
        // Concurrent and Async can not predict the behaviour
        var counter = 1
        
        DispatchQueue.global().async {
            for i in 8...300 {
                counter = i
                print("\(counter)")
            }
        }
        
        for _ in 4...60 {
            print("No queue assigned")
        }
        
        DispatchQueue.global().async {
            for i in 7...12 {
                counter = i
                print("\(counter)")
            }
        }
    }
}
