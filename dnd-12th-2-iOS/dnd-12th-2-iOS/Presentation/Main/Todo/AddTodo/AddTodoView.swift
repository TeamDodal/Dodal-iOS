//
//  AddTodoView.swift
//  dnd-12th-2-iOS
//
//  Created by 권석기 on 5/12/25.
//

import SwiftUI

import ComposableArchitecture

struct AddTodoView: View {
    @Perception.Bindable fileprivate var store: StoreOf<TodoFeature>
    
    init(store: StoreOf<TodoFeature>) {
        self.store = store
    }
    
    var body: some View {
        WithPerceptionTracking {
            VStack {
                TextField("eg.운동하기", text: $store.title)
                    .font(.pretendard(size: 22, weight: .semibold))
                    .foregroundStyle(.black)
                    .padding(.top, 12)
                    .padding(.horizontal, 16)
                TextEditor(text: $store.content)
                    .frame(height:64)
                    .overlay(alignment: .topLeading) {
                        Text("설명")
                            .font(.pretendard(size: 14, weight: .regular))
                            .foregroundStyle(.gray400)
                            .offset(x: 16, y: 4)
                            .opacity(store.content.isEmpty ? 1 : 0)
                    }
                HStack {
                    endDateButton
                    Spacer()
                    createTodoButton
                }
                .padding(.vertical, 12)
                .padding(.horizontal, 16)
                Spacer()
            }
        }
    }
    
    private var endDateButton: some View {
        Button(action: {}, label: {
            HStack(spacing: 4) {
                Image(.iconCalendarGray)
                Text("마감일")
                    .font(.pretendard(size: 14, weight: .medium))
                    .foregroundStyle(.gray500)
            }
            .padding(.horizontal, 8)
            .frame(height: 34)
            .background(
                  RoundedRectangle(cornerRadius: 8)
                      .stroke(Color.gray200, lineWidth: 1)
              )
        })
    }
    
    private var createTodoButton: some View {
        Button(action: {}, label: {
            Text("생성하기")
                .font(.pretendard(size: 16, weight: .medium))
                .foregroundStyle(.gray0)
                .padding(.horizontal, 8)
                .frame(height: 34)
                .background(.mainBlue)
                .cornerRadius(8)
        })
    }
}

//#Preview {
//    AddTodoView(store: .init(initialState: TodoFeature.State(), reducer: {
//        TodoFeature()
//    }))
//}
