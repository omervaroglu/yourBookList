//
//  detailsVC.swift
//  yourBookList
//
//  Created by Omer  on 10.01.2019.
//  Copyright © 2019 Omer Varoglu. All rights reserved.
//

import UIKit
import CoreData


class detailsVC: UIViewController {
    @IBOutlet weak var booksName: UITextField!
    @IBOutlet weak var authorName: UITextField!
    @IBOutlet weak var willReadPage: UITextField!
    @IBOutlet weak var readPage: UITextField!
    
    var chosenBook = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if chosenBook != ""  {
            getProperty()
        }

    }
    
    @IBAction func saveButton(_ sender: Any) {
        
        if chosenBook != ""  {
            getUpdate()
        }
        
        
       let appDelegate = UIApplication.shared.delegate as! AppDelegate
       let context = appDelegate.persistentContainer.viewContext
        
       let newBook = NSEntityDescription.insertNewObject(forEntityName: "BookProperty", into: context)
        
        newBook.setValue(authorName.text, forKey: "authorName")
        newBook.setValue(booksName.text, forKey: "bookName")
        
        if let willReadPage = Double(willReadPage.text!) {
            newBook.setValue(willReadPage, forKey: "willReadPage")
        }
        
        if let readPage = Double(readPage.text!) {
            newBook.setValue(readPage, forKey: "readPage")
        }
        
        
        if let readpage1 = Double(readPage.text!) {
            if let willReadPage1 = Double(willReadPage.text!) {
                let x = (readpage1 * 100.0 ) / (willReadPage1)
                let reading = x.rounded()//en yakin tam sayiya yuvarlama icin kullaniliyor.
                newBook.setValue(reading, forKey: "reading")
            }
        }
        
        do {
            try context.save()
            print("Basarili")
        } catch {
            print(error)
        }
        
        NotificationCenter.default.post(name: NSNotification.Name("newlist"), object: nil)
        self.navigationController?.popViewController(animated: true)
        
    }
    
    func getProperty () {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "BookProperty")
        
        // burada kucuk bir filtreleme yapiyoruz.
        fetchRequest.predicate = NSPredicate(format: "bookName = %@", chosenBook)
        fetchRequest.returnsObjectsAsFaults = false
        
        do {
            let results = try context.fetch(fetchRequest)
            
            if results.count > 0 {
                
                for result in results as! [NSManagedObject] {
                    
                    booksName.text = chosenBook

                    if let author = result.value(forKey: "authorName") as? String {
                        authorName.text = author
                    }
                    if let page = result.value(forKey: "willReadPage") as? Double {
                        willReadPage.text = String(page)
                    }
                    if let readingPage = result.value(forKey: "readPage") as? Double {
                        readPage.text = String(readingPage)
                    }
                }
            }
        } catch {

        }
        
        
    }
    // update metodu
    func getUpdate() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext

        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "BookProperty")
        
        fetchRequest.predicate = NSPredicate(format: "bookName = %@", chosenBook)
        fetchRequest.returnsObjectsAsFaults = false
        
        do {
            let results = try context.fetch(fetchRequest)
            
            for result in results as! [NSManagedObject] {
            //once siliyoruz ve ardindan yerine yeni bilgileri yaziyoruz.
            context.delete(result)
            
            result.setValue(authorName.text, forKey: "authorName")
            result.setValue(booksName.text, forKey: "bookName")
            
            if let willReadPage = Double(willReadPage.text!) {
                result.setValue(willReadPage, forKey: "willReadPage")
            }
            
            if let readPage = Double(readPage.text!) {
                result.setValue(readPage, forKey: "readPage")
            }
            
            if let readpage1 = Double(readPage.text!) {
                if let willReadPage1 = Double(willReadPage.text!) {
                    let x = (readpage1 * 100.0 ) / (willReadPage1)
                    let reading = x.rounded()//en yakin tam sayiya yuvarlama icin kullaniliyor.
                    result.setValue(reading, forKey: "reading")
                }
            }
            }
            do{
                 try context.save()
            } catch {
                print("hata")
            }
            
        } catch {
            print("hata")
        }

        
        
    }
    
}
