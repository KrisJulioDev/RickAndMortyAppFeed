//
//  JSON+Helpers.swift
//  RickAndMortyFeedTests
//
//  Created by Khristoffer Julio on 12/5/23.
//

import Foundation
import RickAndMortyFeed

func someJSONData() -> (data: Data, model: CharacterItem) {
    let model = CharacterItem(
        id: 361,
        name: "Toxic Rick",
        status: "Dead", 
        species: "Humanoid",
        type: "Rick's Toxic Side",
        gender: "Male",
        image: URL(string: "https://rickandmortyapi.com/api/character/avatar/361.jpeg")!
    )
    
    let json: [String : Any] = ["info":
        [
            "count": 826,
            "pages": 42,
            "next": "https://rickandmortyapi.com/api/character/?page=3",
            "prev": "https://rickandmortyapi.com/api/character/?page=2"
        ],
     "results": [
            [
                "id": model.id,
                "name": model.name,
                "status": model.status,
                "species": model.species,
                "type": model.type,
                "gender": model.gender,
                "image": model.image.absoluteString
            ]
        ]
    ]
 
    let data = try! JSONSerialization.data(withJSONObject: json)
    return (data, model)
}

func emptyJSONData() -> Data {
    let json: [String: Any] = ["info":
        [
            "count": 826,
            "pages": 42,
            "next": "https://rickandmortyapi.com/api/character/?page=3",
            "prev": "https://rickandmortyapi.com/api/character/?page=2"
        ],
        "results": []
    ]
 
    return try! JSONSerialization.data(withJSONObject: json)
}
