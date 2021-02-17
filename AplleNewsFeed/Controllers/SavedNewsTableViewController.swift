//
//  SavedNewsTableViewController.swift
//  AplleNewsFeed
//
//  Created by karlis.stekels on 15/02/2021.
//

import UIKit
import CoreData

class SavedNewsTableViewController: UITableViewController {
    
    var savedItems = [Items]()
    var context: NSManagedObjectContext?
    var urlStringForSource = Int()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.reloadData()
        tableView.delegate = self
        tableView.dataSource = self
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        context = appDelegate.persistentContainer.viewContext
        
        // Uncomment the following line to preserve selection between presentations
        //self.clearsSelectionOnViewWillAppear = true
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        //        self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        
        
        
        
        // load
        loadData()
        countItems()
    }
    
    @IBAction func startEditing(_ sender: Any) {
        tableView.isEditing = !tableView.isEditing
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        tableView.isEditing = false
        //load
        loadData()
        countItems()
        
    }
    
    func saveData() {
        do {
            try self.context?.save()
        }catch{
            fatalError(error.localizedDescription)
        }
        loadData()
        countItems()
    }
    
    func loadData(){
        
        
        let request: NSFetchRequest<Items> = Items.fetchRequest()
        
        do{
            savedItems = try (context?.fetch(request))!
            
        }catch{
            // alert controllers
            print(error.localizedDescription)
        }
        
        tableView.reloadData()
        
    }
    
    func countItems() {
        let itemsInTable = String(self.tableView.numberOfRows(inSection: 0))
        self.title = "Saved(\(itemsInTable))"
    }
    
    @IBAction func infoButtonPressed(_ sender: Any) {
        let info = UIAlertController(title: "Saved News Info!", message: "In this section you will find your saved articles. If you decide to delete some articles, you can do it by using \"Edit\" button and click on delete symbol, or alternative way is to pointer on related article and swipe from right side the left, then press \"delete\"!", preferredStyle: .alert)
        info.addAction(UIAlertAction(title: "Close", style: .cancel, handler: nil))
        self.present(info, animated: true)
    }
    // MARK: - Table view data source
    
    //    override func numberOfSections(in tableView: UITableView) -> Int {
    //        // #warning Incomplete implementation, return the number of sections
    //        return 1
    //    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return savedItems.count
    }
    
    
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "savedFeedCell", for: indexPath) as? NewsTableViewCell else{
            return UITableViewCell()
        }
        
        let item = savedItems[indexPath.row]
        if let image = UIImage(data: item.image!){
            cell.newsImageView.image = image
        }
        cell.newsTitleLabel.text = item.newsTitle
        cell.newsTitleLabel.numberOfLines = 0
        
        
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    /*
     // Override to support conditional editing of the table view.
     override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        guard let vc = storyboard.instantiateViewController(identifier: "WebViewController") as? WebViewController else {
            return
        }
        self.title = "Saved"
        vc.urlString = self.savedItems[indexPath.row].url!
        navigationController?.pushViewController(vc, animated: true)
    }
    
    
    
    //MARK: - Deleting and editing
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
        
        //let rowContent = savedItems[fromIndexPath.row]
        let row = savedItems.remove(at: fromIndexPath.row)
        savedItems.insert(row, at: to.row)
        
        
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let alert = UIAlertController(title: "Delete", message: "Are you sure you want to delete?", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            alert.addAction(UIAlertAction(title: "Delete", style: .default, handler: {_ in
                let item = self.savedItems[indexPath.row]
                self.context?.delete(item)
                self.saveData()
                self.loadData()
            }))
            self.present(alert, animated: true)
            
        }
        
        
        
        
        
        
        
        
        
        
        
        
        
        // MARK: - Navigation
        /*
         // In a storyboard-based application, you will often want to do a little preparation before navigation
         override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
         // Get the new view controller using segue.destination.
         // Pass the selected object to the new view controller.
         }
         */
        
    }
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    //    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    //        // Get the new view controller using segue.destination.
    //        let destination: WebViewController = segue.destination as! WebViewController
    //        // Pass the selected object to the new view controller.
    //        destination.urlString = urlStringForSource
    //    }
}
