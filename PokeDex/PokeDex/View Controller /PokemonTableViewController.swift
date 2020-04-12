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
}
