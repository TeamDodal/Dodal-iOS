//
//  MainViewFeature.swift
//  dnd-12th-2-iOS
//
//  Created by 권석기 on 5/10/25.
//
import Foundation
import ComposableArchitecture

@Reducer
struct MainViewFeature {
    @ObservableState
    struct State {
        /// 할일 추가
        var todo: CreateTodoFeature.State = .addTodoHomeView()
        /// 할일 목록
        var todoList = TodoListFeature.State()
        
        /// 날짜 설정 관련 객체
        private let calendar = Calendar.current
        
        /// 할일 추가 보임 여부
        var isShowAddTodoSheet = false
        /// 최상단 날짜 버튼 눌렀을 때
        var isShowCalendarSheet = false
        var calendarSelectedDate: Date? = Date()
        
        var todosForSelectedDate: [Todo] {
            guard let selectedDate = calendarSelectedDate else { return [] }
            return todoList.todoItems.filter { todo in
                guard let due = todo.dueDate else { return false }
                return Calendar.current.isDate(due, inSameDayAs: selectedDate)
            }
        }
        /// 마감일 하루전 팝업 여부
        var isShowDdayPopup = true
        /// 마감일 하루전 할일 목록
        var dDayTodos: [Todo] {
            return todoList.todoItems.filter { todo in
                guard let dueDate = todo.dueDate else { return false }
                return calendar.isDateInTomorrow(dueDate)
            }
        }
        /// 이번주 할일 목록
        var thisWeekTodos: [Todo] {
            guard let weekInterval = calendar.dateInterval(of: .weekOfYear, for: Date()) else {
                return []
            }
            return todoList.todoItems.filter { todo in
                guard let dueDate = todo.dueDate else { return false }
                return weekInterval.contains(dueDate)
            }.sorted { $0.dueDate ?? $0.createDate < $1.dueDate ?? $1.createDate }
        }
        
        /// 최근 할일 목록
        /// updateDate 기준으로 최신순 정렬
        var recentTodos: [Todo] {
            return todoList.todoItems.sorted { $0.updateDate > $1.updateDate }
        }
    }
    
    enum Action: ViewAction, TCAAction {
        // TCAAction
        case view(ViewAction)
        case external(ExternalAction)
        case destination(DestinationAction)
        
        // SubFeature
        case todo(CreateTodoFeature.Action)
        case todoList(TodoListFeature.Action)
        
        enum ViewAction: BindableAction {
            case binding(BindingAction<State>)
            /// 할일 목록 추가를 보여줌
            case showAddTodoButtonTapped
            /// 뷰가 나타났을때 할일 목록을 불러오기
            case viewOnAppear
            /// 할일 목록을 탭하는 경우
            case todoCellTapped(Todo)
            /// 마감 하루전 팝업 닫기
            case dismissDdayPopup
            /// 마감일 설정 버튼 터치
            case setDueDateButtonTapped(Todo)
            /// 최상단 날짜 버튼 탭
            case calendarButtonTapped
        }
        
        enum DestinationAction {
            case goToTodoDetail(Todo)
        }
        
        enum ExternalAction {}
    }
    
    var body: some Reducer<State, Action> {
        BindingReducer(action: \.view)
        Scope(state: \.todo, action: \.todo) {
            CreateTodoFeature()
        }
        Scope(state: \.todoList, action: \.todoList) {
            TodoListFeature()
        }
        Reduce { state, action in
            switch action {
            case .view(.binding(\.isShowAddTodoSheet)):
                state.todo = .addTodoHomeView()
                return .none
                // MARK: - View
            case let .view(viewAction):
                switch viewAction {
                case .binding:
                    return .none
                case .showAddTodoButtonTapped:
                    state.isShowAddTodoSheet = true
                    return .none
                case .viewOnAppear:
                    return .send(.todoList(.view(.viewonAppear)))
                case let .todoCellTapped(todo):
                    return .send(.destination(.goToTodoDetail(todo)))
                case .dismissDdayPopup:
                    state.isShowDdayPopup = false
                    return .none
                case let .setDueDateButtonTapped(todo):
                    state.isShowAddTodoSheet = true
                    state.todo = .editDueDateHomeView(targetId: todo.id,
                                                      title: todo.title,
                                                      content: todo.content ?? "",
                                                      dueDate: todo.dueDate ?? Date()
                    )
                    return .none
                case .calendarButtonTapped:
                    state.isShowCalendarSheet = true
                    return .none
                }
                // MARK: - TodoView
            case let .todo(todoAction):
                switch todoAction {
                case .view(.addTodoCompleted):
                    state.isShowAddTodoSheet = false
                    return .send(.todoList(.view(.viewonAppear)))
                default:
                    return .none
                }
                // MARK: - TodoListView
            case let .todoList(todoListAction):
                switch todoListAction {
                default:
                    return .none
                }
            default:
                return .none
            }
        }
    }
}
