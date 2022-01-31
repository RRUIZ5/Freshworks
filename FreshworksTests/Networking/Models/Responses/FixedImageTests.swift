//
//  FixedImageTests.swift
//  FreshworksTests
//
//  Created by Rodrigo Ruiz Murguia on 30/01/22.
//

import XCTest
@testable import Freshworks

class FixedImageTests: XCTestCase {

    override func setUpWithError() throws {}

    override func tearDownWithError() throws {}

    func testParseLocalJson() throws {
        let data = Data(localGifJson.utf8)
        let giphyData = try JSONDecoder().decode(GiphyData.self, from: data)

        let downsizedMediumUrl = giphyData.images.downsizedMedium.url
        let fixedHeightUrl = giphyData.images.fixedHeight.url
        let fixedWidthUrl = giphyData.images.fixedWidth.url

        let expectedDownsizedMediumUrlFileName = "vtigAcStCqml86RLxfdownsizedMedium"
        let expectedFixedHeightUrlUrlFileName = "vtigAcStCqml86RLxffixedHeight"
        let expectedFixedWidthUrlUrlFileName = "vtigAcStCqml86RLxffixedWidth"

        assertLocalURL(actual: downsizedMediumUrl, expectedFileName: expectedDownsizedMediumUrlFileName)
        assertLocalURL(actual: fixedHeightUrl, expectedFileName: expectedFixedHeightUrlUrlFileName)
        assertLocalURL(actual: fixedWidthUrl, expectedFileName: expectedFixedWidthUrlUrlFileName)
    }

    private func assertLocalURL(actual: String,
                                expectedFileName: String,
                                file: StaticString = #file,
                                line: UInt = #line) {

        let nonExpectedHttps = "https://"
        let expectedFileScheme = "file:///"
        let expectedDocumentsPath = "/Documents/"
        let url = URL(string: actual)

        XCTAssertNotNil(url)
        XCTAssertTrue(actual.contains(expectedFileScheme), file: file, line: line)
        XCTAssertTrue(actual.contains(expectedDocumentsPath), file: file, line: line)
        XCTAssertTrue(actual.contains(expectedFileName), file: file, line: line)
        XCTAssertFalse(actual.contains(nonExpectedHttps), file: file, line: line)

    }

    func testParseGiphyJson() throws {
        let data = Data(gifyGifJson.utf8)
        let giphyData = try JSONDecoder().decode(GiphyData.self, from: data)

        let downsizedMediumUrl = giphyData.images.downsizedMedium.url
        let fixedHeightUrl = giphyData.images.fixedHeight.url
        let fixedWidthUrl = giphyData.images.fixedWidth.url

        assertGiphyURL(actual: downsizedMediumUrl)
        assertGiphyURL(actual: fixedHeightUrl)
        assertGiphyURL(actual: fixedWidthUrl)

    }

    private func assertGiphyURL(actual: String,
                                file: StaticString = #file,
                                line: UInt = #line) {

        let expectedPrefix = "https://i.giphy.com"
        let url = URL(string: actual)

        XCTAssertTrue(actual.hasPrefix(expectedPrefix), file: file, line: line)
        XCTAssertNotNil(url, file: file, line: line)
    }
}
