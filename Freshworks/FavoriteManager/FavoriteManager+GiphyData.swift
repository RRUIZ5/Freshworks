//
//  FavoriteManager+GiphyData.swift
//  Freshworks
//
//  Created by Rodrigo Ruiz Murguia on 30/01/22.
//

import Foundation

extension GiphyData {

    private static func parse(writtenGif: WrittenGif, originalGif: GiphyData) -> FixedImage {
        switch writtenGif.type {
            case .fixedHeight:
                return FixedImage(url: writtenGif.url.absoluteString,
                                  width: originalGif.images.fixedHeight.width,
                                  height: originalGif.images.fixedHeight.height)
            case .downsizedMedium:
                return FixedImage(url: writtenGif.url.absoluteString,
                                  width: originalGif.images.downsizedMedium.width,
                                  height: originalGif.images.downsizedMedium.height)
            case .fixedWidth:
                return FixedImage(url: writtenGif.url.absoluteString,
                                  width: originalGif.images.fixedWidth.width,
                                  height: originalGif.images.fixedWidth.height)
        }
    }

    init?(writtenGifs: [WrittenGif], originalGif: GiphyData) {
        guard
            let fixedHeight = writtenGifs.first(where: { written in written.type == .fixedHeight }),
            let fixedWidth = writtenGifs.first(where: { written in written.type == .fixedWidth }),
            let downsizedMedium = writtenGifs.first(where: { written in written.type == .downsizedMedium })
        else { return nil }

        let images = Images(fixedHeight: GiphyData.parse(writtenGif: fixedHeight, originalGif: originalGif),
                            fixedWidth: GiphyData.parse(writtenGif: fixedWidth, originalGif: originalGif),
                            downsizedMedium: GiphyData.parse(writtenGif: downsizedMedium, originalGif: originalGif))
        self.id = originalGif.id
        self.title = originalGif.title
        self.images = images
    }

    func generateDownloadTasks() -> [DownloadGifTask] {
        let images = [images.fixedWidth, images.downsizedMedium, images.fixedHeight]
        let types: [GifType] = [.fixedWidth, .downsizedMedium, .fixedHeight]

        return zip(images, types)
            .compactMap { image, type in
                guard let url = URL(string: image.url) else { return nil }
                return DownloadGifTask(id: id, url: url, type: type)
            }
    }
}
