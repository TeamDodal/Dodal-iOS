//
//  AddTodoView.swift
//  dnd-12th-2-iOS
//
//  Created by 권석기 on 5/12/25.
//

import SwiftUI

import ComposableArchitecture

enum Field {
    case title
}

struct TodoModalView: View {
    @Perception.Bindable fileprivate var store: StoreOf<CreateTodoFeature>
    @FocusState private var focusedField: Field?
    init(store: StoreOf<CreateTodoFeature>) {
        self.store = store
    }
    
    var body: some View {
        WithPerceptionTracking {
            switch store.viewFlow {
            case .addTodo:
                addTodoView
            case .calendar:
                calendarView
            }
        }
    }
    
    private var endDateButton: some View {
        VStack {
            let buttonColor: Color = store.dueDate != nil ? .mainBlue : .gray500
            Button(action: {
                store.send(.view(.setDueDateButtonTapped))
            }, label: {
                HStack(spacing: 4) {
                    Image(.iconCalendarGray)
                        .renderingMode(.template)
                        .foregroundStyle(buttonColor)
                    Text(store.dueDate?.toMonthDayString ?? "마감일")
                        .font(.pretendard(size: 14, weight: .medium))
                        .foregroundStyle(buttonColor)
                }
                .padding(.horizontal, 8)
                .frame(height: 34)
                .background(
                      RoundedRectangle(cornerRadius: 8)
                          .stroke(buttonColor, lineWidth: 1)
                  )
            })
        }
      
    }
    
    private var createTodoButton: some View {
        Button(action: {
            store.send(.view(.addTodoButtonTapped))
        }, label: {
            Text("생성하기")
                .font(.pretendard(size: 16, weight: .medium))
                .foregroundStyle(.gray0)
                .padding(.horizontal, 8)
                .frame(height: 34)
                .background(store.title.isEmpty ? .gray300 : .mainBlue)
                .cornerRadius(8)
        })
        .disabled(store.title.isEmpty)
    }
    
    private var addTodoView: some View {
        VStack {
            TextField("eg.운동하기", text: $store.title)
                .font(.pretendard(size: 22, weight: .semibold))
                .foregroundStyle(.black)
                .padding(.top, 12)
                .padding(.horizontal, 16)
                .focused($focusedField, equals: .title)
            TextEditor(text: $store.content)
                .frame(height:64)
                .overlay(alignment: .topLeading) {
                    Text("설명")
                        .font(.pretendard(size: 14, weight: .regular))
                        .foregroundStyle(.gray400)
                        .offset(x: 2, y: 8)
                        .opacity(store.content.isEmpty ? 1 : 0)
                }
                .padding(.leading, 16)
            HStack {
                endDateButton
                Spacer()
                createTodoButton
            }
            .padding(.vertical, 12)
            .padding(.horizontal, 16)
            .overlay(alignment: .top, content: {
                Divider()
            })
            Spacer()
        }
        .background(.white)
        .clipShape(
            .rect(
                topLeadingRadius: 12,
                bottomLeadingRadius: 0,
                bottomTrailingRadius: 0,
                topTrailingRadius: 12
            )
        )
        .onAppear {
            focusedField = .title
        }
    }
    
    private var calendarView: some View {
        VStack {
            HStack {
                Button {
                    store.send(.view(.backButtonTapped))
                } label: {
                    Image(.iconBack)
                }
                Spacer()
                Text("마감일")
                    .font(.pretendard(size: 18, weight: .semibold))
                Spacer()
                Image(.iconBack)
                    .opacity(0)
            }
            .frame(height: 32)
            .padding(.horizontal, 12)
            .padding(.top, 12)
            
            DDCalendar(month: Date(), selectedDate: $store.dueDate)
            DDButton(type: store.dueDate == nil ? .disabled : .primary, title: store.setDueDateButtonText, action: {
                store.send(.view(.backButtonTapped))
            })
            .disabled(store.dueDate == nil)
                .padding(.horizontal, 16)
        }
        .background(.white)
        .clipShape(
            .rect(
                topLeadingRadius: 12,
                bottomLeadingRadius: 0,
                bottomTrailingRadius: 0,
                topTrailingRadius: 12
            )
        )
    }
}

//#Preview {
//    AddTodoView(store: .init(initialState: TodoFeature.State(), reducer: {
//        TodoFeature()
//    }))
//}
