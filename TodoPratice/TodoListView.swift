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
        // 완료,미완료 필터
            .filter { todo in
                switch selectedFilter {
                case .all:
                    return true
                case .active:
                    return !todo.isDone
                case .completed:
                    return todo.isDone
                }
            }
            .filter { todo in
                searchText.isEmpty ||
                todo.title.localizedCaseInsensitiveContains(searchText)
            }
            .sorted { lhs, rhs in
                lhs.isDone == false && rhs.isDone == true
            }
    }
    
    var body: some View {
        NavigationStack {
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
        .navigationTitle("Todo")
        .searchable(text: $searchText, prompt: "할 일 검색")
        // 네비게이션 바깥에 생성하기
        
            if viewModel.todos.isEmpty {
                ContentUnavailableView(
                    "할 일이 없어요",
                    systemImage: "tray",
                    description: Text("새로운 할 일을 추가해보세요")
                )
                .toolbar {
                    ToolbarItem(placement: .topBarTrailing) {
                        Button("Add") {
                            showNewSheet = true
                        }
                        .sheet(isPresented: $showNewSheet) {
                            AddTodoView(viewModel: viewModel)
                        }
                    }
                }
            } else if !searchText.isEmpty && filteredTodos.isEmpty {
                ContentUnavailableView(
                    "검색 결과 없음",
                    systemImage: "magnifyingglass",
                    description: Text("다른 검색어를 입력해보세요")
                    )
                .toolbar {
                    ToolbarItem(placement: .topBarTrailing) {
                        Button("Add") {
                            showNewSheet = true
                        }
                        .sheet(isPresented: $showNewSheet) {
                            AddTodoView(viewModel: viewModel)
                        }
                    }
                }
                } else {
                List {
                    ForEach(filteredTodos) { todo in
                        TodoRowView(todo: todo) {
                            withAnimation(.easeInOut) {
                                viewModel.toggledone(todo)
                            }
                        }
                    }
                    .onDelete { viewModel.delete(at: $0) }
                }
                .toolbar {
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
        }
    }
}
