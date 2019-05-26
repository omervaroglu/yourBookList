//
//  BookListTableViewController.swift
//  yourBookList
//
//  Created by Ömer Varoğlu on 26.05.2019.
//  Copyright © 2019 Omer Varoglu. All rights reserved.
//

import UIKit
import CoreData

class BookListTableViewController : UITableViewController {
    
    var bookData = BookList()
    
    override func viewWillAppear(_ animated: Bool) {
        tableView.reloadData()
    }
    override func viewDidLoad() {
        self.navigationController?.navigationBar.topItem?.title = "Book Note"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.add, target: self, action: #selector(addAction))
        getData()
    }
    
    func getData() {
        
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
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return bookData.bookList.count
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        tableView.register(UINib(nibName: "CustomCellView", bundle: nil), forCellReuseIdentifier: "CustomCellView")
        let cell = tableView.dequeueReusableCell(withIdentifier: "CustomCellView") as! CustomCellView
        cell.nameLabel.text = bookData.bookList[indexPath.row]
        cell.percentageLabel.text = String("%\(bookData.reading[indexPath.row])")
        return cell
    }

    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        bookData.selectedBook = bookData.bookList[indexPath.row]
        performSegue(withIdentifier: "toDetail", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toDetail" {
            let destinationVC = segue.destination as? detailsVC
            destinationVC?.chosenBook = bookData.selectedBook
        }
    }
    
    @objc func addAction() {
//        let vc = storyboard?.instantiateViewController(withIdentifier: "detailsVC") as! detailsVC
//        navigationController?.pushViewController(vc, animated: true)
        bookData.selectedBook = ""
        performSegue(withIdentifier: "toDetail", sender: nil)
    }
    
}
