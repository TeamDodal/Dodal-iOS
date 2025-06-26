//
//  DueDateFeature.swift
//  dnd-12th-2-iOS
//
//  Created by 권석기 on 6/25/25.
//

import Foundation
import ComposableArchitecture

@Reducer
struct DueDateCalendarFeature {
    @ObservableState
    struct State {
        /// 기존의 todo를 수정하는 경우 참조용
        var todoItem: Todo? = nil
        /// 마감일
        var dueDate: Date?
        /// 마감일 설정 완료 여부
        var isSetDueDate: Bool { dueDate != nil }
        /// 마감일 설정 버튼 텍스트
        var buttonTitle: String {
            guard let dueDate else { return "마감일 설정" }
            
            let calendar = Calendar.current
            let startOfToday = calendar.startOfDay(for: Date())
            let startOfTarget = calendar.startOfDay(for: dueDate)
            
            guard let diffDay = calendar.dateComponents([.day], from: startOfToday, to: startOfTarget).day,
                  diffDay > 0 else {
                return "마감일 설정"
            }
            
            return "\(dueDate.toMonthDayString)일까지 D-\(diffDay)일"
        }
        
        /// 초기 생성시 dueDate만 남겨줌
        /// - Parameter dueDate: 마감일
        init(dueDate: Date?) {
            self.dueDate = dueDate
        }
        
        /// 기존 todo의 마감일 수정시
        /// - Parameter todoItem: 참조용 todo
        init(todoItem: Todo? = nil) {
            self.todoItem = todoItem
            self.dueDate = todoItem?.dueDate
        }
    }
    
    enum Action: BindableAction {
        /// 동적으로 바인딩 하기위한 액션
        case binding(BindingAction<State>)
        /// 마감일 설정 버튼 탭
        case setDueDateButtonTapped
        /// 마감일 변경시 => 날짜 Cell 탭할때마다
        case dueDateChanged(Date?)
        /// 마감일 설정 완료 시
        case setDueDateCompleted(Todo)
    }
    
    var body: some Reducer<State, Action> {
        BindingReducer()
        Reduce { state, action in
            switch action {
            case .binding(\.dueDate):
                // 마감일은 현재 또는 미래만 선택 가능
                if let dueDate = state.dueDate, dueDate < .now {
                    state.dueDate = nil
                    return .none
                }
                return .send(.dueDateChanged(state.dueDate))
            case .setDueDateButtonTapped:
                if var updatedTodo = state.todoItem {
                    updatedTodo.dueDate = state.dueDate
                    return .send(.setDueDateCompleted(updatedTodo))
                }
            default:
                return .none
            }
            return .none
        }
    }
}
