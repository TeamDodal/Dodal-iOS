

import SwiftUI

struct DDBottomSheet<ContentView: View>: ViewModifier {
    @Binding var isPresented: Bool
    let contentView: () -> ContentView
    
    func body(content: Content) -> some View {
        content
            .fullScreenCover(isPresented: $isPresented) {
                ZStack(alignment: .bottom) {
                    Color.black.opacity(0.75).ignoresSafeArea(.all)
                        contentView()
                }
                .background(ClearBackground())
            }
            .transaction { transaction  in
                transaction.disablesAnimations = true
            }
    }
}

extension View {
    func bottomSheet<Content: View>(isPresented: Binding<Bool>, content: @escaping () -> Content) -> some View {
        modifier(DDBottomSheet(isPresented: isPresented, contentView: content))
    }
}

struct ClearBackground: UIViewRepresentable {
    func makeUIView(context: Context) -> UIView {
        return InnerView()
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {
    }
    
    private class InnerView: UIView {
        override func didMoveToWindow() {
            super.didMoveToWindow()
            
            superview?.superview?.backgroundColor = .clear
        }
        
    }
}
