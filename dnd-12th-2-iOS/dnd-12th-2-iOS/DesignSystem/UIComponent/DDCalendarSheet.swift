//
//  DDCalendarSheet.swift
//  dnd-12th-2-iOS
//
//  Created by 박우연 on 6/21/25.
//

import SwiftUI

struct DDCalendarSheet: View {
    @Binding var isPresented: Bool
    @Binding var selectedDate: Date?
    let todos: [Todo]
    
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Button(action: {
                    isPresented = false
                }) {
                    Image(.iconBack)
                        .foregroundStyle(.gray900)
                }
                Text("마감일")
                    .font(.pretendard(size: 16, weight: .semibold))
                    .padding(.leading, 131)
                Spacer()
            }
            .padding(.horizontal, 12)
            .padding(.top, 20)
            
            DDCalendar(selectedDate: $selectedDate)
                .padding(.horizontal, 16)
                .padding(.top, 12)
            
            Text("\(selectedDate?.toMonthDayString ?? "") 마감인 할 일")
                .font(.pretendard(size: 18, weight: .bold))
                .foregroundStyle(.black)
                .padding(.top, 42)
                .padding(.horizontal, 16)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            ScrollView {
                LazyVStack(spacing: 12) {
                    ForEach(todos) { todo in
                        DDTodoRow(todo: todo) {
                            
                        } onTap: {
                            
                        }
                    }
                }
                .padding(.top, 14)
                .padding(.horizontal, 16)
            }
        }
        .background(.white)
        .clipShape(.rect(cornerRadius: 12))
    }
}

//#Preview {
//    DDCalendarSheet()
//}
