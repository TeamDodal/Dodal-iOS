//
//  TodoSheetView.swift
//  dnd-12th-2-iOS
//
//  Created by 권석기 on 6/20/25.
//

import SwiftUI
import ComposableArchitecture

struct TodoSheetView: View {
    
    @Perception.Bindable var store: StoreOf<TodoSheetFeature>
    @FocusState private var focusedField: Field?
    
    var body: some View {
        WithPerceptionTracking {
            VStack {
                TextField("eg.운동하기", text: $store.title)
                    .font(.pretendard(size: 22, weight: .semibold))
                    .foregroundStyle(.black)
                    .padding(.top, 12)
                    .padding(.horizontal, 16)
                    .focused($focusedField, equals: .title)
                    .disabled(!store.isEditing)
                TextEditor(text: $store.content)
                    .frame(height:64)
                    .overlay(alignment: .topLeading) {
                        Text("설명")
                            .font(.pretendard(size: 14, weight: .regular))
                            .foregroundStyle(.gray400)
                            .offset(x: 2, y: 8)
                            .opacity(store.content.isEmpty ? 1 : 0)
                    }
                    .padding(.leading, 16)
                    .disabled(!store.isEditing)
                if store.isEditing {
                    HStack {
                        DDImageButton(type: .dueDate, text: "마감일") {
                            
                        }
                        Spacer()
                        Button(action: {
                            
                        }, label: {
                            Text("생성하기")
                                .font(.pretendard(size: 16, weight: .medium))
                                .foregroundStyle(.gray0)
                                .padding(.horizontal, 8)
                                .frame(height: 34)
                                .background(.mainBlue)
                                .cornerRadius(8)
                        })
                    }
                    .padding(.vertical, 12)
                    .padding(.horizontal, 16)
                    .overlay(alignment: .top, content: {
                        Divider()
                    })
                } else {
                    VStack(spacing: 8) {
                        DDButton(type: .secondary, title: "삭제", action: {
                            store.send(.editingCanelled)
                        })
                        
                        DDButton(type: .primary, title: "계속편집", action: {
                            store.send(.editingChanged(true))
                        })
                    }
                    .padding(.horizontal, 16)
                }
                Spacer()
            }
            .background(.white)
            .onChange(of: store.isEditing) { isEditing in
                if isEditing {
                    focusedField = .title
                } else {
                    focusedField = nil
                }
            }
            .onAppear {
                focusedField = .title
            }
        }
    }
}

//#Preview {
//    TodoSheetView()
//}
