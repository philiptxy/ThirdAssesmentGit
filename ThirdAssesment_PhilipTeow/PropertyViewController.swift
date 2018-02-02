//
//  PropertyViewController.swift
//  ThirdAssesment_PhilipTeow
//
//  Created by Philip Teow on 02/02/2018.
//  Copyright © 2018 Philip Teow. All rights reserved.
//

import UIKit
import CoreData

class PropertyViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    var selectedOwner : Owner = Owner()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self

        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.add, target: self, action: #selector(addButtonHandler))
        guard let ownerName = selectedOwner.name else {return}
        navigationItem.title = "Properties of \(ownerName)"
    }
    
    override func viewDidAppear(_ animated: Bool) {
        tableView.reloadData()
    }
    
    @objc func addButtonHandler(){
        guard let vc = storyboard?.instantiateViewController(withIdentifier: "AddViewController") as? AddViewController else {return}
        vc.selectedOwner = selectedOwner
        navigationController?.pushViewController(vc, animated: true)
        
    }
    


    

}

extension PropertyViewController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return selectedOwner.owns?.allObjects.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "propertyCell", for: indexPath)
        if let properties = selectedOwner.owns?.allObjects as? [Property]{
            let currentProperty = properties[indexPath.row]
            cell.textLabel?.text = currentProperty.name
            guard let propertyPrice = currentProperty.price,
                let propertyLocation = currentProperty.location else {return UITableViewCell()}
            cell.detailTextLabel?.text = "Price: \(propertyPrice) Location: \(propertyLocation)"
        }
        
        return cell
    }
    
}

extension PropertyViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let properties = selectedOwner.owns?.allObjects as? [Property]{
            let selectedProperty = properties[indexPath.row]
            guard let vc = storyboard?.instantiateViewController(withIdentifier: "EditViewController") as? EditViewController else {return}
            vc.selectedProperty = selectedProperty
            navigationController?.pushViewController(vc, animated: true)
        }
        
    }
}
