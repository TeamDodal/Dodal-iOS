//
//  DDTodoRow.swift
//  dnd-12th-2-iOS
//
//  Created by Allie on 5/27/25.
//

import SwiftUI

struct DDTodoRow: View {
    let todo: Todo
    let onSetDueDate: (() -> Void)?
    let onTap: (() -> Void)?

    var body: some View {
        HStack {
            Image(.iconCheckGray)
                .resizable()
                .frame(width: 32, height: 32)
                .padding(.leading, 8)
            
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
                    .font(.pretendard(size: 12, weight: .medium))
                    .foregroundStyle(.gray500)
                    .padding(.trailing, 8)
            } else {
                Button("마감일 설정") {
                    onSetDueDate?()
                }
                .font(.pretendard(size: 12, weight: .medium))
                .foregroundStyle(.mainBlue)
                .padding(.horizontal, 8)
                .padding(.vertical, 6)
                .background {
                    RoundedRectangle(cornerRadius: 6)
                        .fill(.mainBlue.opacity(0.1))
                }
                .padding(.trailing, 8)
            }
        }
        .frame(height: 48)
        .frame(maxWidth: .infinity)
        .background {
            RoundedRectangle(cornerRadius: 8)
                .fill(.gray0)
        }
        .contentShape(Rectangle())
        .onTapGesture {
            onTap?()
        }
    }

    private func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.dateFormat = "M월 d일"
        return formatter.string(from: date)
    }
}

//#Preview {
//    DDTodoRow()
//}
