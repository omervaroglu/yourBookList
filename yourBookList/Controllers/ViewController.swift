//
//  ViewController.swift
//  yourBookList
//
//  Created by Omer  on 10.01.2019.
//  Copyright © 2019 Omer Varoglu. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    
    @IBOutlet weak var tableView: UITableView!
    var bookList : [String] = []
    var reading : [Double] = []
    var selectedBook = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
        getData()
    }
    override func viewWillAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.getData), name: NSNotification.Name("newlist"), object: nil)
    }
    
    @objc func getData() {
        
        // table view guncellerken tum verileri kaldirip yeniden yukluyoruz.
        bookList.removeAll()
        reading.removeAll()
        
        
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
                        self.bookList.append(name)
                    }
                    if let reading1 = result.value(forKey: "reading") as? Double {
                        self.reading.append(reading1)
                    }
                    
                    self.tableView.reloadData()
                }
            }
        } catch {
            
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return bookList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        // tek bir hucreyi 2 satir olarak kullanmak icin
        cell.textLabel!.numberOfLines = 2
        cell.textLabel?.text = "\(bookList[indexPath.row])\(String("\n%\(reading[indexPath.row]) okundu.")) "
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        //silmek icin yazdigim kisim
        if editingStyle == .delete {
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let context = appDelegate.persistentContainer.viewContext
            
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "BookProperty")
            do{
                let results = try context.fetch(fetchRequest)
                
                for result in results as! [NSManagedObject] {
                    if let bookName = result.value(forKey: "bookName") as? String {
                        if bookName == bookList[indexPath.row] {
                            context.delete(result)
                            bookList.remove(at: indexPath.row)
                            reading.remove(at: indexPath.row)
                            
                            self.tableView.reloadData()
                            
                            do{
                                try context.save()
                            }catch {
                                
                            }
                            break
                        }
                    }
                }
            } catch{
                
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toDetailsVC" {
            let destinationVC = segue.destination as? detailsVC
            destinationVC?.chosenBook = selectedBook
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedBook = bookList[indexPath.row]
        performSegue(withIdentifier: "toDetailsVC", sender: nil)
    }
    
    @IBAction func addButton(_ sender: Any) {
        selectedBook = ""
        performSegue(withIdentifier: "toDetailsVC", sender: nil)
    }
    
}

