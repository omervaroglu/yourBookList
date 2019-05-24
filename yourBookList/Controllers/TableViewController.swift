//
//  TableViewController.swift
//  yourBookList
//
//  Created by Ömer Varoğlu on 24.05.2019.
//  Copyright © 2019 Omer Varoglu. All rights reserved.
//

import UIKit
import CoreData

class TableViewController: UITableViewController {
    
    var bookData = BookList()
    
    override func viewWillAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self, selector: #selector(getData), name: NSNotification.Name("newlist"), object: nil)
    }
    
    @objc func getData() {
        
        // table view guncellerken tum verileri kaldirip yeniden yukluyoruz.
        bookData.bookList.removeAll()
        bookData.reading.removeAll()
        
        
        //context ve AppDelegate e ulasmak icin gerekli kisim
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        //burasi verileri cekmek icin gerekli
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "BookProperty")
        fetchRequest.returnsObjectsAsFaults = false
        
        // do try ve for ile verileri kontrol edip aliyoruz.
        do {
            let results = try context.fetch(fetchRequest)
            
            if results.count > 0 {
                
                for result in results as! [NSManagedObject] {
                    
                    if let name = result.value(forKey: "bookName") as? String {
                        bookData.bookList.append(name)
                    }
                    if let reading1 = result.value(forKey: "reading") as? Double {
                        bookData.reading.append(reading1)
                    }
                    
                    self.tableView.reloadData()
                }
            }
        } catch {
            
        }
    }
    
    @IBAction func addButton(_ sender: Any) {
        bookData.selectedBook = ""
        performSegue(withIdentifier: "toDetailsVC", sender: nil)
    }
}
