//
//  Article.swift
//  huyn5930_a6
//
//  Created by Daniel H on 2020-04-06.
//  Copyright © 2020 Daniel H. All rights reserved.
//
import UIKit
import Foundation
public struct Article{
    var title: String
    var description: String
    var link: String
    var image: UIImage
    
    func getTitle()->String{
        return self.title
    }
    func getDescription()->String{
        return self.description
    }
    func getLink()->String{
        return self.link
    }
    func getImage()->UIImage{
        return self.image
    }
}

