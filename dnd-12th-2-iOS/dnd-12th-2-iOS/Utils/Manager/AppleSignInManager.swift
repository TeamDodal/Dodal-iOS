//
//  AppleSignInManager.swift
//  dnd-12th-2-iOS
//
//  Created by Allie on 3/27/25.
//

import Foundation
import AuthenticationServices

import ComposableArchitecture

final class AppleSignInManager: NSObject, ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding, ObservableObject {
    var onAuthorizationSuccess: ((String) -> Void)?
    var onAuthorizationFailure: ((Error) -> Void)?
    
    func startSignInWithAppleFlow() {
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email]
        
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = self
        authorizationController.performRequests()
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        guard let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential,
              let authorizationCodeData = appleIDCredential.authorizationCode,
              let authorizationCode = String(data: authorizationCodeData, encoding: .utf8) else {
            onAuthorizationFailure?(NSError(domain: "AppleSignIn", code: -1, userInfo: [NSLocalizedDescriptionKey: "Failed to get authorization code"]))
            return
        }
        
        onAuthorizationSuccess?(authorizationCode)
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        onAuthorizationFailure?(error)
    }
    
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return UIApplication.shared.windows.first { $0.isKeyWindow } ?? UIWindow()
    }
}

extension AppleSignInManager: DependencyKey {
    static let liveValue = AppleSignInManager()
}

extension DependencyValues {
    var appleSignInManager: AppleSignInManager {
        get { self[AppleSignInManager.self] }
        set { self[AppleSignInManager.self] = newValue }
    }
}
