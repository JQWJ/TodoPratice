//
//  TodoListViewModel.swift
//  TodoPratice
//
//  Created by 장정재 on 1/13/26.
//

import SwiftUI
import Combine

enum TodoFilter: String, CaseIterable {
    case all = "전체"
    case active = "미완료"
    case completed = "완료"
}

final class TodoListViewModel: ObservableObject {
    
    @Published var todos: [TodoItem] = [] {
        didSet {
            saveTodos()
        }
    }
    
    @Published var searchText: String = ""
    @Published var filter: TodoFilter = .all
    @Published var isCompletedExpanded: Bool = true
    
    // 미완료
    var activeTodos: [TodoItem] {
        filteredTodos.filter { !$0.isDone }
    }
    
    var completedTodos: [TodoItem] {
        filteredTodos.filter { $0.isDone }
    }

    
    private var filteredTodos: [TodoItem] {
        todos
            .filter { todo in
                switch filter {
                case .all:
                    return true
                case .active:
                    return !todo.isDone
                case .completed:
                    return todo.isDone
                }
            }
            .filter {
                searchText.isEmpty ||
                $0.title.localizedCaseInsensitiveContains(searchText)
            }
    }
    
    var visibleTodos: [TodoItem] {
        todos
        // 필터
            .filter { todo in
                switch filter {
                case .all:
                    return true
                case .active:
                    return !todo.isDone
                case .completed:
                    return todo.isDone
                }
            }
        // 검색
            .filter {
                searchText.isEmpty ||
                $0.title.localizedCaseInsensitiveContains(searchText)
            }
        // 정렬 고도화
        .sorted { lhs, rhs in
                if lhs.isDone != rhs.isDone {
                    return !lhs.isDone // 미완료 먼저
                }
                
                if lhs.priority != rhs.priority {
                    return lhs.priority.rawValue < rhs.priority.rawValue
                }
                
                return lhs.id.uuidString < rhs.id.uuidString
            }
    }
    
    private let saveKey = "todos_key"
    
    init() {
        loadTodos()
    }
    
    func add(title: String, priority: TodoPriority) {
        todos.append(
            TodoItem(
                id: UUID(),
                title: title,
                isDone: false,
                priority: priority
            )
        )
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
        
        DispatchQueue.main.async {
            self.todos.sort { a, b in
                if a.isDone != b.isDone {
                    return !a.isDone
                }
                return a.priority.rawValue < b.priority.rawValue
            }
        }
    }
// 위 펑션은 RowView에서 바인딩이 아닌 뷰모델로 받아왔을 때 사용하는 함수
    
    func moveActive(from source: IndexSet, to destination: Int) {

        var active = visibleTodos.filter { !$0.isDone }
        var completed = visibleTodos.filter { $0.isDone }

        // 미완료 안에서 움직이는 경우
        if destination <= active.count {
            active.move(fromOffsets: source, toOffset: destination)

            for (index, todo) in active.enumerated() {
                if let realIndex = todos.firstIndex(where: { $0.id == todo.id }) {
                    todos[realIndex].priority = TodoPriority(rawValue: index) ?? .low
                }
            }

        }
        // 완료 영역으로 드래그한 경우 👉 완료 처리
        else {
            for index in source {
                let todo = active[index]

                if let realIndex = todos.firstIndex(where: { $0.id == todo.id }) {
                    todos[realIndex].isDone = true
                }
            }
        }
    }
}
