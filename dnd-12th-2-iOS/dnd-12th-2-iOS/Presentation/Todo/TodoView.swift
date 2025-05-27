//
//  TodoView.swift
//  dnd-12th-2-iOS
//
//  Created by 권석기 on 5/6/25.
//

import SwiftUI

import ComposableArchitecture

struct TodoView: View {
    let todos: [Todo]
    
    var body: some View {
        WithPerceptionTracking {
            VStack(alignment: .leading, spacing: 0) {
                DDHeader(dateText: dateString) {
                    
                }
                if todos.isEmpty {
                    VStack {
                        Image(.imgEmpty)
                            .resizable()
                            .frame(width: 261, height: 267)
                            .padding(.bottom, 16)
                        Text("모든 할 일을 완수했어요!")
                            .font(.pretendard(size: 24, weight: .bold))
                            .foregroundStyle(.gray900)
                            .padding(.bottom, 8)
                        Text("할 일을 추가해보세요. 스케줄을 관리하고\n설정하기 어려운 할 일을 만들어드립니다.")
                            .font(.pretendard(size: 14, weight: .medium))
                            .foregroundStyle(.gray600)
                            .multilineTextAlignment(.center)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 127)
                    .padding(.bottom, 12)
                } else {
                    ScrollView {
                        LazyVStack(spacing: 8) {
                            ForEach(todos) { todo in
                                DDTodoRow(todo: todo) {
                                    // 마감일 설정 처리
                                }
                            }
                        }
                        .padding(.top, 22)
                        .padding(.horizontal, 16)
                    }
                }
                Spacer()
            }
            .background(.gray50)
        }
    }
    
    private var dateString: String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.dateFormat = "M월 d일"
        let date = formatter.string(from: Date())
        formatter.dateFormat = "E"
        let day = formatter.string(from: Date())
        
        return "\(date) (\(day))"
    }
}

#Preview {
    TodoView(todos: [
        //        Todo(
        //            id: UUID(),
        //            title: "운동하기",
        //            content: "헬스장 가기",
        //            dueDate: Calendar.current.date(byAdding: .day, value: 1, to: Date()),
        //            children: [
        //                Todo(
        //                    id: UUID(),
        //                    title: "스트레칭",
        //                    content: nil,
        //                    dueDate: Date(),
        //                    parentID: nil,
        //                    depth: 1,
        //                    path: "운동하기 > 스트레칭"
        //                ),
        //                Todo(
        //                    id: UUID(),
        //                    title: "웨이트 트레이닝",
        //                    content: nil,
        //                    dueDate: nil,
        //                    parentID: nil,
        //                    depth: 1,
        //                    path: "운동하기 > 웨이트 트레이닝"
        //                )
        //            ],
        //            parentID: nil,
        //            depth: 0,
        //            path: "운동하기"
        //        ),
        //        Todo(
        //            id: UUID(),
        //            title: "책 읽기",
        //            content: "자기계발서 30분",
        //            dueDate: nil,
        //            children: [],
        //            parentID: nil,
        //            depth: 0,
        //            path: "책 읽기"
        //        )
    ])
}
