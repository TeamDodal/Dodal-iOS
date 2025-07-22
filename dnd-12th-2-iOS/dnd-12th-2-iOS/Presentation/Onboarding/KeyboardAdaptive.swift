//
//  KeyboardAdaptive.swift
//  dnd-12th-2-iOS
//
//  Created by 박우연 on 7/8/25.
//

import SwiftUI
import Combine

struct KeyboardAdaptive: ViewModifier {
  @State private var keyboardHeight: CGFloat = 0
  
  private let keyboardWillShow = NotificationCenter.default
    .publisher(for: UIResponder.keyboardWillShowNotification)
    .compactMap { notification in
      notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect
    }
    .map { rect in
      rect.height
    }
  
  private let keyboardWillHide = NotificationCenter.default
    .publisher(for: UIResponder.keyboardWillHideNotification)
    .map { _ in CGFloat(0) }
  
  func body(content: Content) -> some View {
    content
      .padding(.bottom, keyboardHeight)
      .onReceive(
        Publishers.Merge(keyboardWillShow, keyboardWillHide)
      ) { height in
        withAnimation(.easeInOut) {
          self.keyboardHeight = height
        }
      }
  }
}

extension View {
  func keyboardAdaptive() -> some View {
    ModifiedContent(content: self, modifier: KeyboardAdaptive())
  }
}
