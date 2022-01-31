//
//  GifCellViewModelTests.swift
//  FreshworksTests
//
//  Created by Rodrigo Ruiz Murguia on 30/01/22.
//

@testable import Freshworks
import UIKit
import XCTest

class GifCellViewModelTests: XCTestCase {

    var viewModel: GifCellViewModel!
    var giphyData: GiphyData!
    var delegate: GifCellDelegateMock!

    override func setUpWithError() throws {
        let data = Data(localGifJson.utf8)
        giphyData = try JSONDecoder().decode(GiphyData.self, from: data)
        delegate = GifCellDelegateMock()

    }

    override func tearDownWithError() throws {
        viewModel = nil
        giphyData = nil
        delegate = nil
    }

    func testBackgroundImageFavorited() throws {
        try assertBackgroundImagesAreEqual(isFavorited: true, systemImageName: "heart.fill")
    }

    func testBackgroundImageUnfavorited() throws {
        try assertBackgroundImagesAreEqual(isFavorited: false, systemImageName: "heart")
    }

    private func assertBackgroundImagesAreEqual(isFavorited: Bool,
                                                systemImageName: String,
                                                file: StaticString = #file,
                                                line: UInt = #line)
    throws {
        viewModel = GifCellViewModel(gif: giphyData, isFavorited: isFavorited, delegate: delegate)
        let actualImage = try XCTUnwrap(viewModel.backgroundImage)
        let expectedImage = UIImage(systemName: systemImageName)?.withRenderingMode(.alwaysOriginal)

        XCTAssertEqual(actualImage, expectedImage, file: file, line: line)
    }

    func testFavoritedToggledFalse() throws {
        let expectedAction: GifCellAction = .favorited(gif: giphyData)
        try assertCorrectFavoritedEventIsSent(isFavorited: false, expectedAction: expectedAction)
    }

    func testFavoritedToggledTrue() throws {

        let expectedAction: GifCellAction = .unfavorited(gif: giphyData)
        try assertCorrectFavoritedEventIsSent(isFavorited: true, expectedAction: expectedAction)
    }

    private func assertCorrectFavoritedEventIsSent(isFavorited: Bool,
                                                   expectedAction: GifCellAction,
                                                   file: StaticString = #file,
                                                   line: UInt = #line)
    throws {
        viewModel = GifCellViewModel(gif: giphyData, isFavorited: isFavorited, delegate: delegate)
        viewModel.favoritedToggled()

        let delegateActions = delegate.actions
        XCTAssertEqual(delegateActions.count, 1, file: file, line: line)
        let actualAction = try XCTUnwrap(delegateActions.first, file: file, line: line)

        XCTAssertEqual(expectedAction, actualAction, file: file, line: line)
    }

    func testCreateRequest() throws {
        viewModel = GifCellViewModel(gif: giphyData, isFavorited: true, delegate: delegate)
        let actualRequest = try XCTUnwrap(viewModel.request)

        let expectedUrl = try XCTUnwrap(URL(string: giphyData.images.fixedHeight.url))
        let expectedRequest = URLRequest(url: expectedUrl)

        XCTAssertEqual(actualRequest, expectedRequest)
    }

    func testFavoritedToggledTwice() {
        viewModel = GifCellViewModel(gif: giphyData, isFavorited: true, delegate: delegate)
        viewModel.favoritedToggled()
        viewModel.favoritedToggled() // Simulate two "fast" taps on heart button

        let delegateActions = delegate.actions
        XCTAssertEqual(delegateActions.count, 1)
    }

    func testWrongFixedHeight() {
        let wrongData = GiphyData(id: giphyData.id,
                                  title: giphyData.title,
                                  images: Images(fixedHeight: FixedImage(url: "Bad url", width: "Bar width", height: "Bad heigth"),
                                                 fixedWidth: giphyData.images.fixedWidth,
                                                 downsizedMedium: giphyData.images.downsizedMedium))

        viewModel = GifCellViewModel(gif: wrongData, isFavorited: true, delegate: delegate)
        let request = viewModel.request
        XCTAssertNil(request)
    }

}
