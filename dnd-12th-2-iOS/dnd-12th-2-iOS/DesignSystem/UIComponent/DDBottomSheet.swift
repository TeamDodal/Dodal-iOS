

import SwiftUI

struct DDBottomSheet<ContentView: View>: ViewModifier {
    @Binding var isPresented: Bool
    let contentView: () -> ContentView
    var onDismiss: (()->Void)?
    var topSpacing: CGFloat = 0
    
    func body(content: Content) -> some View {
        content
            .fullScreenCover(isPresented: $isPresented) {
                ZStack(alignment: .bottom) {
                    Color.black.opacity(0.75).ignoresSafeArea(edges: .top)
                        .onTapGesture {
                            onDismiss?()
                        }
                    
                    VStack(spacing: 0) {
                        Spacer().frame(height: topSpacing)
                        contentView()
                            .frame(maxWidth: .infinity)
                            .background(.white)
                            .clipShape(
                                .rect(
                                    topLeadingRadius: 12,
                                    bottomLeadingRadius: 0,
                                    bottomTrailingRadius: 0,
                                    topTrailingRadius: 12
                                )
                            )
                    }
                }
                .background(ClearBackground())
            }
            .transaction { transaction  in
                transaction.disablesAnimations = true
            }
    }
}

extension View {
    func bottomSheet<Content: View>(
        isPresented: Binding<Bool>,
        topSpacing: CGFloat = 0,
        content: @escaping () -> Content,
        onDismiss: (() -> Void)? = nil
    ) -> some View {
        modifier(DDBottomSheet(isPresented: isPresented, contentView: content, onDismiss: onDismiss, topSpacing: topSpacing))
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
