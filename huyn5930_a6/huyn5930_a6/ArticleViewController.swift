//
//  ArticleViewController.swift
//  huyn5930_a6
//
//  Created by Daniel H on 2020-04-06.
//  Copyright © 2020 Daniel H. All rights reserved.
//

import UIKit

class ArticleViewController: UIViewController {

    var currentArticle :Article!
    @IBOutlet weak var articleText: UILabel!
    @IBOutlet weak var articleImage: UIImageView!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title=currentArticle.getTitle()
        articleImage.image = currentArticle.getImage()
        articleText.text = currentArticle.getDescription()

    
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "browserSegue" {
            if let browserViewController = segue.destination as? BrowserViewController {
                browserViewController.webURL = currentArticle.getLink()
                
            }
        }
    }

}
