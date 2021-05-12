//
//  AddImpianViewController.swift
//  MyMoneeApp
//
//  Created by MacBook on 12/05/21.
//

import UIKit

class AddImpianViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func backButton(_ sender: Any) {
        backToImpianView()
    }
    
    @IBAction func saveButton(_ sender: Any) {
        backToImpianView()
    }
    
    func backToImpianView(){
        let mainTabViewController = MainTabController(nibName: "MainTabViewController", bundle: nil)
        
        mainTabViewController.modalPresentationStyle = .fullScreen
        mainTabViewController.modalTransitionStyle = .crossDissolve
        
        self.present(mainTabViewController, animated: false, completion: nil)
    }
}
