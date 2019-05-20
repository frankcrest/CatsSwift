//
//  ViewController.swift
//  CatsFlickrSwift
//
//  Created by Frank Chen on 2019-05-19.
//  Copyright © 2019 Frank Chen. All rights reserved.
//

import UIKit

class ViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    var photos = [Post]()
    var collectionView : UICollectionView? = nil
    
//    let collectionView : UICollectionView = {
//        let flowLayout = UICollectionViewFlowLayout()
//        let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: flowLayout)
//        collectionView.backgroundColor = UIColor.cyan
//        collectionView.register(CustomCell.self, forCellWithReuseIdentifier: "customCell")
//
//        return collectionView
//    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        setupViews()
        
        networkToFlickr()
    }
    
    func setupViews(){
        let flowLayout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: self.view.bounds, collectionViewLayout: flowLayout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = UIColor.cyan
        collectionView.register(CustomCell.self, forCellWithReuseIdentifier: "customCell")
        self.collectionView = collectionView
        self.view.addSubview(collectionView)
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.photos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "customCell", for: indexPath) as! CustomCell
        cell.backgroundColor = UIColor.red
        let photo = self.photos[indexPath.row]
        cell.label.text = photo.title
        cell.loadImageFromUrl(url: photo.url)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = self.view.frame.width / 2 - 10
        return CGSize(width: width, height: width)
    }
    
    func networkToFlickr(){
        let url = URL.init(string: "https://api.flickr.com/services/rest/?method=flickr.photos.search&format=json&nojsoncallback=1&api_key=ee7022884e6a1d08111f705e8e1afba8&tags=cat")
        
        let urlRequest = URLRequest.init(url: url!)
        
        let urlSessionConfig = URLSessionConfiguration.default
        
        let urlSession = URLSession.init(configuration: urlSessionConfig)
        
        let dataTask = urlSession.dataTask(with: urlRequest) { (data:Data?, response:URLResponse?, error:Error?) in
            
            if(error != nil){
                print("Error:\(String(describing: error))")
            }
            
            if let urlContent = data{
                do{
                    let jsonResult = try JSONSerialization.jsonObject(with: urlContent, options: []) as! [String:Any]
                    let photosDictionary = jsonResult["photos"] as! [String:Any]
                    
                    let photosArray = photosDictionary["photo"] as? [AnyObject]
                    
                    for dict in photosArray!{
                        let photo = Post.init(dictionary: dict as! [String : Any])
                        self.photos.append(photo)
                    }
                    
                } catch{
                    print("JSON serialization failed")
                }
            }
            
            DispatchQueue.main.async {
                self.collectionView?.reloadData()
            }
        }
        
        dataTask.resume()
    }
}

