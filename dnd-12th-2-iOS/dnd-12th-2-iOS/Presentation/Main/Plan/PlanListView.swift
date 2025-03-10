//
//  PlanListVIew.swift
//  dnd-12th-2-iOS
//
//  Created by 권석기 on 3/2/25.
//

import SwiftUI
import UIKit
import Combine
import ComposableArchitecture

final class ScrollOffsetObserve: ObservableObject {
    @Published var offset: CGFloat = 0
}

struct PlanListVIew: View {
    @Binding var isScrolling: Bool
    let store: StoreOf<FetchPlan>
    @StateObject var scrollObserve = ScrollOffsetObserve()
    let publisher = CurrentValueSubject<CGFloat, Never>(0)
    @State var offsetDict: [String: CGFloat] = [:]
    
    var body: some View {
        WithPerceptionTracking {
            ScrollViewReader { proxy in
                WithPerceptionTracking {
                    ScrollViewWrapper(isScrolling: $isScrolling, publisher: scrollObserve.$offset.eraseToAnyPublisher()) {
                        VStack(spacing: 24) {
                            ForEach(store.planGroup, id: \.self) { planDictionary in
                                ForEach(Array(planDictionary.keys), id: \.self.key) { section in
                                    Text(section.date)
                                        .bodyMediumMedium()
                                        .alignmentLeading()
                                        .foregroundStyle(Color.gray500)
                                        .background(GeometryReader { geo in
                                            Color.clear
                                                .onAppear {
                                                    offsetDict[section.key] = geo.frame(in: .named("scroll")).minY
                                                }
                                        })
                                    LazyVStack(spacing: 8) {
                                        ForEach(planDictionary[section] ?? [], id: \.self) { plan in
                                            DDResultRow(planInfo: plan, action: {})
                                        }
                                    }
                                }
                            }
                        }
                        .padding(.horizontal, 16)
                        .padding(.top, 11)
                        .coordinateSpace(name: "scroll")
                    }
                    
                    .id(store.renderKey)
                    .onChange(of: store.renderKey) { _ in
                        offsetDict.removeAll()
                    }
                    .onChange(of: store.scrollKey) { newScrollKey in
                        if let scrollOffset = offsetDict[newScrollKey] {
                            scrollObserve.offset = scrollOffset
                            HapticManager.shared.hapticImpact(style: .soft)
                        }
                    }
                }
            }
            .ignoresSafeArea(.container, edges: [.bottom, .top])
            .overlay(alignment: .top) {
                Divider()
                    .frame(width: UIScreen.screenWidth)
            }
            .overlay(alignment: .bottom) {
                if !store.isTipHidden {
                    TipBubble()
                        .offset(x: 0, y: -70)
                        .padding(.horizontal, 16)
                }
                
            }
        }
    }
}

struct ScrollViewWrapper<Content: View>: UIViewRepresentable {
    @Binding var isScrolling: Bool
    let content: Content
    let publisher: AnyPublisher<CGFloat, Never>
    let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator = false
        scrollView.alwaysBounceVertical = true
        return scrollView
    }()
    
    init(isScrolling: Binding<Bool>, publisher: AnyPublisher<CGFloat, Never>,  @ViewBuilder content: () -> Content) {
        self._isScrolling = isScrolling
        self.publisher = publisher
        self.content = content()
    }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(parent: self)
    }
    
    func makeUIView(context: Context) -> UIScrollView {
        let hostingController = UIHostingController(rootView: content)
        hostingController.view.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(hostingController.view)
        scrollView.delegate = context.coordinator
        scrollView.backgroundColor = .customBackground
        hostingController.view.backgroundColor = .customBackground
        
        NSLayoutConstraint.activate([
            hostingController.view.topAnchor.constraint(equalTo: scrollView.topAnchor),
            hostingController.view.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            hostingController.view.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            hostingController.view.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            hostingController.view.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
        ])
        
        scrollView.contentSize = CGSize(width: scrollView.frame.width, height: hostingController.view.frame.height)
        
        publisher
            .receive(on: DispatchQueue.main)
            .dropFirst()
            .sink { offset in
                UIView.animate(withDuration: 0.4) {
                    scrollView.contentOffset = .init(x: 0, y: offset - 10)
                }
            }
            .store(in: &context.coordinator.bag)
        return scrollView
    }
    
    func updateUIView(_ uiView: UIScrollView, context: Context) {
        // 내용이 업데이트 될 때마다 contentSize를 다시 설정
        uiView.contentSize = CGSize(width: uiView.frame.width, height: uiView.subviews.first?.frame.height ?? 0)
    }
    
    class Coordinator: NSObject, UIScrollViewDelegate {
        var parent: ScrollViewWrapper
        var bag = Set<AnyCancellable>()
        
        init(parent: ScrollViewWrapper) {
            self.parent = parent
            super.init()
        }
        
        func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
            DispatchQueue.main.async {
                self.parent.isScrolling = true
            }
        }
        
        func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
            DispatchQueue.main.async {
                self.parent.isScrolling = false
            }
        }
        
        func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
            if !decelerate {
                DispatchQueue.main.async {
                    self.parent.isScrolling = false
                }
            }
        }
    }
    
}

