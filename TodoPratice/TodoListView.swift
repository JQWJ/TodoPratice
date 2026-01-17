//
//  ContentView.swift
//  TodoPratice
//
//  Created by 장정재 on 1/13/26.
//

import SwiftUI

struct TodoListView: View {
    
    @StateObject private var viewModel = TodoListViewModel()
    @State private var showNewSheet = false
    @State private var searchText = ""
    @State private var selectedFilter: TodoFilter = .all
    
    enum TodoFilter: String, CaseIterable {
        case all = "전체"
        case active = "미완료"
        case completed = "완료"
    }
    
    var filteredTodos: [TodoItem] {
        viewModel.todos
        // 완료/미완료 필터
            .filter { todo in
                switch selectedFilter {
                case .all:
                    return true
                case .active:
                    return todo.isDone == false
                case .completed:
                    return todo.isDone == true
                }
            }
            .filter { todo in
                searchText.isEmpty ||
                todo.title.localizedCaseInsensitiveContains(searchText)
            }
    }
    
    var body: some View {
        VStack {
            Picker("Filter", selection: $selectedFilter) {
        ForEach(TodoFilter.allCases, id: \.self) { filter in
            Text(filter.rawValue)
                .tag(filter)
        }
    }
    .pickerStyle(.segmented)
    .padding(.horizontal)
        }
        // 네비게이션 바깥에 생성하기
        
        NavigationStack {
            List {
                ForEach(filteredTodos) { todo in
                    TodoRowView(
                        todo: todo,
                            onToggle: {
                        viewModel.toggledone(todo)
                            }
                    )
                }
                .onDelete { viewModel.delete(at: $0) }
            }
            
            .toolbar {
//                ToolbarItem(placement: .principal) {
//                    Picker("Filter", selection: $selectedFilter) {
//                        ForEach(TodoFilter.allCases, id: \.self) { filter in
//                            Text(filter.rawValue)
//                                .tag(filter)
//                        }
//                    }
//                    .pickerStyle(.segmented)
//                    .padding(.horizontal)
//                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Add") {
                        showNewSheet = true
                    }
                    .sheet(isPresented: $showNewSheet) {
                        AddTodoView(viewModel: viewModel)
                    }
                }
            }
            
        }
        .navigationTitle("Todo")
        .searchable(text: $searchText, prompt: "할 일 검색")
    }
}
