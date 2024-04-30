//
//  NobelTableViewController.swift
//  APIProject
//
//  Created by Jordan Fraughton on 4/25/24.
//

import UIKit

struct CategorySection {
    var name: String
    var laureates: [Laureate] 
    var isOpened: Bool
}

class NobelTableViewController: UITableViewController {

    @IBOutlet weak var searchBar: UISearchBar!
    
    let laureateController = LaruateController()
    
    private var categorySections: [CategorySection] = []
    
    var categories = [Category]()
    var headerText = ""
        
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Nobel Prize Laureates"
    }
    
    func fetchMatchingLaureates() {
        self.categories = []
        self.categorySections = []
        self.tableView.reloadData()
        
        let year = searchBar.text ?? ""
        
        if !year.isEmpty {
            let categoryTitles = ["physics", "chemistry", "medicine", "literature", "peace", "economics"]
            
            for categoryTitle in categoryTitles {
                let queryItems = ["year": year, "category": categoryTitle]
                Task {
                    do {
                        let prizes = try await laureateController.fetchLarautes(matching: queryItems)
                        let category = prizes.prizes[0]
                        categorySections.append(CategorySection(name: category.category.capitalized,
                                                                laureates: category.laureates,
                                                                isOpened: false))
                        headerText = category.year
                        tableView.reloadData()
                    } catch {
                        headerText = ""
                        print(error)
                    }
                }
            }
        }
    }

    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        categorySections.count
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        section == 0 ? headerText : ""
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let section = categorySections[section]
        
        if section.isOpened {
            return section.laureates.count + 1
        } else {
            return 1
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let categorySection = categorySections[indexPath.section]
        
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "categoryCell", for: indexPath) as! CategoryTableViewCell
            cell.categoryLabel.text = categorySection.name
            
            if categorySection.isOpened {
                cell.arrowTriangleImage.transform = CGAffineTransform(rotationAngle: .pi / 2)
            } else {
                cell.arrowTriangleImage.transform = CGAffineTransform.identity
            }
            
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "laureateCell", for: indexPath) as! LaureateTableViewCell
            let laurete = categorySection.laureates[indexPath.row - 1]
            
            cell.laureateLabel.text = laurete.firstname + " " + laurete.surname
            
            return cell
        }
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if indexPath.row == 0 {
            let cell = tableView.cellForRow(at: indexPath) as! CategoryTableViewCell
            categorySections[indexPath.section].isOpened = !categorySections[indexPath.section].isOpened
            tableView.reloadSections([indexPath.section], with: .none)
            
        }
    }
}

extension NobelTableViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        fetchMatchingLaureates()
        resignFirstResponder()
    }
}
