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
        
    var body: some View {
        NavigationStack {
            Picker("Filter", selection: $viewModel.filter) {
                ForEach(TodoFilter.allCases, id: \.self) { filter in
                    Text(filter.rawValue)
        }
    }
    .pickerStyle(.segmented)
    .padding(.horizontal)
            
    .searchable(text: $viewModel.searchText)
            
        .navigationTitle("Todo")
        .searchable(text: $viewModel.searchText, prompt: "할 일 검색")
            
            if viewModel.activeTodos.isEmpty && viewModel.completedTodos.isEmpty {
                ContentUnavailableView(
                    viewModel.searchText.isEmpty ? "할 일이 없음" : "검색 결과 없음",
                    systemImage: viewModel.searchText.isEmpty ? "tray" : "magnifyingglass",
                    description: Text(
                        viewModel.searchText.isEmpty ? "새로운 할 일을 추가해봐" : "다른 검색어를 입력해"
                    )
                )
            } else {    
                List {

                    if !viewModel.activeTodos.isEmpty {
                        Section("미완료") {
                            ForEach(viewModel.activeTodos) { todo in
                                TodoRowView(todo: todo) {
                                    withAnimation {
                                        viewModel.toggledone(todo)
                                    }
                                }
                            }
                        }
                    }

                    if !viewModel.completedTodos.isEmpty {
                        Section("완료") {
                            ForEach(viewModel.completedTodos) { todo in
                                TodoRowView(todo: todo) {
                                    withAnimation {
                                        viewModel.toggledone(todo)
                                    }
                                }
                            }
                        }
                    }
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
