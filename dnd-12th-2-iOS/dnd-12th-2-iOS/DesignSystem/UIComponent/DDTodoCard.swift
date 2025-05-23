//
//  DDTodoCard.swift
//  dnd-12th-2-iOS
//
//  Created by Allie on 5/20/25.
//

import SwiftUI

struct DDTodoCard: View {
    let todos: [Todo]
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("최근")
                .font(.pretendard(size: 14, weight: .semibold))
                .foregroundStyle(.gray900)
                .padding(.leading, 12)
                .padding(.top, 12)
            
            if todos.isEmpty {
                VStack(spacing: 12) {
                    Image(.iconCheck)
                        .resizable()
                        .frame(width: 46, height: 46)
                        .foregroundStyle(.mainBlue)
                    Text("할 일을 추가해보세요. 스케줄을 관리하고\n설정하기 어려운 할 일을 만들어드립니다.")
                        .font(.pretendard(size: 14, weight: .medium))
                        .foregroundStyle(.gray600)
                        .multilineTextAlignment(.center)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 37)
                .padding(.bottom, 12)
            } else {
                VStack(spacing: 8) {
                    ForEach(todos) { todo in
                        HStack {
                            Image(.iconCheckGray)
                                .resizable()
                                .frame(width: 32, height: 32)
                            
                            Text(todo.title)
                                .font(.pretendard(size: 14, weight: .medium))
                                .foregroundStyle(.gray900)
                            
                            HStack(spacing: 0) {
                                Image(.iconLink)
                                Text("\(todo.children.filter { $0.dueDate != nil }.count)/\(todo.children.count)")
                                    .font(.pretendard(size: 12, weight: .regular))
                                    .foregroundStyle(.gray500)
                            }
                            Spacer()
                            if let dueDate = todo.dueDate {
                                Text(formattedDate(dueDate))
                                    .font(.pretendard(size: 14, weight: .medium))
                                    .foregroundStyle(.gray500)
                            } else {
                                Button("마감일 설정") {
                                    // 액션
                                }
                                .font(.pretendard(size: 12, weight: .medium))
                                .foregroundStyle(.mainBlue)
                                .padding(.horizontal, 8)
                                .padding(.vertical, 6)
                                .background {
                                    RoundedRectangle(cornerRadius: 6)
                                        .fill(.mainBlue.opacity(0.1))
                                }
                            }
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.top, 8)
                    .padding(.horizontal, 12)
                }
                .padding(.bottom, 36)
            }
        }
        .cornerRadius(12)
    }
    
    private func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.dateFormat = "M월 d일"
        return formatter.string(from: date)
    }
}
