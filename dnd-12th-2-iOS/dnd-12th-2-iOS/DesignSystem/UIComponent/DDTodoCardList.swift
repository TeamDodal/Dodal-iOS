//
//  DDTodoCard.swift
//  dnd-12th-2-iOS
//
//  Created by Allie on 5/20/25.
//

import SwiftUI

struct DDTodoCardList: View {
    let todos: [Todo]
    let title: String
    var itemsPerPage: Int = 3
    var action: ((Todo)->())? = nil
    var cancelAction: (()->())? = nil
    
    @State private var selectedIndex = 0
    
    var isRemovable: Bool {
        cancelAction != nil
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            
            HStack(alignment: .center) {
                Text(title)
                    .font(.pretendard(size: 16, weight: .semibold))
                    .foregroundStyle(isRemovable ? .mainBlue : .gray700)
                
                Spacer()
                if isRemovable {
                    Button {
                        cancelAction?()
                    } label: {
                        Image(.iconX)
                    }
                }
            }
            .padding(.horizontal, 12)
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
                let tabBarCount = todos.count / itemsPerPage + (todos.count % itemsPerPage > 0 ? 1 : 0)
                VStack {
                    // TabView
                    VStack(spacing: 8) {
                        ForEach(0...itemsPerPage, id: \.self) { _ in
                            DDTodoCard(todo: Todo(id: UUID(), title: "", depth: 0, path: ""))
                        }
                    }
                    .opacity(0)
                    .overlay (
                        TabView(selection: $selectedIndex) {
                            ForEach(0..<tabBarCount, id: \.self) { index in
                                VStack(spacing: 8) {
                                    let startIdx = index*itemsPerPage
                                    let lastIdx = startIdx + min(itemsPerPage, todos.count - startIdx)
                                    
                                    ForEach(todos[startIdx..<lastIdx], id: \.self) { todo in
                                        DDTodoCard(todo: todo)
                                            .onTapGesture {
                                                action?(todo)
                                            }
                                    }
                                    Spacer()
                                }
                            }
                            .frame(maxWidth: .infinity)
                            .padding(.top, 8)
                            .padding(.horizontal, 12)
                        }
                            .tabViewStyle(
                                PageTabViewStyle(
                                    indexDisplayMode: .never
                                )
                            )
                    )
                    
                    HStack(spacing: 8) {
                        ForEach(0..<tabBarCount, id: \.self) { index in
                            Circle()
                                .frame(width: 8, height: 8)
                                .foregroundStyle(selectedIndex == index ? .gray900 : .gray100)
                        }
                    }
                    .padding(.bottom, 12)
                }
                .padding(.top, 8)
            }
        }
        .background(.gray0)
        .cornerRadius(12)
    }
}
