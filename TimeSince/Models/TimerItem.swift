//
//  TimerItem.swift
//  TimeSince
//
//  Created by Reeves Froning on 2024/06/21.
//

import Foundation
import SwiftData

@Model
final class TimerItem {
    let id: UUID
    var subject: String
    var action: String
    var lastOccurrence: Date
    var order: Int
    
    init(id: UUID = UUID(), subject: String, action: String, lastOccurrence: Date, order: Int) {
        self.id = id
        self.subject = subject
        self.action = action
        self.lastOccurrence = lastOccurrence
        self.order = order
    }
}
