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
                
                
                //                tableView.moveRow(at: old, to: new)
                //                tableView.endUpdates()
                //                tableView.beginUpdates()
                //                tableView.reloadRows(at: [new], with: .fade)
                
                
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


