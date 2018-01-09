//
//  FiltersViewController.swift
//  Connectivity
//
//  Created by Danial Zahid on 04/01/2018.
//  Copyright © 2018 Danial Zahid. All rights reserved.
//

import UIKit

class FiltersViewController: UIViewController {

    static let storyboardID = "filtersViewController"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Filters"
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func doneButtonPressed(_ sender: Any) {
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
