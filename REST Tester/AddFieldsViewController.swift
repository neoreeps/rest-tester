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
    
    // use one list for each data type, reuse the same table view but populate
    // with different data baed on button pressed from main view
    var headerFields = ["1", "2", "3"]
    var dataFields = ["a", "b", "c"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // editModeTextView.text = previewModeText
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func getTableData() -> [String] {
        if addFieldsTitle.title?.lowercased().range(of: "header") != nil {
            return self.headerFields
        } else {
            return self.dataFields
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var tableData: [String]
        
        if addFieldsTitle.title?.lowercased().range(of: "header") != nil {
            tableData = self.headerFields
        } else {
            tableData = self.dataFields
        }
        
        if tableView == dataTable {
            print("FOUND TABLE: \(tableData.count) cells")
            return tableData.count
        }
        return Int()
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var tableData = getTableData()
        
        print("TABLE: \(tableView.description)")
        if tableView == dataTable {
            print("FOUND VIEW!")
            let cell = dataTable.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
            
            let row = indexPath.row
            cell.textLabel?.text = tableData[row]
            
            return cell
        }
        
        return UITableViewCell()
    }

    @IBAction func doneButton(_ sender: AnyObject) {
        // caller!.myTextView.text = editModeTextView.text
        
        self.dismiss(animated: true, completion: nil)
    }
}
