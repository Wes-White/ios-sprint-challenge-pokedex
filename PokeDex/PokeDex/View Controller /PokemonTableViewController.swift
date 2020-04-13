//
//  PokemonTableViewController.swift
//  Pokedex
//
//  Created by Wesley Ryan on 4/11/20.
//  Copyright © 2020 Wesley Ryan. All rights reserved.
//

import UIKit

class PokemonTableViewController: UITableViewController {
    
    let apiController = APIController()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        apiController.loadFromPersistentStore()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        tableView.reloadData()
        print("THIS IS FROM WILL APPEAR", apiController.pokemons.count)
    }
    
    
    
    // MARK: - Table view data source
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return apiController.pokemons.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PokemonCell", for: indexPath)
        cell.textLabel?.text = apiController.pokemons[indexPath.row].name.uppercased()
        return cell
    }
    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            apiController.delete(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            tableView.reloadData()
        }
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "SearchSegue" {
            if let PokeSearchVC = segue.destination as? PokemonDetailSearchViewController {
                PokeSearchVC.apiController = apiController
            }
        } else if segue.identifier == "ShowDetailSegue" {
            if let indexPath = tableView.indexPathForSelectedRow,
                let detailVC = segue.destination as?
                PokeDetailViewController {
                detailVC.pokemon = apiController.pokemons[indexPath.row]
                detailVC.apiController = apiController
            }
        }
    }
}

