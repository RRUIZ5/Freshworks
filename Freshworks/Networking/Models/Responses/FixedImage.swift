//
//  FixedImage.swift
//  Freshworks
//
//  Created by Rodrigo Ruiz Murguia on 27/01/22.
//

import Foundation

struct FixedImage: Codable, Hashable {
    let url: String
    let width: String
    let height: String

    init(url: String, width: String, height: String){
        self.url = url
        self.width = width
        self.height = height
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        width = try values.decode(String.self, forKey: .width)
        height = try values.decode(String.self, forKey: .height)

        let url = try values.decode(String.self, forKey: .url)

        guard let parsedURL = URL(string: url) else {
            self.url = url
            return
        }

        if parsedURL.isFileURL { // assume local-favorited url

            let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
            let base = paths[0]
            let lastComponent = parsedURL.lastPathComponent

            self.url = base.appendingPathComponent(lastComponent).absoluteString

        } else { // assume giphy url

            guard let startRange = url.range(of: "https://"),
                  let endRange = url.range(of: ".giphy.com/") else {
                      self.url = url
                      return
                  }

            let toReplace = url[startRange.lowerBound ..< endRange.upperBound]
            self.url = url.replacingOccurrences(of: toReplace, with: "https://i.giphy.com/")
        }
    }
}
