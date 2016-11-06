//
//  ViewController.swift
//  REST Tester
//
//  Created by Kenny Speer on 10/3/16.
//  Copyright © 2016 Kenny Speer. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet var urlString: UITextField!
    @IBOutlet var urlResponse: UITextView!
    @IBOutlet var urlData: UITextView!
    @IBOutlet var secondaryMenu: UIView!
    @IBOutlet var mainStack: UIStackView!
    @IBOutlet var methodStack: UIStackView!
    @IBOutlet var dataFormat: UISegmentedControl!
    
    var httpMethod = "None" // default
    var globalMethod: UIButton! // global repr of method button

    // lists of query strings and attributes
    var headerFields = [["Accept", "application/json"],
                        ["Content-Type", "application/x-www-form-urlencoded"]]
    var dataFields = [[String]]()
    
    // access the data globally
    var data: Data!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // set params here so they are only set once instead of each time the functions are called below
        secondaryMenu.backgroundColor = UIColor.white.withAlphaComponent(0.5)
        secondaryMenu.translatesAutoresizingMaskIntoConstraints = false
        
        // Do any additional setup after loading the view, typically from a nib.
        
        /* To dismiss keyboard
         * 1. add UITextFieldDelegate class
         * 2. set variable.delgate = self (current view)
         * 3. implement textFieldShouldReturn as below
         * 4. add gesture recognizer to dismiss on tap
         * 5. add method to resign firstResponder
         */

        urlString.delegate = self
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(ViewController.dismissKeyboard)))
        
        // set URL to default placeholder
        urlString.text = urlString.placeholder
        
        // set border with rounded corners
        urlData.layer.borderColor = UIColor( red: 153/255, green: 153/255, blue: 153/255, alpha: 1.0 ).cgColor
        urlData.layer.borderWidth = 1.0
        urlData.layer.cornerRadius = 2.0
        urlResponse.layer.borderColor = UIColor( red: 160/255, green: 160/255, blue: 160/255, alpha: 1.0 ).cgColor
        urlResponse.layer.borderWidth = 1.0
        urlResponse.layer.cornerRadius = 2.0
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // dismiss keyboard when touch diff part of screen
    func dismissKeyboard() {
        urlString.resignFirstResponder()
    }
    
    // dismiss keyboard when pressing return; requires TextfieldDelegate
    func textFieldShouldReturn(_ urlString: UITextField) -> Bool {
        urlString.resignFirstResponder()
        return true
    }

    // MARK: - Core Data
    
    // generic method to retrieve object context
    func getContext() -> NSManagedObjectContext {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
    }
    
    // load instance from core storage
    func loadFromCoreStorage(name: String) -> NSManagedObject? {
        var instance: NSManagedObject?
        
        // create fetch request
        let fetchRequest: NSFetchRequest<FieldData> = FieldData.fetchRequest()
        
        do {
            // get results
            let searchResults = try getContext().fetch(fetchRequest)
            
            // check results
            print("results count: \(searchResults.count)")
            
            // convert to NSManagedObject
            for dataArray in searchResults as [NSManagedObject] {
                // interate list of objets and set instance
                print("RET_NAME: \(dataArray.value(forKey: "name"))")
                if dataArray.value(forKey: "name") as! String == name {
                    instance = dataArray
                }
                
            }
        } catch {
            print("Error with request: \(error)")
        }
        
        return instance
    }
    
    // clear entry from core data
    func clearData(entity: NSManagedObject) {
        let context = getContext()
        
        context.delete(entity)
        do {
             try context.save()
        } catch let error as NSError {
            print("Could not save \(error), \(error.userInfo)")
        } catch {
        }
    }
    
    // store arrays as array of arrays accessible by "name"
    func storeArrays(name: String) {
        
        print("SNAME: \(name)")
        
        if let obj = self.loadFromCoreStorage(name: name) as NSManagedObject? {
            self.clearData(entity: obj)
        }
        
        let context = getContext()
        
        // retrieve the entity
        let entity = NSEntityDescription.entity(forEntityName: "FieldData", in: context)
        let fieldData = NSManagedObject(entity: entity!, insertInto: context)
        fieldData.setValue(name, forKey: "name")
        fieldData.setValue(self.headerFields, forKey: "headerFields")
        fieldData.setValue(self.dataFields, forKey: "bodyFields")
        fieldData.setValue(self.urlString.text!, forKey: "url")
        
        do {
            try context.save()
            print("SAVED! \(name)")
        } catch let error as NSError {
            print("Could not save \(error), \(error.userInfo)")
        } catch {
        }
    }
    
    // load arrays previously stored by "name"
    func loadArrays(name: String) {
        
        print("LNAME: \(name)")
        if let obj = self.loadFromCoreStorage(name: name) as NSManagedObject? {
            self.headerFields = obj.value(forKey: "headerFields") as! [Array<String>]
            self.dataFields = obj.value(forKey: "bodyFields") as! [Array<String>]
            self.urlString.text = obj.value(forKey: "url") as? String
        }
    }
    
    // MARK: - Secondary Menu
    
    func hideSecondaryMenu() {
        // closure as argument, can ommit the () if closure is last argument
        // completion has a (bool)->Void signature, where bool is whether the animation has completed.
        UIView.animate(withDuration: 0.4, animations: {
            self.secondaryMenu.alpha = 0}, completion: {
                completed in
                if completed == true {
                    self.secondaryMenu.removeFromSuperview()
                }
            }
        )
    }
    
    func showSecondaryMenu() {
        view.addSubview(secondaryMenu)
        /*
         Constraints can be added in UI or in code, doing in here in code is more explicit and seems a better solution.  Must add reference to container.
         */
        let bottomConstraint = secondaryMenu.topAnchor.constraint(equalTo: methodStack.bottomAnchor)
        let leftConstraint = secondaryMenu.leftAnchor.constraint(equalTo: view.leftAnchor)
        let rightConstraint = secondaryMenu.rightAnchor.constraint(equalTo: view.rightAnchor)
        let heightConstraint = secondaryMenu.heightAnchor.constraint(equalToConstant: 44)
        NSLayoutConstraint.activate([bottomConstraint,leftConstraint,rightConstraint,heightConstraint])
        
        //Activate the constraints we just created
        view.layoutIfNeeded()
        
        // fade in the menu
        // closure as last arg can ommit parens
        self.secondaryMenu.alpha = 0
        UIView.animate(withDuration: 0.4) {
            self.secondaryMenu.alpha = 1
        }
    }
    
    // MARK: - Buttons
    
    // generic function to highlight a button when selected
    func highlightButton(button: UIButton) {
        if button.isSelected {
            button.isSelected = false
        } else {
            button.isSelected = true
        }
    }
    
    // called when selecting method type from submenu
    @IBAction func pushButton(_ sender: AnyObject) {
        if let button = sender as? UIButton {
            // use the button label as the method
            httpMethod = (button.titleLabel?.text)!
            
            // call method button when submenu button is pressed
            methodButton(globalMethod)
        }
    }
    
    // shows submenu and changes title based on method chosen
    @IBAction func methodButton(_ sender: AnyObject) {
        globalMethod = sender as? UIButton
        
        // highlight
        if let button = sender as? UIButton {
            highlightButton(button: button)
            
            if button.isSelected {
                showSecondaryMenu()
            } else {
                hideSecondaryMenu()
                
                // finally, set the button text
                button.setTitle("Method: \(httpMethod)", for: .normal)
            }
        }
    }
    
    @IBAction func addFieldsButton(_ sender: AnyObject) {
        let addFieldsView = self.storyboard?.instantiateViewController(withIdentifier: "AddFieldsViewController") as! AddFieldsViewController
        
        // pass caller to new view
        addFieldsView.caller = self
        addFieldsView.headerFields = self.headerFields
        addFieldsView.dataFields = self.dataFields
        
        if let button = sender as? UIButton {
            addFieldsView.addFieldsTitle.title = "Add \((button.titleLabel?.text)!) Fields"
        }
        
        // call method to unset button if set
        if globalMethod != nil && globalMethod.isSelected {
            methodButton(globalMethod)
        }
        
        let addFieldsViewNav = UINavigationController(rootViewController: addFieldsView)
        self.present(addFieldsViewNav, animated: true, completion: nil)
    }
    
    @IBAction func saveLoadButton(_ sender: AnyObject) {
        let button = sender as? UIButton
        
        let alertController = UIAlertController(title: "Name", message: "Enter the name of the configuration:", preferredStyle: .alert)
        
        let buttonName = (button?.titleLabel?.text)!
        
        let confirmAction = UIAlertAction(title: buttonName, style: .default) { (_) in
            if let field = alertController.textFields![0] as? UITextField {
                // store your data
                //UserDefaults.standard.set(field.text, forKey: "userEmail")
                if (buttonName.range(of: "Load") != nil) {
                    self.loadArrays(name: field.text!)
                } else {
                    self.storeArrays(name: field.text!)
                }
            } else {
                // user did not fill field
            }
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (_) in }
        
        alertController.addTextField { (textField) in
            textField.placeholder = "config name"
        }
        
        alertController.addAction(confirmAction)
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true, completion: nil)
    }

    
    // MARK: - URL Requsts
    
    // convert data to requested format, use raw by default
    // convert to json if requested but fallback to raw if not valid json (i.e. an array)
    
    func convertData() -> NSMutableAttributedString {
        
        var userData = NSMutableAttributedString(string: "None")
        
        if self.data != nil {
            let attrs = [NSFontAttributeName : UIFont.boldSystemFont(ofSize: 11)]

            let dataString = NSString(data: self.data, encoding: String.Encoding.utf8.rawValue)
            let rawDataString = NSMutableAttributedString(string: "\n\((dataString?.description)!)")
            
            if dataFormat.selectedSegmentIndex == 0 {
                userData = rawDataString
            } else if dataFormat.selectedSegmentIndex == 1 {
                do {
                    let convertedData = try JSONSerialization.jsonObject(with: self.data, options: [])
                    if convertedData is NSArray {
                        userData = rawDataString
                    } else if let dictData = convertedData as? NSDictionary {
                        userData = NSMutableAttributedString(string: "")
                        for (k, v) in dictData {
                            let boldString = NSMutableAttributedString(string: "\n\(k): ", attributes: attrs)
                            let standardString = NSMutableAttributedString(string: "\(v)")
                            boldString.addAttribute(NSForegroundColorAttributeName, value: UIColor.blue, range: NSRange(location: 0, length: (k as! String).characters.count + 1))
                            boldString.append(standardString)
                            userData.append(boldString)
                        }
                    }
                } catch let error as NSError {
                    userData = NSMutableAttributedString(string: "JSON ERROR: \(error.localizedDescription)")
                    userData.append(rawDataString)
                }
            }
        }
        
        return userData
    }
    
    // toggle for data format
    @IBAction func formatData(_ sender: AnyObject) {
        self.urlData.attributedText = self.convertData()
        self.reloadInputViews()
    }
    
    func buildRequest(url: URL) -> NSMutableURLRequest {
        
        let request = NSMutableURLRequest(url: url)
        request.httpMethod = httpMethod

        if self.dataFields.count > 0 {
            var body = "\(self.dataFields[0][0])=\(self.dataFields[0][1])"
            for x in 1...dataFields.count {
                if x == 1 { continue }
                
                let row = dataFields[x - 1] // count is not 0 based
                body += "&\(row[0])=\(row[1])"
            }
            print("BODY: \(body.description)")
            let postData: Data = body.data(using: String.Encoding.utf8)!
            request.httpBody = postData
            
            // set the content-length in the header since we have a body
            let postLength: String = String(postData.count)
            request.setValue(postLength, forHTTPHeaderField: "Content-Length")
        }
        
        if self.headerFields.count > 0 {
            for header: [String] in headerFields {
                request.setValue(header[1], forHTTPHeaderField: header[0])
            }
        }
        // Add Basic Authorization
        /*
         let username = "myUserName"
         let password = "myPassword"
         let loginString = NSString(format: "%@:%@", username, password)
         let loginData: NSData = loginString.dataUsingEncoding(NSUTF8StringEncoding)!
         let base64LoginString = loginData.base64EncodedStringWithOptions(NSDataBase64EncodingOptions())
         request.setValue(base64LoginString, forHTTPHeaderField: "Authorization")
         */
        
        // Or add Token value
        //request.addValue("Token token=884288bae150b9f2f68d8dc3a932071d", forHTTPHeaderField: "Authorization")
        
        return request
    }
    
    @IBAction func sendRequest(_ sender: AnyObject) {

        // protect against malformed URL
        guard let url = URL(string: urlString.text!) else {
            let msg = "Error: cannot create URL from \(urlString.text!)"
            print(msg)
            urlResponse.text = msg
            return
        }

        var userData = NSMutableAttributedString(string: "None")
        var userResponse = NSMutableAttributedString(string: "None")
        
        // create session and async task
        let request = buildRequest(url: url)
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        let task = session.dataTask(with: request as URLRequest, completionHandler: {
            data, response, error in
        
            self.data = data
            
            print("RESPONSE: \(response)")
            print("DATA: \(data)")
            print("ERROR: \(error)")
            
            // check for session errors, then response data, and finally convert the data to json
            if error != nil {
                let msg = "\nERROR URLSession: \(error?.localizedDescription)"
                print(msg)
                userResponse = NSMutableAttributedString(string: msg)
            } else {
                
                // generic attributes for bold strings
                let attrs = [NSFontAttributeName : UIFont.boldSystemFont(ofSize: 11)]
                
                let httpResponse = response as! HTTPURLResponse
                userResponse = NSMutableAttributedString(string: "status: \(httpResponse.statusCode)\n", attributes: attrs)
                for (k, v) in httpResponse.allHeaderFields {

                    let boldString = NSMutableAttributedString(string: "\n\(k): ", attributes: attrs)
                    let standardString = NSMutableAttributedString(string: "\(v)")
                    boldString.addAttribute(NSForegroundColorAttributeName, value: UIColor.blue, range: NSRange(location: 0, length: (k as! String).characters.count + 1))
                    boldString.append(standardString)
                    userResponse.append(boldString)
                }
            }
            
            // convert data as required and display
            userData = self.convertData()
            
            // update UI on main thread only, called from within closure
            DispatchQueue.main.async {
                // do UI updates here
                self.urlData.attributedText = userData
                self.urlResponse.attributedText = userResponse
            }
        })
        
        task.resume()
    }
}
