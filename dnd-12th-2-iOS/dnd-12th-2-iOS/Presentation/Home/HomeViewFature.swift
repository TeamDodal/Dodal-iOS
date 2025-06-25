//
//  HomeViewFature.swift
//  dnd-12th-2-iOS
//
//  Created by 권석기 on 6/20/25.
//
import Foundation
import ComposableArchitecture

@Reducer
struct HomeViewFeature {
    @ObservableState
    struct State {
       var todoSheetState = TodoSheetFeature.State()
       var todoListState = TodoListFeature.State()
        /// 날짜 설정 관련 객체
        private let calendar = Calendar.current
       var isShowTodoSheet = false
        /// 할일 추가 보임 여부
        var isShowAddTodoSheet = false
        /// 마감일 하루전 팝업 여부
        var isShowDdayPopup = true
        /// 마감일 하루전 할일 목록
        var dDayTodos: [Todo] {
            return todoListState.todoItems.filter { todo in
                guard let dueDate = todo.dueDate else { return false }
                return calendar.isDateInTomorrow(dueDate)
            }
        }
        /// 이번주 할일 목록
        var thisWeekTodos: [Todo] {
            guard let weekInterval = calendar.dateInterval(of: .weekOfYear, for: Date()) else {
                return []
            }
            return todoListState.todoItems.filter { todo in
                guard let dueDate = todo.dueDate else { return false }
                return weekInterval.contains(dueDate)
            }.sorted { $0.dueDate ?? $0.createDate < $1.dueDate ?? $1.createDate }
        }
        
        /// 최근 할일 목록
        /// updateDate 기준으로 최신순 정렬
        var recentTodos: [Todo] {
            return todoListState.todoItems.sorted { $0.updateDate > $1.updateDate }
        }
    }
    
    enum Action: ViewAction, TCAAction {
        case todoSheetAction(TodoSheetFeature.Action)
        case todoListAction(TodoListFeature.Action)
        case view(ViewAction)
        case external(ExternalAction)
        case destination(DestinationAction)
        
        enum ViewAction: BindableAction {
            case binding(BindingAction<State>)
            case sheetDismiss
            case sheetPresent
            case viewOnAppear
            /// 할일 목록을 탭하는 경우
            case todoCellTapped(Todo)
            /// 마감 하루전 팝업 닫기
            case dismissDdayPopup
            /// 마감일 설정 버튼 터치
            case setDueDateButtonTapped(Todo)
        }
        
        enum DestinationAction {
            
        }
        
        enum ExternalAction {}
    }
    
    var body: some Reducer<State, Action> {
        BindingReducer(action: \.view)
        Scope(state: \.todoSheetState, action: \.todoSheetAction) {
            TodoSheetFeature()
        }
        Scope(state: \.todoListState, action: \.todoListAction) {
            TodoListFeature()
        }
        Reduce { state, action in
            switch action {
            case .view(let viewAction):
                switch viewAction {
                case .sheetDismiss:
                    state.todoSheetState.todoState.isEditing = false
                    return .none
                case .sheetPresent:
                    state.isShowTodoSheet = true
                    return .none
                case .viewOnAppear:
                    return .send(.todoListAction(.view(.viewonAppear)))
                case .dismissDdayPopup:
                    state.isShowDdayPopup = false
                    return .none
                default:
                    return .none
                }
            case let .todoSheetAction(action):
                switch action {
                case .editingCanelled:
                    state.isShowTodoSheet = false
                    state.todoSheetState = .init()
                    return .none
                case .crateTodoCompleted:
                    state.isShowTodoSheet = false
                    state.todoSheetState = .init()
                    return .send(.todoListAction(.view(.viewonAppear)))
                default:
                    return .none
                }
                
            default:
                return .none
            }
        }
    }
}
