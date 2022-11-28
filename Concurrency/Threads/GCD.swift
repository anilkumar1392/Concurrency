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
 and then GCD is an api that takes care of that queue.
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
    
    // async will not block current execition and 11 ... 200 will get printed first then task submitted to main to 300 ... 400 will be exectuted and then 401...500
    func serial() {
        var counter = 1
        
        DispatchQueue.main.async {
            for i in 300...400 {
                counter = i
                print("\(counter)")
            }
        }
        
        for i in 11...200 {
            counter = i
            print("\(counter)")
        }
        
        DispatchQueue.main.async {
//            counter = 9
//            print("\(counter)")

            for i in 401...500 {
                counter = i
                print("\(counter)")
            }
        }
    }
    
    // In serial queue task submitted to queue will be executed serially. (next task will executred once first finishes)
    var serialQueue: DispatchQueue = DispatchQueue(label: "com.queue.serial")
    func serial1() {
        var counter = 1
        
        serialQueue.async {
            for i in 300...400 {
                counter = i
                print("\(counter)")
            }
        }

        serialQueue.async {
            for i in 411...500 {
                counter = i
                print("\(counter)")
            }
        }
        
        serialQueue.async {
            for i in 600...700 {
                counter = i
                print("\(counter)")
            }
        }
    }
    
    // Task submitted to serial queue will executed with out stoping the current execution so
    // 300...400 and 11...200 will run concurrently while
    // next async will will be picked while first finishes.
    
    func serial2() {
        var counter = 1
        
        serialQueue.async {
            for i in 300...400 {
                counter = i
                print("\(counter)")
            }
        }
        
        for i in 11...200 {
            counter = i
            print("\(counter)")
        }
        
        serialQueue.async {
            for i in 411...500 {
                counter = i
                print("\(counter)")
            }
        }
    }

    // Sync waits for any other task to finish running on any other thread.
    func serial3() {
        var counter = 1
        
        serialQueue.sync {
            for i in 30...40 {
                counter = i
                print("\(counter)")
            }
        }
        
        for i in 50...20000 {
            counter = i
            print("\(counter)")
        }

        serialQueue.sync {
            for i in 3001...3050 {
                counter = i
                print("\(counter)")
            }
        }
        
        // If we use main here that will block the current exection as main thread has highest priority app will crash.
        
//        DispatchQueue.main.sync {
//            for i in 3001...3050 {
//                counter = i
//                print("\(counter)")
//            }
//        }
        
        DispatchQueue.main.async {
            for i in 3001...3050 {
                counter = i
                print("\(counter)")
            }
        }
    }
    
    // 30 ...40 will print first then 50 ... 60
    func serial4() {
        var counter = 1

        serialQueue.sync {
            for i in 30...40 {
                counter = i
                print("\(counter)")
            }
            
            serialQueue.async {
                for i in 50...60 {
                    counter = i
                    print("\(counter)")
                }
            }
        }
    }
    
    // app will crash as inner sync will stop current exectution and start it's task so app will crash
    func serial5() {
        var counter = 1

        serialQueue.sync {
            for i in 30...40 {
                counter = i
                print("\(counter)")
            }
            
            serialQueue.sync {
                for i in 50...60 {
                    counter = i
                    print("\(counter)")
                }
            }
        }
    }
    
    // App will crash as sync will stop current execution
    func serial6() {
        var counter = 1

        serialQueue.async {
            for i in 30...40 {
                counter = i
                print("\(counter)")
            }
            
            self.serialQueue.sync {
                for i in 50...60 {
                    counter = i
                    print("\(counter)")
                }
            }
        }
    }
    
    // 30...40 first submitted task then 50...60  another submitted task
    func serial7() {
        var counter = 1

        serialQueue.async {
            for i in 30...40 {
                counter = i
                print("\(counter)")
            }
            
            self.serialQueue.async {
                for i in 50...60 {
                    counter = i
                    print("\(counter)")
                }
            }
        }
    }
    
    // Concurrent and Async can not predict the behaviour
    func concurrent1() {
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
    
    // firts 8...300 then 4...600  then 7...12
    func concurrent2() {
        var counter = 1
        
        DispatchQueue.global().async {
            for i in 8...300 {
                counter = i
                print("\(counter)")
            }
        }
        
        for _ in 4...600 {
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
