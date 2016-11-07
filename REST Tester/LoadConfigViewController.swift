//
//  LoadConfigViewController.swift
//  REST Tester
//
//  Created by Kenny Speer on 11/6/16.
//  Copyright © 2016 Kenny Speer. All rights reserved.
//

import UIKit
import CoreData

class LoadConfigViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    // set the caller from the caller for access here
    weak var caller: ViewController?
    
    @IBOutlet var picker: UIPickerView!
    
    var pickerData = [String]()
    var configName: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // assign the delegate
        self.picker.delegate = self
        self.picker.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        configName = pickerData[row]
        print("SELECTED: \(configName)")
        return configName
    }
    
    @IBAction func deleteConfig(_ sender: Any) {
        if let obj = caller?.loadFromCoreStorage(name: configName!) as NSManagedObject? {
            caller?.clearData(entity: obj)
        }
        
        DispatchQueue.main.async {
            self.pickerData = (self.caller?.configNames)!
            self.picker.reloadAllComponents()
        }
    }
    
    @IBAction func doneButton(_ sender: Any) {
        self.caller?.loadArrays(name: self.configName!)
        self.dismiss(animated: true, completion: nil)
    }
    
}
