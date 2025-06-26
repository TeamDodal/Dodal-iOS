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
        
        /// 날짜 설정 관련 객체
        private let calendar = Calendar.current
        
        /// 할일 수정시 나타나는 bottomSheet
        var todoSheetStore = TodoSheetFeature.State()
        
        /// 할일 목록
        var todoListStore = TodoListFeature.State()
        
        /// todoSheet 보임 여부
        var isShowTodoSheet = false
        
        /// 마감일 하루전 팝업 여부
        var isShowDdayPopup = true
        
        /// 마감일 하루전 할일 목록
        var dDayTodos: [Todo] {
            return todoListStore.todoItems.filter { todo in
                guard let dueDate = todo.dueDate else { return false }
                return calendar.isDateInTomorrow(dueDate)
            }
        }
        
        /// 이번주 할일 목록
        var thisWeekTodos: [Todo] {
            guard let weekInterval = calendar.dateInterval(of: .weekOfYear, for: Date()) else {
                return []
            }
            return todoListStore.todoItems.filter { todo in
                guard let dueDate = todo.dueDate else { return false }
                return weekInterval.contains(dueDate)
            }.sorted { $0.dueDate ?? $0.createDate < $1.dueDate ?? $1.createDate }
        }
        
        /// 최근 할일 목록
        /// updateDate 기준으로 최신순 정렬
        var recentTodos: [Todo] {
            return todoListStore.todoItems.sorted { $0.updateDate > $1.updateDate }
        }
    }
    
    enum Action: ViewAction, TCAAction {
        /// todoSheet action
        case todoSheetStore(TodoSheetFeature.Action)
        
        /// todoList action
        case todoListAction(TodoListFeature.Action)
        
        /// view에서 일어나는 액션을 정의
        case view(ViewAction)
        
        /// 외부의존성 액션 정의
        case external(ExternalAction)
        
        /// 화면이동과 관련한 액션 정의
        case destination(DestinationAction)
        
        enum ViewAction: BindableAction {
            case binding(BindingAction<State>)
            
            /// bottomSheet 닫기
            case sheetDismiss
            
            /// bottomSheet 열기
            case sheetPresent
            
            /// view가 나타났을때
            case viewOnAppear
            
            /// 할일 목록을 탭하는 경우
            case todoCellTapped(Todo)
            
            /// 마감 하루전 팝업 닫기
            case dismissDdayPopup
            
            /// 마감일 설정 버튼 터치
            case setDueDateButtonTapped(Todo)
        }
        
        enum DestinationAction {}
        
        enum ExternalAction {}
    }
    
    var body: some Reducer<State, Action> {
        BindingReducer(action: \.view)
        Scope(state: \.todoSheetStore, action: \.todoSheetStore) {
            TodoSheetFeature()
        }
        Scope(state: \.todoListStore, action: \.todoListAction) {
            TodoListFeature()
        }
        Reduce { state, action in
            switch action {
                // MARK: - view action
            case .view(let action):
                switch action {
                case .sheetDismiss:
                    guard let currentView = state.todoSheetStore.currentView else {
                        return .none
                    }
                    if currentView == .editTodo {
                        state.todoSheetStore.todoStore.isEditing = false
                    } else {
                        state.isShowTodoSheet = false
                    }
                    return .none
                case .sheetPresent:
                    state.isShowTodoSheet = true
                    return .none
                case .viewOnAppear:
                    return .send(.todoListAction(.view(.viewonAppear)))
                case .dismissDdayPopup:
                    state.isShowDdayPopup = false
                    return .none
                case let .setDueDateButtonTapped(todoItem):
                    state.todoSheetStore = .setDueDate(todo: todoItem)
                    state.isShowTodoSheet = true
                    return .none
                default:
                    return .none
                }
                // MARK: - todoSheet action
            case let .todoSheetStore(action):
                switch action {
                case .editingCanelled, .crateTodoCompleted:
                    state.isShowTodoSheet = false
                    state.todoSheetStore = .init()
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
