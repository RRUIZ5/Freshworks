//
//  GifCellDelegate.swift
//  Freshworks
//
//  Created by Rodrigo Ruiz Murguia on 30/01/22.
//

protocol GifCellDelegate: AnyObject {
    func performed(gifCellAction: GifCellAction)
}
