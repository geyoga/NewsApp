//
//  ArticleNewsViewController.swift
//  NewsApp
//
//  Created by Georgius Yoga Dewantama on 14/04/20.
//  Copyright © 2020 Georgius Yoga Dewantama. All rights reserved.
//

import UIKit
import Kingfisher

class ArticleNewsViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    var articles = [Article]()
    var currentArticles = [Article]()
    var listImgUrl : [String] = []
    var source : String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        setupNavBar()
        getAllArticle(from: source ?? "")
        
        // Do any additional setup after loading the view.
    }
    
    func setupTableView (){
        tableView.delegate = self
        tableView.dataSource = self
        tableView.allowsSelectionDuringEditing = false
        tableView.allowsSelection = true
        tableView.showsVerticalScrollIndicator = false
        self.tableView.separatorStyle = .none
    }
    
    func setupNavBar(){
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.hidesSearchBarWhenScrolling = false
        let searchController = UISearchController(searchResultsController: nil)
        navigationItem.searchController = searchController
        searchController.searchBar.delegate = self
        searchController.obscuresBackgroundDuringPresentation = false
    }
    
    func getAllArticle(from sources : String){
        
        let urlRequest = URL(string: "https://newsapi.org/v2/top-headlines?sources=\(sources)&apiKey=c9b8c8c688934343b40585494e787afd")
        
        guard let downloadURL = urlRequest else {return}
        
        URLSession.shared.dataTask(with: downloadURL) { (data, response, error) in
            guard let data = data, error == nil, response != nil else {
                print("something wrong with the data")
                return
            }
            print("downloaded")
            do{
                let decoder = JSONDecoder()
                let downloadedArticle = try decoder.decode(Articles.self, from: data)
                self.articles = downloadedArticle.articles
                self.currentArticles = self.articles
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
                
            }catch{
                print("Error when decode")
            }
        }.resume()
    }
}


extension ArticleNewsViewController : UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currentArticles.count
        //return self.listImgUrl.count
       // return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "articleCell", for: indexPath) as! ArticleCell
        
        cell.authorNewsLabel.text = currentArticles[indexPath.row].author
        cell.titleNewsLabel.text = currentArticles[indexPath.row].title
        cell.descNewsLabel.text = currentArticles[indexPath.row].description
        
        if let imageString = currentArticles[indexPath.row].urlToImage {
            
            guard let imageURL = URL(string: imageString) else {return cell}
            let resource = ImageResource(downloadURL: imageURL, cacheKey: imageString)
            cell.newsImageView.kf.indicatorType = .activity
            cell.newsImageView.kf.setImage(with: resource)
        }
        
        

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        performSegue(withIdentifier: "goToWeb", sender: currentArticles[indexPath.row].url)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let webVC = segue.destination as! WebArticleViewController
        webVC.url = sender as? String
    }
}

extension ArticleNewsViewController : UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard !searchText.isEmpty else {
            currentArticles = articles
            tableView.reloadData()
            return
        }
        currentArticles = articles.filter({ (article ) -> Bool in
            return article.title!.lowercased().contains(searchText.lowercased())
        })
        tableView.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        currentArticles = articles
        tableView.reloadData()
    }
    
}

