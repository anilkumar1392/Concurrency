//
//  Operations.swift
//  Concurrency
//
//  Created by 13401027 on 24/11/22.
//

import Foundation

/*
 
 Operations and operation queue
 
 GCD And Operation queue ?
 operations are somthing that are build on top of GCD.
 they internally use GCD so how we can comapre this two api's.
 
 1. GCD is prefered where task is not complex and we are interested in state of execution.
 it is kind of fire and forget.
 basically less control and less functionality in terms of controlling the task.
 
 2. Operations sould be used where we are more interested in state of execution.
 we want more functionlity for controlling the task.
 we want to introduce dependency b/w the task.
 we want to encapsulate a block of functionlaity which can be reused.

 /*
  Apple prefers we should use highest level of abstraction possible.
  So operations are build on top of GCD we should use operations (contradtitory but no).
  
  Creating opeartion for trivial task is an overkill
  every time use use an operation it's instacne is allocated on completion it is deallocated.
  */
 */


/*
 Operations is an abstract class that represents the code and data associated with a single task.
 
 // Swift does not support abstract types.
 and we can not directly use abstract class they need implementation in the form of Subclasses.
 
 so for this we have two subclasses ready to use.
 1. Block Operation (Executes a block)
 2. NSInvocation Operation (Invoke a method defined by target)
 
 NSInvocation is not available in swift it is only for Objc.
 
 we can creat our own custom Operations.
 
 The way we submit a closure to a DispatchQueue In the exactly same way we can submit an operation to an operation Queue.
 The diff here is an operation is a class and class can have properties which can be used to maintaining the states holding values etc.
 
 Operations are synchronous by default.
 
 Block operations are synchronous by default // , run concurrently.
 So you can submit diff closures as block operations.
 and they will be executed concurrenlty on a gloabl queue.
 
 States in operation:
 isREady, isExecuting, isCanceleld, isFinished.
 
 one instacne can only be used once.
  
 */

class Operations {
    
     // Operations are sync by default.
    func testOperations() {
        print("about to start")
        let operation : BlockOperation = BlockOperation {
            print("First test")
            sleep(3)
        }
        operation.start()
        print("operation finished")
    }
    
    func testMultipleBlocks() {
        // Block operations are executed in synchronous manner
        // Multiple blocks executed, blocks executed concurrenlty.
        
        let operation: BlockOperation = BlockOperation()
        operation.completionBlock = {
            print("Execution completed completion on completion")
        }
        operation.addExecutionBlock {
            print("First block executed")
        }
        
        operation.addExecutionBlock {
            print("Second block executed")
        }
        
        operation.addExecutionBlock {
            print("third block executed")
        }
        
        // operation.start()
        DispatchQueue.global().async {
            operation.start() // we are taking it off the main  thread but still nature of execution is synchronous
            print("Did this run on main thread \(Thread.isMainThread )")
        }
    }
    
    func testOperationQueue() {
        let operationQueue: OperationQueue = OperationQueue()
        // operationQueue.maxConcurrentOperationCount = 1
        
        let operation1: BlockOperation = BlockOperation()
        operation1.addExecutionBlock {
            // print("Operation 1 being executed")
            for i in 0 ... 10 {
                print(i)
            }
        }
        
        operation1.completionBlock = {
            print("Operation 1 executed")
        }
        
        let operation2: BlockOperation = BlockOperation()
        operation2.addExecutionBlock {
            for i in 11 ... 20 {
                 print(i)
             }
            // print("Operation 2 being executed")
        }
        
        operation2.completionBlock = {
            print("Operation 2 executed")
        }
        
        operation2.addDependency(operation1) // Operation 2 should wait till operation 1 is completed.
        operationQueue.addOperation(operation1)
        operationQueue.addOperation(operation2)

        // Both the operation are executed concurrently
        
        // can we make them serial yes using maxoperationConcurrentCount
    }
    
    func dependencyWithAsync() {
        let operationQueue: OperationQueue = OperationQueue()
        
        let operation1: BlockOperation = BlockOperation(block: printOneToTen)
        let operation2: BlockOperation = BlockOperation(block: printTenToTwenty)
        
        operation2.addDependency(operation1)
        operationQueue.addOperation(operation1)
        operationQueue.addOperation(operation2)
        print("Custom operation executed")
        
        /*
         We have added dependey but it did not work why ?
         
         Because for async jobs the operation is assumed to be completed as soon as block finishes it's execution.
         In the mean while if you have executed something asynchronously, if you have created some other thread or may be you have aded some job to some other queue.
         It would not be consided and this block of code that this is doen executing and hance this dependency will be resolved.
         and operation 2 will begin exection.
         
         So to solve this problem we can use states we learned. isStart, isExecuting etc.
         
         so by managing the state we of the executing operation using the custom implementation.
         */
    }
    
    func printOneToTen() {
        DispatchQueue.global().async {
            for i in 0...10 {
                print(i)
            }
        }
    }
    
    func printTenToTwenty() {
        DispatchQueue.global().async {
            for i in 10 ... 20 {
                print(i)
            }
        }
    }
}

class CustomOperation: Operation {
    override func main() {
        for i in 0...10 {
            print(i)
        }
    }
}


