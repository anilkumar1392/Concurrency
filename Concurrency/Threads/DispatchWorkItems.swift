//
//  DispatchWorkItems.swift
//  Concurrency
//
//  Created by 13401027 on 24/11/22.
//

import Foundation

class DWItem {
    var queue: DispatchQueue = DispatchQueue(label: "com.queue")
    var item: DispatchWorkItem?
    var count: Int = 0
    
    func addItem() {
        count += 1
        item?.cancel()
        let workItem: DispatchWorkItem  = DispatchWorkItem(block: {
            GetData().data(data: self.count) { data in
                print("data received \(data)")
            }
        })
        
        item = workItem
        DispatchQueue.global().asyncAfter(deadline: .now() + 1, execute: workItem)
    }
    
    func addMoreItem() {
        addItem()
    }
}


class GetData {
    func data(data: Int, _ completion: @escaping (Int) -> Void) {
        DispatchQueue.global().asyncAfter(deadline: .now() + 1) {
            completion(data)
        }
    }
}
