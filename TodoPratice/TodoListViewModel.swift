//
//  TodoListViewModel.swift
//  TodoPratice
//
//  Created by 장정재 on 1/13/26.
//

import SwiftUI
import Combine

final class TodoListViewModel: ObservableObject {
    
    @Published var todos: [TodoItem] = [] {
        didSet {
            saveTodos()
        }
    }
    
    @Published var filter: TodoFilter = .all
    
    var filteredTodos: [TodoItem] {
        switch filter {
        case .all:
            return todos
        case .done:
            return todos.filter {$0.isDone}
        case .todo:
            return todos.filter {!$0.isDone}
        }
    }
    
    private let saveKey = "todos_key"
    
    init() {
        loadTodos()
    }
    
    func add(title: String) {
        todos.append(TodoItem(id: UUID(), title: title, isDone: false))
    }
    
    func delete(at offsets: IndexSet) {
        todos.remove(atOffsets: offsets)
    }

    private func saveTodos() {
        guard let data = try? JSONEncoder().encode(todos) else { return
        }
        UserDefaults.standard.set(data, forKey: saveKey)
    }
    
    private func loadTodos() {
        guard let data = UserDefaults.standard.data(forKey: saveKey),
              let savedTodos = try? JSONDecoder().decode([TodoItem].self, from: data)
        else {
            return
        }
        
        todos = savedTodos
    }
    
    func toggledone(_ todo: TodoItem) {
        guard let index = todos.firstIndex(where: {$0.id == todo.id }) else {return}
        todos[index].isDone.toggle()
    }
// 위 펑션은 RowView에서 바인딩이 아닌 뷰모델로 받아왔을 때 사용하는 함수
}
