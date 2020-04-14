//
//  ArticleNewsViewController.swift
//  NewsApp
//
//  Created by Georgius Yoga Dewantama on 14/04/20.
//  Copyright © 2020 Georgius Yoga Dewantama. All rights reserved.
//

import UIKit

class ArticleNewsViewController: UIViewController, UISearchBarDelegate {

    @IBOutlet weak var tableView: UITableView!
    var listArticle : [Article]? = []
    var listImgUrl : [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        setupNavBar()
        getAllArticle()
        
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
    
    func getAllArticle(){
        
        let urlRequest = URLRequest(url: URL(string: "https://newsapi.org/v2/top-headlines?country=id&apiKey=c9b8c8c688934343b40585494e787afd")!)
        
        let task = URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
            
            if error != nil {
                print(error)
                return
            }
            
            self.listArticle = [Article]()
            
            do {
                let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as! [String : AnyObject]
                if let articleFromJson = json["articles"] as? [[String : AnyObject]]{
                    for articleJson in articleFromJson {
                        let article = Article()
                        if let title = articleJson["title"] as? String,
                            let author = articleJson["author"] as? String,
                            let desc = articleJson["description"] as? String,
                            let url = articleJson["url"] as? String,
                            let imageUrl = articleJson["urlToImage"] as? String {
                            
                            article.author = author
                            article.titleHeadline = title
                            article.desc = desc
                            article.newsUrl = url
                            article.imageUrl = imageUrl
                            self.listImgUrl.append(imageUrl)
                            print(self.listImgUrl)
                        }
                        self.listArticle?.append(article)
                    }
                }
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
                
            }catch let error{
                print(error)
            }
        }
        task.resume()
    }
}


extension ArticleNewsViewController : UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //return self.listArticle?.count ?? 0
        return self.listImgUrl.count
       // return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "articleCell", for: indexPath) as! ArticleCell
        
        cell.authorNewsLabel.text = self.listArticle?[indexPath.item].author
        cell.titleNewsLabel.text = self.listArticle?[indexPath.item].titleHeadline
        cell.descNewsLabel.text = self.listArticle?[indexPath.item].desc
        //cell.newsImageView.downloadImage(from: (self.listArticle?[indexPath.item].imageUrl!)!)
        
        if let imageURL = URL(string: listImgUrl[indexPath.item]){
            DispatchQueue.global().async {
                let data = try? Data(contentsOf: imageURL)
                if let data = data {
                    let image = UIImage(data: data)
                    DispatchQueue.main.async {
                        cell.newsImageView.image = image
                    }
                }
            }
        }

        return cell
    }
}

extension UIImageView{
    
    func downloadImage(from url: String){
        
        let urlRequest = URLRequest(url: URL(string: url)!)
        
        let task = URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
            
            if error != nil {
                print(error)
                return
            }
            
            DispatchQueue.main.async {
                self.image = UIImage(data: data!)
            }
        }
        task.resume()
    }
}
