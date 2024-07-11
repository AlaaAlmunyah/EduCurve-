//
//  Item.swift
//  finalfront
//
//  Created by Alaa A on 02/01/1446 AH.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
