//
//  GifCellDelegateMock.swift
//  FreshworksTests
//
//  Created by Rodrigo Ruiz Murguia on 31/01/22.
//

@testable import Freshworks

class GifCellDelegateMock: GifCellDelegate {

    var actions: [GifCellAction] = []

    func performed(gifCellAction: GifCellAction) {
        actions.append(gifCellAction)
    }
}
