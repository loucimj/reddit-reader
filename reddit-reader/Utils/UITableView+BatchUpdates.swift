//
//  UITableView+BatchUpdates.swift
//  RedditReader
//
//  Created by Javier Loucim on 31/08/2019.
//  Copyright © 2019 Javier Loucim. All rights reserved.
//
//  based on: https://blog.undabot.com/simplifying-animations-using-batch-updates-on-ios-6ad5064bec93

import Foundation
import UIKit

struct BatchUpdates {
    let deleted: [Int]
    let inserted: [Int]
    let moved: [(Int, Int)]
    let reloaded: [Int]
    
}

func compare<T: Equatable>(oldValues: [T], newValues: [T]) -> BatchUpdates {
    var deleted = [Int]()
    var moved = [(Int, Int)]()
    var remainingNewValues = newValues
        .enumerated()
        .map { (element: $0.element, offset: $0.offset,
                alreadyFound: false) }
    outer: for oldValue in oldValues.enumerated() {
        for newValue in remainingNewValues {
            if oldValue.element == newValue.element &&
                !newValue.alreadyFound {
                
                if oldValue.offset != newValue.offset {
                    moved.append((oldValue.offset, newValue.offset))
                }
                
                remainingNewValues[newValue.offset]
                    .alreadyFound = true
                continue outer
            }
        }
        deleted.append(oldValue.offset)
    }
    let inserted = remainingNewValues
        .filter { !$0.alreadyFound }
        .map { $0.offset }
    return BatchUpdates(deleted: deleted, inserted: inserted,
                        moved: moved, reloaded: [])
}

extension UITableView {
    func reloadData(with batchUpdates: BatchUpdates) {
        beginUpdates()
        
        insertRows(at: batchUpdates.inserted
            .map { IndexPath(row: $0, section: 0) }, with: .fade)
        deleteRows(at: batchUpdates.deleted
            .map { IndexPath(row: $0, section: 0) }, with: .fade)
        reloadRows(at: batchUpdates.reloaded
            .map { IndexPath(row: $0, section: 0) }, with: .fade)
        for movedRows in batchUpdates.moved {
            moveRow(at: IndexPath(row: movedRows.0, section: 0),
                    to: IndexPath(row: movedRows.1, section: 0))
        }
        
        endUpdates()
    }
}
