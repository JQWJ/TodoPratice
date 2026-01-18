//
//  TodoFilter.swift
//  TodoPratice
//
//  Created by 장정재 on 1/16/26.
//

import SwiftUI

enum TodoFilter: String, CaseIterable, Identifiable, Equatable {
    case all = "All"
    case done = "Done"
    case todo = "Todo"
    
    var id: Self { self }
}
