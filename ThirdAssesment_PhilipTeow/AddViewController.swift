//
//  AddViewController.swift
//  ThirdAssesment_PhilipTeow
//
//  Created by Philip Teow on 02/02/2018.
//  Copyright © 2018 Philip Teow. All rights reserved.
//

import UIKit
import CoreData

class AddViewController: UIViewController {
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var priceTextField: UITextField!
    @IBOutlet weak var locationTextField: UITextField!
    @IBOutlet weak var addButton: UIButton!
    @IBAction func addButtonTapped(_ sender: Any) {
        guard let insertProperty = NSEntityDescription.insertNewObject(forEntityName: "Property", into: DataController.moc) as? Property else {return}
        
        insertProperty.name = nameTextField.text
        insertProperty.price = priceTextField.text
        insertProperty.location = locationTextField.text
        
        selectedOwner.addToOwns(insertProperty)
        DataController.saveContext()
        
        navigationController?.popViewController(animated: true)
        
    }
    
    var selectedOwner : Owner = Owner()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = "Add Property"
        addButton.tintColor = UIColor.blue
    }

    

}
