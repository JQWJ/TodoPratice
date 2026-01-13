//
//  TodoListViewModel.swift
//  TodoPratice
//
//  Created by 장정재 on 1/13/26.
//

import SwiftUI
import Combine

final class TodoListViewModel: ObservableObject {
    
    @Published var todos: [TodoItem] = []
    
    func add(title: String) {
        let newTodo = TodoItem(title: title, isDone: false)
        todos.append(newTodo)
    }
    
    func delete(at offsets: IndexSet) {
        todos.remove(atOffsets: offsets)
    }
    
//    func toggledone(_ todo: TodoItem) {
//        guard let index = todos.firstIndex(where: {$0.id == todo.id }) else {
//            return
//        }
//    }
// 위 펑션은 RowView에서 바인딩이 아닌 뷰모델로 받아왔을 때 사용하는 함수
}
