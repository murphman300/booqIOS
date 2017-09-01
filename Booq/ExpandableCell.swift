//
//  ExpandableCell.swift
//  Booq
//
//  Created by Jean-Louis Murphy on 2017-08-04.
//  Copyright © 2017 Jean-Louis Murphy. All rights reserved.
//

import UIKit

enum CellSizeState {
    case normal(CGSize?)
    case selected(CGSize?)
    init() {
        self = .normal(nil)
    }
}

extension CellSizeState : Equatable {
    
    static func !=(_ lhs: CellSizeState,_ rhs: CellSizeState) -> Bool {
        switch lhs {
        case .normal(let sl):
            switch rhs {
            case .normal(let rl):
                return sl != rl
            case .selected(_):
                return false
            }
        case .selected(let sl):
            switch rhs {
            case .normal(_):
                return false
            case .selected(let rl):
                return sl != rl
            }
        }
    }
    
    static func ==(_ lhs: CellSizeState,_ rhs: CellSizeState) -> Bool {
        switch lhs {
        case .normal(let sl):
            switch rhs {
            case .normal(let rl):
                return sl == rl
            case .selected(_):
                return false
            }
        case .selected(let sl):
            switch rhs {
            case .normal(_):
                return false
            case .selected(let rl):
                return sl == rl
            }
        }
    }
}

