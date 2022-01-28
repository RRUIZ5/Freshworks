//
//  MockURLProtocol.swift
//  FreshworksTests
//
//  Created by Rodrigo Ruiz Murguia on 27/01/22.
//

import Foundation
@testable import Freshworks

class MockURLProtocol: URLProtocol {

    override class func canInit(with request: URLRequest) -> Bool { true }

    override class func canonicalRequest(for request: URLRequest) -> URLRequest { request }

    override func startLoading() {

        guard let urlString = request.url?.absoluteString,
              urlString.contains(TestEndpoint.myCoolEndpoint.rawValue),
              let url = URL(string: urlString),
              let response = HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil)
        else {
            let error = NetworkError(message: "Only \(TestEndpoint.myCoolEndpoint.rawValue) works for testing")
            client?.urlProtocol(self, didFailWithError: error)
            return
        }

        let model = TestModel(name: "Freshworks")
        let encoder = JSONEncoder()

        client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)

        do {
            let data = try encoder.encode(model)
            client?.urlProtocol(self, didLoad: data)
        } catch {
            client?.urlProtocol(self, didFailWithError: error)
        }

        client?.urlProtocolDidFinishLoading(self)
    }

    override func stopLoading() {

    }
}
