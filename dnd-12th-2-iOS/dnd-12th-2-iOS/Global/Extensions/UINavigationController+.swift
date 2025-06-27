//
//  UINavigationController+.swift
//  dnd-12th-2-iOS
//
//  Created by 권석기 on 6/27/25.
//

import UIKit

extension UINavigationController: @retroactive UIGestureRecognizerDelegate {
    // 뒤로가기 스와이프 제스처 가능하도록 수정
    override open func viewDidLoad() {
        super.viewDidLoad()
        interactivePopGestureRecognizer?.delegate = self
    }
    
    public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return viewControllers.count > 1
    }
}
