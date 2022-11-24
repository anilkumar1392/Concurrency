//
//  ViewController.swift
//  Concurrency
//
//  Created by 13401027 on 23/11/22.
//

import UIKit

class ViewController: UIViewController {
    let serialQueue = DispatchQueue(label: "com.queue.serial")
    let concurrentQueue = DispatchQueue(label: "com.queue.concurrent", attributes: .concurrent)

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        // testCustomThread()
        
        // serial1()
        // customQueues()
        
        // doAsyncTaskInSerialQueue()
        // doSyncTaskInSerialQueue()
        
        // doAsyncTaskInConcurrentQueue()
        // doSyncTaskInConcurrentQueue()
        
        // testDispatchGroup()
        // testWorkItem()
        
        testbarrierFlags()
    }

    func testCustomThread() {
//        let thread = CustomThread()
//        thread.createTread()
        
        let serial = GCD()
        // serial.serial()
        serial.concurrent()

    }
    
    func concurrentQueue12() {
        DispatchQueue.main.async {
            if Thread.isMainThread {
                print("In side main thread")
            } else {
                print("Execution on some other thread")
            }
        }
        
        DispatchQueue.global().async {
            if Thread.isMainThread {
                print("In side main thread")
            } else {
                print("Execution on Gloabl concurrent Queue")
            }
        }
    }
    
    func concurrentQueue1() {
        DispatchQueue.main.async {
            if Thread.isMainThread {
                print("In side main thread")
            } else {
                print("Execution on some other thread")
            }
        }
        
        DispatchQueue.main.sync {
            if Thread.isMainThread {
                print("In side main thread")
            } else {
                print("Execution on Gloabl concurrent Queue")
            }
        }
    }
    
    func serial1() {
        let queue = DispatchQueue(label: "test1", attributes: .concurrent)
        print("1")

        queue.async {
            for i in 2...10 {
                print("2")
            }
        }
        print("1")
        queue.async {
            for i in 11...20 {
                print("3")
            }
        }

        queue.async {
            print("4")
        }
        
        // This is on some concurrent thread its behaviour will be unpredicted.
//        for _ in 11...20 {
//            print("5")
//        }

        queue.async {
            queue.sync {
                print("6")
            }
            print("7")
        }
    }

}

// MARK: - Priority

extension UIViewController {
    func testPriority() {
        DispatchQueue.global(qos: .background).async {
            for i in 11...20 {
                print(i)
            }
        }
        
        DispatchQueue.global(qos: .userInteractive).async {
            for i in 0...10 {
                print(i)
            }
        }
    }
}

// MARK: - Target queue

extension UIViewController {
    func customQueues() {
        /*
         Label : name of the queues, can be used later later to identify.
         Target Queue: A Queue that your custom queue will use behind the scene.
         So system has fiexd no of queues and no matter wheater you are using global queue or custom queue systme will use these fixed queue to execute your task.
         */
        
        // When we specify the target queue then the behaviour of target queue is inherited.
        
        let customTargetQueues: DispatchQueue = DispatchQueue(
            label: "com.concurreny.target")
        
        let customQueues: DispatchQueue = DispatchQueue(
            label: "com.concurreny",
            attributes: .concurrent,
            target: customTargetQueues)
        
        customTargetQueues.async {
            for i in 0...5 {
                print(i)
            }
        }
        
        customTargetQueues.async {
            for i in 6...10 {
                print(i)
            }
        }
        
        customQueues.async {
            for i in 11...15 {
                print(i)
            }
        }
        
        customQueues.async {
            for i in 16...20 {
                print(i)
            }
        }
    }
}

// MARK: Serial async
extension ViewController {
    func doAsyncTaskInSerialQueue() {
        for i in 1...3 {
            serialQueue.async {
                if Thread.isMainThread {
                    print("task running in main thread.")
                } else {
                    print("task running in other thread.")
                }
                
                print("\(i) Finshed loading")
            }
        }
        
        serialQueue.async {
            for i in 0...3 {
                print("\(i) *****")
            }
        }
        
        print("Last line in the method")
    }
    
}

// MARK: Serial sync

extension ViewController {
    /*
     When we synchronously dispatch some piece of work to Dispatch Queue and if that dispatch try to block the main thread.
     So what ever execution that was happening on main thread if that is not continued because of that sync block.
     Then systme may or may not use the main thread.
     
     So as main thread is idle so system thinks to use the main thread instead.
     // It may or may not use main thread.
     */
    
    func doSyncTaskInSerialQueue() {
        for i in 1...3 {
            serialQueue.sync {
                if Thread.isMainThread {
                    print("task running in main thread.")
                } else {
                    print("task running in other thread.")
                }
                
                print("\(i) Finshed loading")
            }
        }
        
        serialQueue.async {
            for i in 0...3 {
                print("\(i) *****")
            }
        }
        
        print("Last line in the method")
    }
    
}


// MARK: Concurrent async

extension ViewController {
    /*
     Concurrent and async
     */
    func doAsyncTaskInConcurrentQueue() {
        for i in 1...3 {
            concurrentQueue.async {
                if Thread.isMainThread {
                    print("task running in main thread.")
                } else {
                    print("task running in other thread.")
                }
                
                print("\(i) Finshed loading")
            }
        }
        
        concurrentQueue.async {
            for i in 0...3 {
                print("\(i) *****")
            }
        }
        
        print("Last line in the method")
    }
    
}


// MARK: Concurrent sync

extension ViewController {
    /*
     Concurrent and async
     */
    func doSyncTaskInConcurrentQueue() {
        for i in 1...3 {
            concurrentQueue.sync {
                if Thread.isMainThread {
                    print("task running in main thread.")
                } else {
                    print("task running in other thread.")
                }
                
                print("\(i) Finshed loading")
            }
        }
        
        concurrentQueue.async {
            for i in 0...3 {
                print("\(i) *****")
            }
        }
        
        print("Last line in the method")
    }
    
}

// MARK: - Dispatch Queue

extension ViewController {
    func testDispatchGroup() {
        let group = DG()
        group.perform()
    }
    
    // Perform cancel with workitem.
    func testWorkItem() {
        let obj = DWItem()
        obj.addItem()
        obj.addMoreItem()
    }
    
    func testbarrierFlags() {
        let flags = DFlags()
        flags.shop()
        // flags.shop()

    }
}
