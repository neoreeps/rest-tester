//
//  HeaderViewController.swift
//  REST Tester
//
//  Created by Kenny Speer on 10/11/16.
//  Copyright © 2016 Kenny Speer. All rights reserved.
//

import UIKit


class AddFieldsViewController: UITableViewController {
    
    weak var caller:ViewController?
    
    @IBOutlet weak var dataTable: UITableView!
    @IBOutlet var addFieldsTitle: UINavigationItem!

    @IBOutlet var key: UITextField!
    @IBOutlet var value: UITextField!
    
    // var used to reference temp array data; init them all
    var headerFields = [[String]]()
    var dataFields = [[String]]()
    var tableData = [[String]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        // dataTable.delegate = self
        // dataTable.dataSource = self
        
        // register cell class or through interface builder
        // self.dataTable.register(UITableViewCell.self, forCellReuseIdentifier: "AddFieldsCell")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getTableData() -> [[String]] {
        if addFieldsTitle.title?.lowercased().range(of: "header") != nil {
            print("TD1: \(headerFields.description))")
            return headerFields
        } else if addFieldsTitle.title?.lowercased().range(of: "data") != nil {
            print("TD2: \(dataFields.description))")
            return dataFields
        } else {
            return [[""]]
        }
    }
    
    @IBAction func clearRow(_ sender: AnyObject) {
        print("TAG: \(sender.tag)")
        let tableData = getTableData()
        
        if tableData.description == headerFields.description {
            headerFields.remove(at: sender.tag!)
        } else if tableData.description == dataFields.description {
            dataFields.remove(at: sender.tag!)
        }
        
        DispatchQueue.main.async {
            // do UI updates here
            self.dataTable.reloadData()
        }
    }
    
    // add button which actually adds data to lists
    @IBAction func addFields(_ sender: AnyObject) {

        // don't let the user add empty fields
        if key.text == "" || value.text == "" {
            return
        }
        
        // don't use getTableData here since we can't distinguish and need a 
        // reference to the actual table (it is copied between calls)
        if addFieldsTitle.title?.lowercased().range(of: "header") != nil {
            headerFields.append([key.text!, value.text!])
        } else if addFieldsTitle.title?.lowercased().range(of: "data") != nil {
            dataFields.append([key.text!, value.text!])
        }
        print("TABLE UPDATE: \(tableData)")
        
        DispatchQueue.main.async {
            // do UI updates here
            self.dataTable.reloadData()
        }
        key.text = nil
        value.text = nil
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        let tableData = getTableData()
        
        if tableView == dataTable {
            print("FOUND TABLE: \(tableData.count) cells")
            return tableData.count
        }
        return Int()
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let tableData = getTableData()
        
        print("TABLE: \(tableView.description)")
        if tableView == dataTable {
            let cell = dataTable.dequeueReusableCell(withIdentifier: "AddFieldsCell", for: indexPath) as! AddFieldsCell
            
            let row = indexPath.row

            cell.key.text = tableData[row][0]
            cell.value.text = tableData[row][1]
            cell.clearButton.tag = row
            
            return cell
        }
        
        return UITableViewCell()
    }

    @IBAction func doneButton(_ sender: AnyObject) {
        caller!.headerFields = self.headerFields
        caller!.dataFields = self.dataFields
        self.dismiss(animated: true, completion: nil)
    }
}
