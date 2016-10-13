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

    @IBOutlet var addFieldsTitle: UINavigationItem!
    
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
    
    @IBAction func doneButton(_ sender: AnyObject) {
        // caller!.myTextView.text = editModeTextView.text
        
        self.dismiss(animated: true, completion: nil)
    }
}
