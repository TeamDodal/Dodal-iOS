//
//  DDTodoCard.swift
//  dnd-12th-2-iOS
//
//  Created by 권석기 on 5/28/25.
//

import SwiftUI

struct DDTodoCard: View {
    let todo: Todo
    var action: (()->())?
    
    var body: some View {
        HStack {
            Image(todo.isCompleted ? .iconCheck : .iconCheckGray)
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
                    action?()
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
        .padding(8)
        .background(.white)
        .cornerRadius(8)
    }
    
    private func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.dateFormat = "M월 d일"
        return formatter.string(from: date)
    }
}

#Preview {
    DDTodoCard(todo: .init(id: UUID(), title: "", createDate: Date(), updateDate: Date(), depth: 0, path: []))
}
