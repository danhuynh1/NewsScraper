//
//  TableViewController.swift
//  huyn5930_a6
//
//  Created by Daniel H on 2020-04-06.
//  Copyright © 2020 Daniel H. All rights reserved.
//

import UIKit
import Foundation
let customCellIdentifier = "reuseIdentifier"

class CustomCell: UITableViewCell{
    @IBOutlet weak var articleName: UILabel!
    
    @IBOutlet weak var articlePic: UIImageView!
}



class TableViewController: UIViewController, UITableViewDelegate,UITableViewDataSource, URLSessionTaskDelegate, XMLParserDelegate  {
        @IBOutlet weak var tableView: UITableView!
    
    var dataStore = Data();
    let urlPath: String = "https://globalnews.ca/toronto/feed/"
    var currentElement = ""
    var processingElement = false
    let ELEMENT_NAME = "item"
    let ELEMENT_LINK = "link"
    let ELEMENT_DESC = "description"
    let ELEMENT_TITLE = "title"
    let ELEMENT_IMAGE = "enclosure"

    
    var Articles: [Article] = []
    
    var elementName: String = String()
    var articleTitle = String()
    var articleDesc = String()
    var articleLink = String()
    var articleImage = UIImage()
    
    @IBAction func unwindToVC1(segue:UIStoryboardSegue) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false

    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Articles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath) as? CustomCell
        if (cell == nil) {
            cell = CustomCell(style: UITableViewCell.CellStyle.default, reuseIdentifier: "reuseIdentifier") as CustomCell
        }

        let myArticle = Articles[indexPath.row]
        cell?.articleName.text = String(myArticle.getTitle())
        cell?.articlePic.image = myArticle.getImage()
        
        return cell!
    }
    


    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Global News Toronto Feed"

        UIApplication.shared.isNetworkActivityIndicatorVisible = true
         let url: URL = URL(string: urlPath)!
         let request: URLRequest = URLRequest(url: url)
         let config = URLSessionConfiguration.default
         let session = URLSession(configuration: config)
         let task = session.dataTask(with: request, completionHandler:{ (data, response, error) in
             self.dataStore = data!
             DispatchQueue.main.async {
                 UIApplication.shared.isNetworkActivityIndicatorVisible = false
             }
             self.parseXML()
         })
         task.resume()

    }
    

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ArticleSegue" {
            if let articleViewController = segue.destination as? ArticleViewController {
                let indexPath = tableView.indexPathForSelectedRow
                articleViewController.currentArticle = Articles[indexPath!.row]
            }
        }
    }
    
    

     // MARK: - XML parsing
    
    func parseXML() {
       // print("start the parser")
        let parser = XMLParser(data: dataStore)
        parser.delegate = self;
        parser.parse()
    }
    
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String]) {
        
        self.elementName = elementName
        switch(elementName){
        case ELEMENT_NAME:
                        processingElement = true
                        articleTitle = String()
                        articleDesc = String()
                        articleLink = String()
                        articleImage = UIImage()
          case ELEMENT_IMAGE:
                        let url = NSURL(string: attributeDict["url"]!)
                        let imageData = NSData(contentsOf: url! as URL)
                        let image = UIImage(data: imageData! as Data)
                        articleImage = image!
          default:
              //...
              break
          }
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        if processingElement {
            currentElement+=string
            let data = string.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
            if (!data.isEmpty) {
                switch(elementName){
                case ELEMENT_TITLE:
                    articleTitle += data
                case ELEMENT_DESC:
                    articleDesc += data
                case ELEMENT_LINK:
                    articleLink += data
                    default:
                        //...
                        break
                }

            }
        }
    }
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if elementName == ELEMENT_NAME {

            let newArticle = Article(title: articleTitle, description: articleDesc, link: articleLink, image: articleImage)
            //print(articleLink)
            Articles.append(newArticle)
            processingElement = false
            currentElement = ""
        }
    } // didEndElement
    
    
    func parserDidEndDocument(_ parser: XMLParser) {

        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    func parser(_ parser: XMLParser, parseErrorOccurred parseError: Error) {
        print("parser error " + String(describing: parseError))
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }
    
}
