//
//  Pokemon.swift
//  Pokedex
//
//  Created by Wesley Ryan on 4/11/20.
//  Copyright © 2020 Wesley Ryan. All rights reserved.
//

import Foundation


struct Pokemon: Codable {
    let name: String
    let id: Int
    let sprites: Sprite
    let types: [arrayOfTypes]
    let abilities: [arrayOfAbilities]
}

struct Sprite: Codable {
    let front_default: String
}

struct arrayOfTypes: Codable {
    let type: Type
}

struct Type: Codable {
    let name: String
}

struct arrayOfAbilities: Codable {
    let ability: temp
}

struct temp: Codable {
    let name: String
}
