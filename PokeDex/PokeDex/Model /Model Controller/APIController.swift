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
        case serverError
        case unexpectedStatusCode
        case decodingError
        
    }
    
    enum HTTPMethod: String {
        case get = "GET"
    }
    
    let baseURL = URL(string: "https://pokeapi.co/api/v2")!
    lazy var searchURL = baseURL.appendingPathComponent("/pokemon\(searchHolder)")
    
    //placeholder
    var searchHolder = ""
    
    var pokemon: [Pokemon] = []
    
    func searchPokemon(with searchTerm: String,  completion: @escaping (Result<Pokemon,APIErrors>) -> Void) {
        // build a request
        
        var request = URLRequest(url: searchURL)
        request.httpMethod = HTTPMethod.get.rawValue
        
        URLSession.shared.dataTask(with: request) {(data, response, error) in
            if let error = error {
                NSLog("There was an error from the server: \(error)")
                completion(.failure(.serverError))
                return
            }
            
            if let response = response as? HTTPURLResponse,
                response.statusCode != 200 {
                NSLog("There was an unexpected response from the server: \(error)")
                completion(.failure(.unexpectedStatusCode))
                return
            }
            guard let data = data else {
                NSLog("There was an error with the data return from the server: \(error)")
                completion(.failure(.noData))
                return
            }
            
            do {
                let pokeResponse = try JSONDecoder().decode(Pokemon.self, from: data)
                self.pokemon.append(pokeResponse)
                completion(.success(pokeResponse))
            } catch {
                NSLog("There was an erro decoding the data: \(error)")
                completion(.failure(.decodingError))
                
            }
        }.resume()
    }
}
