//
//  DispatchGroup.swift
//  Concurrency
//
//  Created by 13401027 on 24/11/22.
//

import Foundation

/*
 Multiple task can be grouped together
 enter()
 notify()
 leave()
 wait()

 Wait: wait till execution is finished and do not proceed.
 
 It is necessry to balance the number of enter to number of leave other wise app will crash.
  */

class DG {
    var group: DispatchGroup = DispatchGroup()
    
    func perform() {
        group.enter()
        getData1().data {
            self.group.leave()
        }
        
        group.enter()
        getData2().data {
            self.group.leave()
        }
        
        // Once the wait is completed it will proceed
        /*
        group.wait()
        print("wait finished")
         */
        
        let timeoutResult: DispatchTimeoutResult = group.wait(timeout: .now() + .seconds(1))
        switch timeoutResult {
        case .success:
            print("APi call finished")
        case .timedOut:
            print("APi timedOut")
        }
        
//        group.notify(queue: .main) {
//            print("Data call finish.")
//        }
    }
    
}

class getData1 {
    func data(_ completion: @escaping () -> Void) {
        DispatchQueue.global().asyncAfter(deadline: .now() + 1) {
            completion()
        }
    }
}

class getData2 {
    func data(_ completion: @escaping () -> Void) {
        DispatchQueue.global().asyncAfter(deadline: .now() + 1) {
            completion()
        }
    }
}
