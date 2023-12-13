//
//  ResourceErrorViewModel.swift
//  RickAndMortyApp
//
//  Created by Khristoffer Julio on 12/12/23.
//

import Foundation

public struct ResourceErrorViewModel {
    public let errorMessage: String?
    
    public static func noError() -> ResourceErrorViewModel {
        .init(errorMessage: nil)
    }
    
    public static func error(message: String) -> ResourceErrorViewModel {
        .init(errorMessage: message)
    }
}
