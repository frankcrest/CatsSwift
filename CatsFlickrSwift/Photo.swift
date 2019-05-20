//
//  Photo.swift
//  CatsFlickrSwift
//
//  Created by Frank Chen on 2019-05-19.
//  Copyright © 2019 Frank Chen. All rights reserved.
//

import Foundation

struct Post {
    var server:String
    var farm: Int
    var idString:String
    var secret:String
    var title:String
    var url:URL {
        get {
            return URL(string:"https://farm\(self.farm).staticflickr.com/\(self.server)/\(self.idString)_\(self.secret).jpg")!
        }
    }
    
    init(server:String, farm:Int, idString:String, secret:String, title:String){
        self.server = server
        self.farm = farm
        self.idString = idString
        self.secret = secret
        self.title = title
//        self.url = URL(string:"https://farm\(self.farm).staticflickr.com/\(self.server)/\(self.idString)_\(self.secret).jpg")!
    }
    
    init(dictionary:[String:Any]) {
        self.server = dictionary["server"] as? String ?? ""
        self.farm = dictionary["farm"] as? Int ?? 0
        self.idString = dictionary["id"] as? String ?? ""
        self.secret = dictionary["secret"] as? String ?? ""
        self.title = dictionary["title"] as? String ?? ""
    }
}
