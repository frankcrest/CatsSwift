//
//  CustomCell.swift
//  CatsFlickrSwift
//
//  Created by Frank Chen on 2019-05-19.
//  Copyright © 2019 Frank Chen. All rights reserved.
//

import UIKit

class CustomCell: UICollectionViewCell {
    
    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        
        return imageView
    }()
    
    var label: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = UIColor.cyan
        
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubview(imageView)
        self.addSubview(label)
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: self.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            label.topAnchor.constraint(equalTo: imageView.bottomAnchor),
            label.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            label.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            label.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            label.heightAnchor.constraint(equalToConstant: 20)
            ])
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:)has not been implemented")
    }
    
    func loadImageFromUrl(url:URL){
        print(url)
        if (self.imageView.image == nil) {
            let urlSessionConfig = URLSessionConfiguration.default
            let urlSession = URLSession.init(configuration: urlSessionConfig)
            
            let dataTask = urlSession.downloadTask(with: url) { (url:URL?, response:URLResponse?, error:Error?) in
                if(error != nil){
                    print("Erorr downloading:\(String(describing: error))")
                }
               
                var image : UIImage?
                do{
                    let data = try Data.init(contentsOf: url!)
                    image = UIImage.init(data: data)
                } catch{
                    print(error)
                }
                
                OperationQueue.main.addOperation {
                    if (image != nil){
                        self.imageView.image = image
                    }
                }
            }
            dataTask.resume()
        }
    }
    
}
