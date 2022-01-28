//
//  NetworkError.swift
//  Freshworks
//
//  Created by Rodrigo Ruiz Murguia on 27/01/22.
//

import Foundation

struct NetworkError: Error, LocalizedError, CustomStringConvertible {
    let message : String

    var description: String { message }
    var errorDescription: String { message }
}
