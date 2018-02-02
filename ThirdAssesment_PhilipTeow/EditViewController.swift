//
//  EditViewController.swift
//  ThirdAssesment_PhilipTeow
//
//  Created by Philip Teow on 02/02/2018.
//  Copyright © 2018 Philip Teow. All rights reserved.
//

import UIKit
import CoreData

class EditViewController: UIViewController {
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var priceTextField: UITextField!
    @IBOutlet weak var locationTextField: UITextField!
    @IBOutlet weak var editButton: UIButton!
    @IBAction func editButton(_ sender: Any) {
        selectedProperty.name = nameTextField.text
        selectedProperty.price = priceTextField.text
        selectedProperty.location = locationTextField.text
        
        DataController.saveContext()
        
        navigationController?.popViewController(animated: true)
    }
    
    var selectedProperty : Property = Property()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        editButton.tintColor = UIColor.blue

        guard let propertyName = selectedProperty.name else {return}
        navigationItem.title = "Edit \(propertyName)"
        
        nameTextField.text = selectedProperty.name
        priceTextField.text = selectedProperty.price
        locationTextField.text = selectedProperty.location
        
    }

    
}
