//
//  TransformErrorUseCase.swift
//  marvel
//
//  Created by stat on 2023/09/19.
//

import Foundation
import RxSwift

/**
 UseCase responsible for transforming errors originating outside the Presentation layer into error types that can be handled within the Presentation layer.
 
 This UseCase is responsible for converting errors from different layers (e.g., Data layer, Domain layer) into Presentation-specific error types. It ensures that errors occurring in lower-level components of the application are mapped to error types that the Presentation layer can effectively handle and communicate to the user or log for debugging purposes.

 Example use cases for this component include:
 - Mapping network errors from the Data layer into user-friendly error messages for display in the UI.
 - Converting domain-specific errors into error states or messages that can be presented to the user.

 By centralizing error transformation in a dedicated UseCase, the application can maintain a consistent and clean error-handling strategy within the Presentation layer, promoting code maintainability and separation of concerns.
 */

enum PresentationError: LocalizedError {
    
    /// Error that should notify by alert to the user.
    case needAlertError(String)
    
    /// Error that can be safely ignored, no additional action is required.
    case noActionRequiredError
    
    var errorDescription: String? {
        switch self {
        case let .needAlertError(errorMessage): return errorMessage
        default: return nil
        }
    }
}

protocol TransformPresentationErrorUseCase {
    
    associatedtype E: Error
    
    func transform(_ anyError: Error) -> PresentationError
    func transform(error: E) -> PresentationError
}

extension TransformPresentationErrorUseCase {
    
    func transform(_ anyError: Error) -> PresentationError {
        if let error = anyError as? E {
            return transform(error: error)
        }
        return .noActionRequiredError
    }
}

struct TransformMVLErrorToPresentationErrorUseCase: TransformPresentationErrorUseCase {
    
    func transform(error: MVLError) -> PresentationError {
        if error.code == 429 {
            return .needAlertError(error.status)
        }
        return .noActionRequiredError
    }
}
