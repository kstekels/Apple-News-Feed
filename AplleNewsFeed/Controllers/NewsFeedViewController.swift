//
//  NewsFeedViewController.swift
//  AplleNewsFeed
//
//  Created by Karlis Stekels on 12/02/2021.
//

import UIKit
import Gloss

class NewsFeedViewController: UIViewController {
    
    var items: [Item] = []

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Apple News"
        activityIndicatorView.isHidden = true
        activityIndicatorView.style = .large
        tableView.isHidden = true
        
    }
    
    
    @IBAction func getDataTapped(_ sender: Any) {
        activityIndicator(animated: true)
        handleGetData()
        
    }
    
    
    
    func activityIndicator(animated: Bool){
        DispatchQueue.main.async {
            if animated {
                
                self.activityIndicatorView.isHidden = false
                self.activityIndicatorView.startAnimating()
            }else{
                
                self.activityIndicatorView.isHidden = true
                self.activityIndicatorView.stopAnimating()
                
            }
            
        }
    }
    
    func handleGetData(){
        
        let jsonUrl = "http://newsapi.org/v2/everything?q=apple&from=2021-02-15&to=2021-02-15&sortBy=popularity&apiKey=a473de0095844441bc54bd266083c4f3"
        
        guard let url = URL(string: jsonUrl) else { return }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "GET"
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-type")
        
        let session = URLSession(configuration: URLSessionConfiguration.default)
        let task = session.dataTask(with: urlRequest) { (data , response, error) in
            
            if let err = error {
                print("error: \(err.localizedDescription)")
            }
            
            guard let data = data else {
                print("Data error!!!!")
                return
            }
            
            do{
                if let dictData = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                    print("dictData", dictData)
                    self.populateData(dictData)
                }
                
            }catch{
                print("err when converting JSON")
            }
            
            
        }
        task.resume()
    }
    
    func populateData(_ dict: [String: Any]){
        guard let responseDict = dict["articles"] as? [Gloss.JSON] else {
            return
        }
        
        items = [Item].from(jsonArray: responseDict) ?? []
        
        DispatchQueue.main.async {
            self.tableView.isHidden = false
            self.tableView.reloadData()
            self.activityIndicator(animated: false)
        }
        
    }
    @IBAction func newsFeedViewControllerInfo(_ sender: Any) {
        let info = UIAlertController(title: "News Feed Info!", message: "In this section you will find all newest articles about Apple from yesterday, sorted by popular publishers!\nPress on \"search\" 🔍 button to load an articles!", preferredStyle: .alert)
        info.addAction(UIAlertAction(title: "Close", style: .cancel, handler: nil))
        self.present(info, animated: true)
    }
    
    
}

extension NewsFeedViewController :UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "feedCell", for: indexPath) as? NewsTableViewCell else {
            return UITableViewCell()
        }
  
        let item = items[indexPath.row]
        
        if let image = item.image {
            cell.newsImageView.image = image
        }
        
        cell.newsTitleLabel.text = item.title
        cell.newsTitleLabel.numberOfLines = 0
        let date = String(item.publishedAt.prefix(10))
        self.title = "Apple News (\(date))"
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        guard let vc = storyboard.instantiateViewController(identifier: "DetailViewController") as? DetailViewController else {
            return
        }

        vc.contentString = items[indexPath.row].description
        vc.titleString = items[indexPath.row].title
        vc.webURLString = items[indexPath.row].url
        vc.newsImage = items[indexPath.row].image
        
            
        navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    
    


