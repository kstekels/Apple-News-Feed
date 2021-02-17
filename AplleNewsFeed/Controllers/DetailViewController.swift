//
//  DetailViewController.swift
//  AplleNewsFeed
//
//  Created by Karlis Stekels on 12/02/2021.
//

import UIKit
import CoreData

class DetailViewController: UIViewController {
    
    var savedItems = [Items]()
    var context: NSManagedObjectContext?
    
    var webURLString = String()
    var titleString = String()
    var contentString = String()
    var newsImage: UIImage?
    
    @IBOutlet weak var newsImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var contentTextView: UITextView!
    @IBOutlet weak var readFullArticleButton: UIButton!
    @IBOutlet weak var saveButton: UIButton!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        readFullArticleButton.layer.cornerRadius = 25
        readFullArticleButton.tintColor = .label
        saveButton.layer.cornerRadius = 25
        
        

        self.title = "Article"
        
        titleLabel.text = titleString
        contentTextView.text = contentString
        newsImageView.image = newsImage
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        context = appDelegate.persistentContainer.viewContext
        
        
    }
    //
    @IBAction func savedButtonTapped(_ sender: Any) {
        let newItem = Items(context: self.context!)
        newItem.newsTitle = titleString
        newItem.newContent = contentString
        newItem.url = webURLString
        guard let imageData: Data = (newsImage?.pngData()) else {
            return
        }
        
        if !imageData.isEmpty {
            newItem.image = imageData
        }
        
        self.savedItems.append(newItem)
        saveData()
        
    }
    //
    func saveData() {
        do {
            try context?.save()
        }catch{
            print(error.localizedDescription)
        }
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        let destination: WebViewController = segue.destination as! WebViewController
        // Pass the selected object to the new view controller.
        destination.urlString = webURLString
    }

}
