//
//  PokeDetailViewController.swift
//  Pokedex
//
//  Created by Wesley Ryan on 4/12/20.
//  Copyright © 2020 Wesley Ryan. All rights reserved.
//

import UIKit

class PokeDetailViewController: UIViewController {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var pokeImage: UIImageView!
    @IBOutlet weak var idLabel: UILabel!
    @IBOutlet weak var typesLabel: UILabel!
    @IBOutlet weak var abilitiesLabel: UILabel!
    
    
    var apiController: APIController?
    var pokemon: Pokemon?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateViews()
        
    }
    
    func updateViews() {
        guard let pokemon = pokemon else { return }
        
        apiController?.getPokeImage(urlString: pokemon.sprites.front_default, completion: { (result) in
            if let image = try? result.get() {
                DispatchQueue.main.async {
                    self.pokeImage.image = image
                }
            }
        })
        
        
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
    }
}
