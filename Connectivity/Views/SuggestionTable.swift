//
//  SuggestionTable.swift
//  Connectivity
//
//  Created by Danial Zahid on 09/01/2018.
//  Copyright © 2018 Danial Zahid. All rights reserved.
//

import UIKit

protocol SuggestionTableDelegate {
    func suggestionSelected(value: String)
}

class SuggestionTable: DesignableView, UITableViewDelegate, UITableViewDataSource {

    let tableView = UITableView()
    
    var values = [String]()
    var delegate: SuggestionTableDelegate?
    
    
    convenience init(over view: UIView, in controller: UIViewController) {
        let suggestionBox = CGRect(x: view.frame.origin.x, y: view.frame.origin.y + 50, width: view.frame.size.width, height: 250)
        self.init(frame: suggestionBox)
        controller.view.addSubview(self)
        
        self.snp.remakeConstraints { (make) in
            make.top.equalTo(view.snp.bottom).offset(5.0)
            make.height.equalTo(250)
            make.width.equalTo(view.snp.width)
            make.left.equalTo(view.snp.left)
        }
        
        isHidden = true
        if let controllerDelegate = controller as? SuggestionTableDelegate {
            delegate = controllerDelegate
        }
        
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        tableView.frame = self.frame
        let nib = UINib(nibName: "SuggestionTable", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: SuggestionTableViewCell.identifier)
        
        tableView.delegate = self
        tableView.dataSource = self
        
        self.addSubview(tableView)
        self.bringSubview(toFront: tableView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return values.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SuggestionTableViewCell.identifier, for: indexPath) as! SuggestionTableViewCell
        cell.nameLabel.text = values[indexPath.row]
        return cell
    }
    
    func refreshList(listValues: [String]) {
        values = listValues
        self.isHidden = false
        tableView.reloadData()
        self.tableView.frame = CGRect(x: 0, y: 0, width: frame.size.width, height: CGFloat(min(150,values.count*30)))
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 30
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.delegate?.suggestionSelected(value: values[indexPath.row])
        self.isHidden = true
    }
    
    

}
