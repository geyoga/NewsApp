//
//  ArticleNewsViewController.swift
//  NewsApp
//
//  Created by Georgius Yoga Dewantama on 14/04/20.
//  Copyright © 2020 Georgius Yoga Dewantama. All rights reserved.
//

import UIKit
import Kingfisher

class ArticleNewsViewController: UIViewController, UISearchBarDelegate {

    @IBOutlet weak var tableView: UITableView!
    var listArticle : [Article]? = []
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
        
        let urlRequest = URLRequest(url: URL(string: "https://newsapi.org/v2/top-headlines?sources=\(sources)&apiKey=c9b8c8c688934343b40585494e787afd")!)
        
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
                            article.imageUrl = imageUrl
                            article.newsUrl = url
                            self.listImgUrl.append(imageUrl)
                            //print(self.listImgUrl)
                        }
                        if article.imageUrl != nil {
                            self.listArticle?.append(article)
                        }
                    }
                }
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                    print(self.listArticle?.count)
//                    print(self.listArticle?[3].imageUrl)
                    print(self.listImgUrl.count)
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
        return self.listArticle?.count ?? 0
        //return self.listImgUrl.count
       // return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "articleCell", for: indexPath) as! ArticleCell
        
        cell.authorNewsLabel.text = self.listArticle?[indexPath.item].author
        cell.titleNewsLabel.text = self.listArticle?[indexPath.item].titleHeadline
        cell.descNewsLabel.text = self.listArticle?[indexPath.item].desc
        
        let resource = ImageResource(downloadURL: URL(string: listImgUrl[indexPath.row])!, cacheKey: listImgUrl[indexPath.row])
        cell.newsImageView.kf.setImage(with: resource)

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        performSegue(withIdentifier: "goToWeb", sender: self.listArticle?[indexPath.item].newsUrl)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let webVC = segue.destination as! WebArticleViewController
        webVC.url = sender as? String
    }
}

