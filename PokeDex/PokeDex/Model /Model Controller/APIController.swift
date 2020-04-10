//
//  APIController.swift
//  PokeDex
//
//  Created by Wesley Ryan on 4/10/20.
//  Copyright © 2020 Wesley Ryan. All rights reserved.
//

import Foundation


class APIController {
    
    enum APIErrors: Error {
        case noData
    }
    
    enum HTTPMethod: String {
        case get = "GET"
    }
    
    let baseURL = URL(string: "https://pokeapi.co/api/v2")!
    
    
    var pokemon: [Pokemon] = []
    
    
}
