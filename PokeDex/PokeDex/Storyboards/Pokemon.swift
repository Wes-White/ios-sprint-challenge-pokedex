//
//  Pokemon.swift
//  PokeDex
//
//  Created by Wesley Ryan on 4/10/20.
//  Copyright © 2020 Wesley Ryan. All rights reserved.
//

import Foundation

struct Pokemon: Codable {
    let name: String
    let id: Int
    let types: [Types]
    let abilities: [Ability]
}



struct Types: Codable {
    let type: Type
}

struct Type: Codable {
    let name: String
}

struct Ability: Codable {
    let ability: String
    let name: String
}



/* name
 id:
 types:
 Abilities [] */
