//
//  PokemonDetailSearchViewController.swift
//  Pokedex
//
//  Created by Wesley Ryan on 4/11/20.
//  Copyright © 2020 Wesley Ryan. All rights reserved.
//

import UIKit

class PokemonDetailSearchViewController: UIViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var pokeImageVIew: UIImageView!
    @IBOutlet weak var idLabel: UILabel!
    @IBOutlet weak var typesLabel: UILabel!
    @IBOutlet weak var abilitiesLabel: UILabel!
    @IBOutlet weak var saveButton: UIButton!
    
    let apiController = APIController()
    var pokemon: Pokemon?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hideLables()
        
        
        searchBar.delegate = self
    }
    
    
    
    func hideLables() {
        nameLabel.isHidden = true
        pokeImageVIew.isHidden = true
        idLabel.isHidden = true
        abilitiesLabel.isHidden = true
        typesLabel.isHidden = true
        saveButton.isHidden = true
    }
    
    func updateViews() {
        guard let pokemon = pokemon else { return }
        var types = ""
        var abilities = ""
        
        if pokemon.types.count > 1 {
            for character in pokemon.types {
                types += "\(character.type.name), "
            }
        } else {
            types = pokemon.types[0].type.name
        }
        
        if pokemon.abilities.count > 1 {
            for character in pokemon.abilities {
                abilities += "\(character.ability.name)"
            }
        } else {
            pokemon.abilities[0].ability.name
        }
        
        nameLabel.text = pokemon.name
        idLabel.text = "ID: \(pokemon.id)"
        typesLabel.text = "Types: \(types)"
        abilitiesLabel.text = "Abilities: \(abilities)"
        title = pokemon.name.uppercased()
        
        //MARK: Show Labels (hide searchBar)
        
        nameLabel.isHidden = false
        pokeImageVIew.isHidden = false
        idLabel.isHidden = false
        abilitiesLabel.isHidden = false
        saveButton.isHidden = false
        searchBar.isHidden = true
    }
    
    //MARK: Save pokemon to UITableView
    @IBAction func saveButtonTapped(_ sender: Any) {
        guard let pokemon = pokemon else { return }
        print("THIS IS My NEW Pokemon", pokemon)
        apiController.pokemons.append(pokemon)
        print("This is my new array", apiController.pokemons)
        navigationController?.popViewController(animated: true)
    }
}




extension PokemonDetailSearchViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let searchTerm = searchBar.text else { return }
        apiController.searchForPokemon(with: searchTerm.lowercased()) { (result) in
            
            do {
                let pokemon = try result.get()
                self.pokemon = pokemon
                DispatchQueue.main.async {
                    self.updateViews()
                }
                
                self.apiController.getPokeImage(urlString: pokemon.sprites.front_default, completion: { (result) in
                    if let pokeImage = try? result.get() {
                        DispatchQueue.main.async {
                            self.pokeImageVIew.image = pokeImage
                            self.updateViews()
                        }
                    }
                })
                
            } catch {
                if let error = error as? APIController.APIErrors {
                    switch error {
                    case .serverError:
                        NSLog("There was an error from the server.")
                    case .unexpectedStatusCode:
                        NSLog("There was an unexpected status code from the server.")
                    case .decodeError:
                        NSLog("There was an error decoding the data.")
                    case .noData:
                        NSLog("There was an error with the data.")
                    case .badImageURL:
                        NSLog("Error corrput or missing Image URL.")
                    }
                }
            }
        }
    }
}
