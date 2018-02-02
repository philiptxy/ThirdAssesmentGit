//
//  ViewController.swift
//  ThirdAssesment_PhilipTeow
//
//  Created by Philip Teow on 02/02/2018.
//  Copyright © 2018 Philip Teow. All rights reserved.
//

import UIKit
import CoreData


class ViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var fetchResultController = NSFetchedResultsController<Owner>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Color", style: .plain, target: self, action: #selector(colorButtonTapped))
        
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
        
        if UserDefaults.standard.string(forKey: "barColor") == nil {
            navigationController?.navigationBar.barTintColor = UIColor.darkGray
        } else if UserDefaults.standard.string(forKey: "barColor") == "blue" {
            navigationController?.navigationBar.barTintColor = UIColor.blue
        } else if UserDefaults.standard.string(forKey: "barColor") == "red" {
            navigationController?.navigationBar.barTintColor = UIColor.red
        } else if UserDefaults.standard.string(forKey: "barColor") == "purple" {
            navigationController?.navigationBar.barTintColor = UIColor.purple
        }
        

        
        if UserDefaults.standard.bool(forKey: "isNotFirstRun") {
            print("Owners was previously loaded")
            fetchOwners()
        } else {
            print("Loading owners")
            loadOwners()
            fetchOwners()
            UserDefaults.standard.set(true, forKey: "isNotFirstRun")
        }
        
    }
    
    
    @objc func colorButtonTapped(){
        let alertController = UIAlertController(title: "Choose Theme", message: nil, preferredStyle: .alert)
        let blue = UIAlertAction(title: "Blue", style: .default) { (action) in
            self.navigationController?.navigationBar.barTintColor = UIColor.blue
            UserDefaults.standard.set("blue", forKey: "barColor")
        }
        let red = UIAlertAction(title: "Red", style: .default) { (action) in
            self.navigationController?.navigationBar.barTintColor = UIColor.red
            UserDefaults.standard.set("red", forKey: "barColor")
        }
        let purple = UIAlertAction(title: "Purple", style: .default) { (action) in
            self.navigationController?.navigationBar.barTintColor = UIColor.purple
            UserDefaults.standard.set("purple", forKey: "barColor")
        }
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
       
        
        alertController.addAction(blue)
        alertController.addAction(red)
        alertController.addAction(purple)
        alertController.addAction(cancel)
       
        present(alertController, animated: true, completion: nil)
    }
    
    func loadOwners(){
        
        for name in ["Micheal J", "Linda P", "Justin B", "Postie M", "Big Shaq", "Miley C", "Suga", "Agust D", "Steve A", "Camilia C"] {
            guard let insertOwner = NSEntityDescription.insertNewObject(forEntityName: "Owner", into: DataController.moc) as? Owner else {return}
            
            insertOwner.name = name
            DataController.saveContext()
        }
        
        
        
    }
    
    func fetchOwners(){
        //request - get everything
        let request = NSFetchRequest<Owner>(entityName: "Owner")
        
        //sort
        let sortName = NSSortDescriptor(key: "name", ascending: true)
        request.sortDescriptors = [sortName]
        
        fetchResultController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: DataController.moc, sectionNameKeyPath: nil, cacheName: nil)
        fetchResultController.delegate = self
        
        do {
            try fetchResultController.performFetch()
            tableView.reloadData()
        } catch {
            print("Error fetching owner data")
        }
        
        
    }
    
    
    
    
    
}

extension ViewController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fetchResultController.fetchedObjects?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ownerCell", for: indexPath)
        let currentOwner = fetchResultController.object(at: indexPath)
        
        cell.textLabel?.text = currentOwner.name
        return cell
    }
    
}

extension ViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedOwner = fetchResultController.object(at: indexPath)
        guard let vc = storyboard?.instantiateViewController(withIdentifier: "PropertyViewController") as? PropertyViewController else {return}
        
        vc.selectedOwner = selectedOwner
        
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension ViewController : NSFetchedResultsControllerDelegate {
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        print("did change")
        print("old : ", indexPath)
        print("new : ", newIndexPath)
        
        switch type {
        case .insert:
            print("insert")
            if let new = newIndexPath {
                tableView.insertRows(at: [new], with: .right)
            }
        case .update:
            print("update")
            if let old = indexPath {
                tableView.reloadRows(at: [old], with: .middle)
            }
        case .move:
            print("move")
            if let old = indexPath,
                let new = newIndexPath {
                
                tableView.performBatchUpdates({
                    tableView.moveRow(at: old, to: new)
                }, completion: { (_) in
                    self.tableView.reloadRows(at: [new], with: .fade)
                })
                
                
            }
        case .delete:
            print("delete")
            if let old = indexPath {
                tableView.deleteRows(at: [old], with: .left)
            }
        }
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
}


