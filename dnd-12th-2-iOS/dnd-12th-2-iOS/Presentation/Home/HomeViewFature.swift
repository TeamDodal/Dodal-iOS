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
        // 캘린더 시트 표시 여부
        var isShowCalendarSheet = false
        
        // 날짜 계산용 Calendar 객체 (내부 전용)
        private let calendar = Calendar.current
        
        // 할 일 편집/생성 시 표시되는 바텀시트의 상태
        var todoSheetStore = TodoSheetFeature.State()
        
        // 전체 할 일 목록 상태
        var todoListStore = TodoListFeature.State()
        
        // 할 일 시트 표시 여부
        var isShowTodoSheet = false
        
        // 마감 하루 전 팝업 표시 여부
        var isShowDdayPopup = true
        
        // 선택된 캘린더 날짜 (기본값: 오늘)
        var calendarSelectedDate: Date? = Date()
        
        // 선택한 날짜에 해당하는 할 일 목록
        var todosForSelectedDate: [Todo] {
            guard let selectedDate = calendarSelectedDate else { return [] }
            return todoListStore.todoItems.filter { todo in
                guard let due = todo.dueDate else { return false }
                return calendar.isDate(due, inSameDayAs: selectedDate)
            }
        }
        
        // 마감일이 내일인 할 일 목록
        var dDayTodos: [Todo] {
            return todoListStore.todoItems.filter { todo in
                guard let dueDate = todo.dueDate else { return false }
                return calendar.isDateInTomorrow(dueDate)
            }
        }
        
        // 이번 주에 마감되는 할 일 목록 (마감일 순 정렬)
        var thisWeekTodos: [Todo] {
            guard let weekInterval = calendar.dateInterval(of: .weekOfYear, for: Date()) else {
                return []
            }
            return todoListStore.todoItems.filter { todo in
                guard let dueDate = todo.dueDate else { return false }
                return weekInterval.contains(dueDate)
            }.sorted {
                ($0.dueDate ?? $0.createDate) < ($1.dueDate ?? $1.createDate)
            }
        }
        
        // 최근 수정된 할 일 목록 (업데이트 날짜 기준 내림차순 정렬)
        var recentTodos: [Todo] {
            return todoListStore.todoItems.sorted {
                $0.updateDate > $1.updateDate
            }
        }
    }
    
    
    enum Action: ViewAction, TCAAction {
        // 하위 바텀시트 기능(TodoSheet)의 액션
        case todoSheetStore(TodoSheetFeature.Action)
        
        // 하위 리스트 기능(TodoList)의 액션
        case todoListAction(TodoListFeature.Action)
        
        // View에서 발생하는 사용자 인터랙션 관련 액션
        case view(ViewAction)
        
        // 외부 의존성 또는 사이드이펙트 관련 액션
        case external(ExternalAction)
        
        // 화면 전환 및 네비게이션 관련 액션
        case destination(DestinationAction)
        
        enum ViewAction: BindableAction {
            // 바인딩 처리용 액션 (예: isShowTodoSheet 등)
            case binding(BindingAction<State>)
            
            // 캘린더 버튼 탭
            case calendarButtonTapped
            
            // 바텀시트 닫기
            case sheetDismiss
            
            // 바텀시트 열기
            case sheetPresent
            
            // 화면이 나타날 때 (예: onAppear)
            case viewOnAppear
            
            // 할 일 셀을 탭했을 때
            case todoCellTapped(Todo)
            
            // 마감 하루 전 팝업 닫기
            case dismissDdayPopup
            
            // 마감일 설정 버튼 탭
            case setDueDateButtonTapped(Todo)
        }
        
        // 화면 전환(네비게이션 등)에 사용될 액션
        enum DestinationAction {}
        
        // 외부 API 호출 등 비동기 처리를 위한 액션
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
                case .calendarButtonTapped:
                    state.isShowCalendarSheet = true
                    return .none
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
                    return .run { send in
                        try await Task.sleep(for: .seconds(0.3))
                        await send(.todoListAction(.view(.viewonAppear)))
                    }
                default:
                    return .none
                }
                
            default:
                return .none
            }
        }
    }
}
