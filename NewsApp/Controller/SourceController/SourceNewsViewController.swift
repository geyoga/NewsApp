//
//  SourceNewsViewController.swift
//  NewsApp
//
//  Created by Georgius Yoga Dewantama on 15/04/20.
//  Copyright © 2020 Georgius Yoga Dewantama. All rights reserved.
//

import UIKit

class SourceNewsViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    var sources = [Source]()
    var currentSources = [Source]()
    var categoryNews : String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavBar()
        setupTableView()
        getAllSource(from: categoryNews!)
        // Do any additional setup after loading the view.
    }
    
    
    func setupTableView (){
        tableView.delegate = self
        tableView.dataSource = self
        tableView.allowsSelectionDuringEditing = false
        tableView.allowsSelection = true
        tableView.showsVerticalScrollIndicator = false
        tableView.separatorStyle = .singleLine
       }
    func setupNavBar(){
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.hidesSearchBarWhenScrolling = false
        let searchController = UISearchController(searchResultsController: nil)
        navigationItem.searchController = searchController
        searchController.searchBar.delegate = self
        searchController.obscuresBackgroundDuringPresentation = false
    }
    
    func getAllSource(from category : String){
        
        var urlRequest = URL(string: "")
        if category.contains("all"){
            urlRequest = URL(string: "https://newsapi.org/v2/sources?apiKey=c9b8c8c688934343b40585494e787afd")
        }else{
            urlRequest = URL(string: "https://newsapi.org/v2/sources?category=\(category)&apiKey=c9b8c8c688934343b40585494e787afd")
        }
        
        
        guard let downloadURL = urlRequest else {return}
        
        URLSession.shared.dataTask(with: downloadURL) { (data, response , error) in
            guard let data = data, error == nil, response != nil else {
                print("something wrong with the data")
                return
            }
            print("downloaded")
            do {
                let decoder = JSONDecoder()
                let downloadedSources = try decoder.decode(Sources.self, from: data)
                self.sources = downloadedSources.sources
                self.currentSources = self.sources
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }catch{
                print("Error when decode")
            }
        }.resume()
    }
}

extension SourceNewsViewController : UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currentSources.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "sourceCell", for: indexPath) as! SourceCell
        cell.sourceLabel.text = currentSources[indexPath.row].name
        cell.descLabel.text = currentSources[indexPath.row].description
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        performSegue(withIdentifier: "goToArticle", sender: self.currentSources[indexPath.row].id)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let articleVC = segue.destination as! ArticleNewsViewController
        articleVC.source = sender as? String
    }
}

extension SourceNewsViewController : UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard !searchText.isEmpty else {
            currentSources = sources
            tableView.reloadData()
            return
        }
        currentSources = sources.filter({ (source ) -> Bool in
            return source.name!.lowercased().contains(searchText.lowercased() )
        })
        tableView.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        currentSources = sources
        tableView.reloadData()
    }

}
