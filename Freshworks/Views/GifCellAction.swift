//
//  GifCellAction.swift
//  Freshworks
//
//  Created by Rodrigo Ruiz Murguia on 29/01/22.
//

enum GifCellAction: Equatable {
    case favorited(gif: GiphyData)
    case unfavorited(gif: GiphyData)
}
