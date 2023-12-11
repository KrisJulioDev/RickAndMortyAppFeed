//
//  FeedImagePresenter.swift
//  RickAndMortyApp
//
//  Created by Khristoffer Julio on 12/11/23.
//

import RickAndMortyFeed

final class FeedImagePresenter {
    static func map(_ image: CharacterItem) -> FeedImageViewModel {
        FeedImageViewModel(name: image.name, status: image.status, type: image.type, species: image.species)
    }
}
