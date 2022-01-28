//
//  TestEndpoint.swift
//  FreshworksTests
//
//  Created by Rodrigo Ruiz Murguia on 27/01/22.
//

@testable import Freshworks
import Foundation

enum TestEndpoint: String, URLConvertible {
    case myCoolEndpoint = "https://api.coolendpoint.com"
    var url: URL? { URL(string: self.rawValue) }
}
