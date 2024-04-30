//
//  RepTableViewController.swift
//  APIProject
//
//  Created by Jordan Fraughton on 4/25/24.
//

import UIKit

class RepsTableViewController: UITableViewController {
    @IBOutlet weak var searchBar: UISearchBar!
    
    var repController = RepController()
    
    var reps = [Rep]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Representatives"
    }
    
    func fetchMatchingReps() {
        self.reps = []
        self.tableView.reloadData()
        
        let zipCode = searchBar.text ?? ""
        
        if !zipCode.isEmpty {
            let queryItems = ["zip" : zipCode]
            
            Task {
                do {
                    let repsInZipcode = try await repController.fetchItems(matching: queryItems)
                    self.reps = repsInZipcode
                    tableView.reloadData()
                } catch {
                    print(error)
                }
            }
        }
        
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return reps.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "repCell", for: indexPath) as! RepTableViewCell
        let rep =  reps[indexPath.row]
        
        cell.nameLabel.text = rep.name
        cell.partyLabel.text = rep.party
        cell.linkLabel.text = "Link: \(rep.link)"

        return cell
    }
}

extension RepsTableViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        fetchMatchingReps()
        resignFirstResponder()
    }
}
