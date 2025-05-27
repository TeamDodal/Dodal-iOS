//
//  TodoDetail.swift
//  dnd-12th-2-iOS
//
//  Created by Allie on 5/27/25.
//

import SwiftUI

struct TodoDetail: View {
    let todos: [Todo]
    
    var body: some View {
        VStack {
            VStack {
                HStack {
                    Button(action: {
                        
                    }) {
                        Image(.iconBack)
                            .foregroundStyle(.gray900)
                    }
                    Spacer()
                    DDImageButton(type: .complete, text: nil) {
                        
                    }
                    .padding(.trailing, 12)
                    Button(action: {
                        
                    }) {
                        Image(.iconEdit)
                            .foregroundStyle(.gray900)
                    }
                }
                .padding(12)
                
                HStack {
                    Image(.iconFolder)
                        .resizable()
                        .frame(width: 16, height: 16)
                    Button(action: {
                        
                    }) {
                        Text("도달 프로젝트 2.0 완성하나둘...")
                            .font(.pretendard(size: 12, weight: .medium))
                            .lineLimit(1)
                            .foregroundStyle(.gray500)
                    }
                    Image(.iconForward)
                        .resizable()
                        .frame(width: 12, height: 12)
                    Button(action: {
                        
                    }) {
                        Text("도달 프로젝트 2.0 완성하나둘...")
                            .font(.pretendard(size: 12, weight: .medium))
                            .lineLimit(1)
                            .foregroundStyle(.gray500)
                    }
                    Image(.iconForward)
                        .resizable()
                        .frame(width: 12, height: 12)
                }
                .padding(.horizontal, 16)
                .padding(.top, 16)
                .padding(.bottom, 12)
                
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Text("토익준비")
                            .font(.pretendard(size: 22, weight: .semibold))
                            .foregroundStyle(.gray900)
                        Spacer()
                        Button(action: {
                            
                        }) {
                            Image(.iconPencil)
                        }
                    }
                    Text("디자인 문서 정리하고 일단 빠르게 뭐시기 하기")
                        .font(.pretendard(size: 14, weight: .regular))
                        .foregroundStyle(.gray700)
                }
                .padding(.horizontal, 16)
                
                HStack {
                    DDImageButton(type: .dueDate, text: nil) {
                        
                    }
                    Spacer()
                }
                .padding(.leading, 16)
                .padding(.bottom, 16)
                .padding(.top, 12)
                
                VStack {
                    
                }
            }
            .background(.gray0)
            
            ScrollView {
                LazyVStack(spacing: 8) {
                    ForEach(todos) { todo in
                        DDTodoRow(todo: todo) {
                            
                        }
                    }
                }
                .padding(.top, 30)
                .padding(.horizontal, 16)
            }
        }
        .background(.gray50)
    }
}

#Preview {
    TodoDetail(todos: [Todo(
        id: UUID(),
        title: "운동하기",
        content: "헬스장 가기",
        dueDate: Calendar.current.date(byAdding: .day, value: 1, to: Date()),
        children: [
            Todo(
                id: UUID(),
                title: "스트레칭",
                content: nil,
                dueDate: Date(),
                parentID: nil,
                depth: 1,
                path: "운동하기 > 스트레칭"
            ),
            Todo(
                id: UUID(),
                title: "웨이트 트레이닝",
                content: nil,
                dueDate: nil,
                parentID: nil,
                depth: 1,
                path: "운동하기 > 웨이트 트레이닝"
            )
        ],
        parentID: nil,
        depth: 0,
        path: "운동하기"
    ),
                       Todo(
                        id: UUID(),
                        title: "책 읽기",
                        content: "자기계발서 30분",
                        dueDate: nil,
                        children: [],
                        parentID: nil,
                        depth: 0,
                        path: "책 읽기"
                       )
    ])
}
