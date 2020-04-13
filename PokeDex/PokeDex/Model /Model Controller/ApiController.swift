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
    
    var pokemons: [Pokemon] = [Pokemon(name: "pikachu", id: 25, sprites: Pokedex.Sprite(front_default: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/25.png"), types: [Pokedex.arrayOfTypes(type: Pokedex.Type(name: "electric"))], abilities: [Pokedex.arrayOfAbilities(ability: Pokedex.temp(name: "lightning-rod")), Pokedex.arrayOfAbilities(ability: Pokedex.temp(name: "static"))])]
    
    var baseUrl = URL(string: "https://pokeapi.co/api/v2/pokemon")!
    
    func delete(at index: Int) {
        pokemons.remove(at: index)
    }
    
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
    
    func getPokeImage(urlString: String, completion: @escaping (Result<UIImage, APIErrors>) -> Void) {
        
        guard let imageUrl = URL(string: urlString) else {
            NSLog("There was an error with the imageURL)")
            completion(.failure(.badImageURL))
            return
        }
        var request = URLRequest(url: imageUrl)
        request.httpMethod = HTTPMethod.get.rawValue
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                NSLog("There was an error communicating with the server: \(error)")
                completion(.failure(.serverError))
                return
            }
            
            guard let data = data else {
                NSLog("There was an error from the returned data: \(error)")
                completion(.failure(.noData))
                return
            }
            
            guard let image = UIImage(data: data) else {
                NSLog("There was an error with the image file returned: \(error)")
                completion(.failure(.noData))
                return
            }
            completion(.success(image))
        }.resume()
    }
    
    //MARK: LOAD AND SAVE DATA FOR STRETCH
    
    func loadFromPersistentStore() {
        do {
            guard let fileURL = pokedexURL else { return }
            let pokemonSavedData = try Data(contentsOf: fileURL)
            let pListDecoder = PropertyListDecoder()
            self.pokemons = try pListDecoder.decode([Pokemon].self, from: pokemonSavedData)
        } catch {
            print("There was an error retreiving your Pokedex: \(error)")
        }
    }
    
    func saveToPersistentStore() {
        
        let plistEncoder = PropertyListEncoder()
        
        do  {
            let pokemonData = try plistEncoder.encode(pokemons)
            guard let fileURL = pokedexURL else { return }
            try pokemonData.write(to: fileURL)
        } catch {
            print("There was an error saving your data: \(error)")
        }
    }
    
    var pokedexURL: URL? {
        let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
        let fileName = "pokedex.plist"
        return documentDirectory?.appendingPathComponent(fileName)
    }
}
