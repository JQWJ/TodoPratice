//
//  TodoItem.swift
//  TodoPratice
//
//  Created by 장정재 on 1/13/26.
//

import SwiftUI

enum TodoPriority: Int, Codable, CaseIterable {
    case high = 0
    case medium = 1
    case low = 2
    // int rawValue를 쓰는 이유는 정렬을 쉽게 하기 위해서임
    
    var title: String {
        switch self {
        case .high:  return "높음"
        case .medium: return "중간"
        case .low:   return "낮음"
        }
    }
}

struct TodoItem: Identifiable, Codable, Equatable {
    let id: UUID
    var title: String
    var isDone: Bool
    var priority: TodoPriority
}
