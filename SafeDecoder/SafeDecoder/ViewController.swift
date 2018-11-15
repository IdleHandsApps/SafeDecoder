//
//  ViewController.swift
//  SafeDecoder
//
//  Created by Fraser on 16/11/18.
//  Copyright © 2018 IdleHandsApps. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet var tableView: UITableView!
    var solarSystem: SolarSystem!
    var errors = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        SafeDecoder.logger = { [weak self] error, typeName in
            guard let strongSelf = self else { return }
            
            // replace with a call to your own logging service
            print(error)
            
            strongSelf.errors.append("\(error)")
        }
        
        self.solarSystem = self.getModel(modelType: SolarSystem.self)
        
        // hide seperator for empty cells
        self.tableView.tableFooterView = UIView(frame: CGRect.zero)
        
        self.tableView.register(UITableViewCell.classForCoder(), forCellReuseIdentifier: "UITableViewCell")
    }
    
    func getModel<T>(modelType: T.Type) -> T? where T: Codable {
        
        let data = self.getData(modelType: modelType)
        let decodedData: T? = try? JSONDecoder().decode(T.self, from: data)

        return decodedData
    }
    
    func getData<T>(modelType: T.Type) -> Data where T: Codable {
        let testBundle = Bundle(for: type(of: self))
        
        let fileName = String(describing: modelType)
        print("fileName \(fileName)")
        let path = testBundle.url(forResource: fileName, withExtension: "json")
        assert(path != nil, "error getting path for \(fileName)")
        
        let ressourceData = try? Data(contentsOf: path!)
        assert(ressourceData != nil, "error getting data for \(fileName)")
        
        return ressourceData!
    }
}

extension ViewController: UITableViewDataSource {
    
    public func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    public func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return nil
        }
        else {
            return "Decoding Errors"
        }
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return self.solarSystem.planets.count
        }
        else {
            return errors.count
        }
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UITableViewCell", for: indexPath)
        
        if indexPath.section == 0 {
            cell.textLabel?.text = self.solarSystem.planets[indexPath.row].name
            cell.backgroundColor = UIColor.white
        }
        else {
            cell.textLabel?.text = self.errors[indexPath.row]
            cell.textLabel?.numberOfLines = 0
            cell.backgroundColor = UIColor(red: 1, green: 126.0/255.0, blue: 121.0/255.0, alpha: 0.5)
        }
        
        return cell
    }
}
