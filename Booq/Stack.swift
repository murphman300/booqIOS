//
//  Stack.swift
//  Booq
//
//  Created by Jean-Louis Murphy on 2017-08-08.
//  Copyright © 2017 Jean-Louis Murphy. All rights reserved.
//

import UIKit


protocol Stackable {
    var next: Stackable? { get set }
}

class Stack<T: Stackable> {
    
    private var top : T?
    
    func push(_ value: T) {
        let old = top
        top = value
        top?.next = old
    }
    
    func pop() -> T? {
        let current = top
        top = top?.next as? T
        return current
    }
    
    func peek() -> T? {
        return top
    }
    
}

class InvertedStack<T: Stackable> {
    
    private var queue : [T] = []
    
    func push(_ value: T) {
        queue.insert(value, at: queue.count)
    }
    
    func pop() -> T? {
        if !queue.isEmpty {
            return queue.remove(at: 0)
        }
        return nil
    }
    
    func peek() -> T? {
        if !queue.isEmpty {
            return queue[0]
        }
        return nil
    }
    
}


class Executable : Stackable {
    
    var next: Stackable?
    
    init() {
        
    }
    
}


class ExecutableStack  {
    
    static let line  = ExecutableStack()
    
    var stack = InvertedStack<Executable>()
    
}



class Contrains: Stack<Executable> {
    
}
