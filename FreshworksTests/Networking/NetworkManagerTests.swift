//
//  NetworkManagerTests.swift
//  FreshworksTests
//
//  Created by Rodrigo Ruiz Murguia on 27/01/22.
//

@testable import Freshworks
import XCTest

class NetworkManagerTests: XCTestCase {

    var networkManager: NetworkManager!

    override func setUpWithError() throws {
        let config = URLSessionConfiguration.default
        config.protocolClasses = [MockURLProtocol.self]
        let session = URLSession(configuration: config)
        networkManager = NetworkManager(session: session)
    }

    override func tearDownWithError() throws {
        networkManager = nil
    }

    func testMakeRequest() async throws {
        let expectedModel = TestModel(name: "Freshworks")
        let request = try networkManager.request(for: TestEndpoint.myCoolEndpoint,
                                                    with: ["api_key": "1234"],
                                                    using: .get)
        let actualModel: TestModel = try await networkManager.make(request: request)

        XCTAssertEqual(expectedModel, actualModel)
    }

    func testRequestFor() throws {
        let params = Dictionary(uniqueKeysWithValues: (1...5).map { i in ("key\(i)", "value\(i)") } )
        let request = try networkManager.request(for: TestEndpoint.myCoolEndpoint,
                                                    with: params,
                                                    using: .get)

        let url = try XCTUnwrap(request.url)
        XCTAssertEqual(request.httpMethod, NetworkManager.Method.get.rawValue)
        let components = URLComponents(url: url, resolvingAgainstBaseURL: false)
        let items = try XCTUnwrap(components?.queryItems)

        items.forEach { item in
            XCTAssertEqual(item.value, params[item.name], "Expected \(item.name) -> \(String(describing: params[item.name]))")
        }
    }

    func testRequestForInvalid() throws {
        let params: [String: String] = [:]
        let request = try networkManager.request(for: TestEndpoint.myCoolEndpoint,
                                                    with: params,
                                                    using: .get)

        let url = try XCTUnwrap(request.url)
        XCTAssertEqual(request.httpMethod, NetworkManager.Method.get.rawValue)
        let components = URLComponents(url: url, resolvingAgainstBaseURL: false)
        let items = try XCTUnwrap(components?.queryItems)

        XCTAssertTrue(items.isEmpty)
    }
}
