//
//  BaseViewController.swift
//  Connectivity
//
//  Created by Danial Zahid on 07/11/2017.
//  Copyright © 2017 Danial Zahid. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setupBackgroundImage()
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil);
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setupBackgroundImage(){
        
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(named: "nav-bg")?.resizableImage(withCapInsets: UIEdgeInsetsMake(0, 0, 0, 0), resizingMode: UIImageResizingMode.stretch), for: .default)
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
