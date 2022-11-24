//
//  CustomThreads.swift
//  Concurrency
//
//  Created by 13401027 on 23/11/22.
//

import Foundation

/*
 raw api no abstraction.
 Pros:
 Have all the controls.
 
Cons:
Responsibility to manage the threads with system conditions.
Deallocation once they have finished the execution.
Improper management may cause memory leaks.
Autorelease pool will not manage the threads created by us.
Maintaining the order of execution.
 
*/

class CustomThread {
    func createTread() {
        let thread: Thread = Thread(target: self, selector: #selector(threadSelector), object: nil)
        thread.start()
    }
    
    @objc func threadSelector() {
        print("Custom thread in action")
    }
}
