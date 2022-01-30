//
//  FixedImage.swift
//  Freshworks
//
//  Created by Rodrigo Ruiz Murguia on 27/01/22.
//

struct FixedImage: Codable, Hashable {
    let url: String
    let width: String
    let height: String

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        width = try values.decode(String.self, forKey: .width)
        height = try values.decode(String.self, forKey: .height)

        let url = try values.decode(String.self, forKey: .url)
        guard let startRange = url.range(of: "https://"),
              let endRange = url.range(of: ".giphy.com/") else {
                  self.url = url
                  return
              }

        let toReplace = url[startRange.lowerBound ..< endRange.upperBound]
        self.url = url.replacingOccurrences(of: toReplace, with: "https://i.giphy.com/")
    }
}
