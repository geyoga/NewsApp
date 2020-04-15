//
//  CategoryNewsViewController.swift
//  NewsApp
//
//  Created by Georgius Yoga Dewantama on 15/04/20.
//  Copyright © 2020 Georgius Yoga Dewantama. All rights reserved.
//

import UIKit

class CategoryNewsViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    var estimateWidth = 160.0
    var cellMarginSize = 16.0
    var categories : [Category] = []
    
    let cat1 = Category(id: "all", name: "All", backgroundImage: UIImage(named: "tech")!)
    let cat2 = Category(id: "technology", name: "Technology", backgroundImage: UIImage(named: "tech")!)
    let cat3 = Category(id: "business", name: "Business", backgroundImage: UIImage(named: "tech")!)
    let cat4 = Category(id: "entertainment", name: "Entertainment", backgroundImage: UIImage(named: "tech")!)
    let cat5 = Category(id: "general", name: "General", backgroundImage: UIImage(named: "tech")!)
    let cat6 = Category(id: "health", name: "Health", backgroundImage: UIImage(named: "tech")!)
    let cat7 = Category(id: "science", name: "Science", backgroundImage: UIImage(named: "tech")!)
    let cat8 = Category(id: "sports", name: "Sports", backgroundImage: UIImage(named: "tech")!)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        setupNavBar()
        
        self.collectionView.register(UINib(nibName: "CategoryCell", bundle: nil), forCellWithReuseIdentifier: "CategoryCell")
        self.setupGrid()
        categories = setupCategory()
        
        // Do any additional setup after loading the view.
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.setupGrid()
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }
    
    func setupCollectionView (){
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.allowsSelection = true
        collectionView.showsVerticalScrollIndicator = false
       }
    func setupNavBar(){
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.hidesSearchBarWhenScrolling = false
    }
    
    func setupGrid() {
        let flow = collectionView?.collectionViewLayout as! UICollectionViewFlowLayout
        flow.minimumLineSpacing = CGFloat(self.cellMarginSize)
        flow.minimumInteritemSpacing = CGFloat(self.cellMarginSize)
    }
    
    func setupCategory() -> [Category]{
        
        var tempCat : [Category] = []
        tempCat.append(cat1)
        tempCat.append(cat2)
        tempCat.append(cat3)
        tempCat.append(cat4)
        tempCat.append(cat5)
        tempCat.append(cat6)
        tempCat.append(cat7)
        tempCat.append(cat8)
        
        return tempCat
    }

}


extension CategoryNewsViewController : UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CategoryCell", for: indexPath) as! CategoryCell
        cell.titleLabel.text = categories[indexPath.item].name
        cell.backgroundImageView.image = categories[indexPath.item].backgroundImage
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        performSegue(withIdentifier: "goToNewsSource", sender: self.categories[indexPath.item].id)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let newsVC = segue.destination as! SourceNewsViewController
        newsVC.categoryNews = sender as? String
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = self.calculateWidth()
        return CGSize(width: width, height: width)
    }
    
    func calculateWidth() -> CGFloat {
        let estimatedWidth = CGFloat(estimateWidth)
        let cellCount = floor(CGFloat(self.view.frame.size.width) / estimatedWidth)
        
        let margin = CGFloat(cellMarginSize * 2)
        let width = (self.view.frame.size.width - CGFloat(cellMarginSize) * (cellCount - 1) - margin) / cellCount
        
        return width
    }
    
    
}

