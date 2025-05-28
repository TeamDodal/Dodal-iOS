//
//  DDTodoCard.swift
//  dnd-12th-2-iOS
//
//  Created by Allie on 5/20/25.
//

import SwiftUI

struct DDTodoCardList: View {
    let title: String
    let todos: [Todo]
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(title)
                .font(.pretendard(size: 16, weight: .semibold))
                .foregroundStyle(.gray700)
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
                        DDTodoCard(todo: todo)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.top, 8)
                    .padding(.horizontal, 12)
                }
                .padding(.bottom, 36)
            }
        }
        .background(.gray0)
        .cornerRadius(12)
    }
}
