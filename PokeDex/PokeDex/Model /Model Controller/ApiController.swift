//
//  ApiController.swift
//  Pokedex
//
//  Created by Wesley Ryan on 4/11/20.
//  Copyright © 2020 Wesley Ryan. All rights reserved.
//
import UIKit
import Foundation


class APIController {
    
    enum APIErrors: Error {
        case serverError
        case unexpectedStatusCode
        case noData
        case decodeError
        case badImageURL
    }
    
    enum HTTPMethod: String {
        case get = "GET"
    }
    
    var pokemons: [Pokemon] = []
    
    var baseUrl = URL(string: "https://pokeapi.co/api/v2/pokemon")!
    
    func searchForPokemon(with searchTerm: String, completion: @escaping (Result<Pokemon, APIErrors>) -> Void) {
        
        let searchUrl = baseUrl.appendingPathComponent("\(searchTerm)")
        
        var request = URLRequest(url: searchUrl)
        request.httpMethod = HTTPMethod.get.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                NSLog("There was an error communicating with the server: \(error)")
                completion(.failure(.serverError))
                return
            }
            
            if let response = response as? HTTPURLResponse,
                response.statusCode != 200 {
                NSLog("Unexpected Status code returned: \(response.statusCode)")
                completion(.failure(.unexpectedStatusCode))
                return
            }
            
            guard let data = data else {
                NSLog("There was an error with the data returned: \(error)")
                completion(.failure(.noData))
                return
            }
            
            let decoder = JSONDecoder()
            do {
                let pokemon = try decoder.decode(Pokemon.self, from: data)
                completion(.success(pokemon))
                
            } catch {
                NSLog("There was an error decoding the data: \(error)")
                completion(.failure(.decodeError))
            }
            
        }.resume()
    }
    
  
}
