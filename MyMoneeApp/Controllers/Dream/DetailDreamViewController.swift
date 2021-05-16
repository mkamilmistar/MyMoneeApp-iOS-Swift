//
//  ImpianDetailViewController.swift
//  MyMoneeApp
//
//  Created by MacBook on 12/05/21.
//

import UIKit

class DetailDreamViewController: UIViewController {

    @IBOutlet weak var heartLogo: UIView!
    @IBOutlet weak var progressBackground: UIView!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet var confirmButton: UIButton!
    
    @IBOutlet var dreamTitle: UILabel!
    @IBOutlet var targetAmount: UILabel!
    @IBOutlet var progressAmount: UILabel!
    @IBOutlet var progressBar: UIProgressView!
    @IBOutlet var percentProgress: UILabel!

    
    //Data
    var passIndex: Int!
    var passProgressData: Float? = 0.0
    var userData: User = AuthUser.data
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //Set Properties of Component
        setShadow(heartLogo)
        setShadow(progressBackground)
        mainNoBackgroundButton(backButton)
        
        //Conditional Button Confirm
        let percentProgressData = Int((passProgressData ?? 0.0) * 100)
        
        if percentProgressData != 100 {
            disabledMainButton(confirmButton)
        } else {
            enabledMainButton(confirmButton)
        }
        
        //Set View Variable
        let currentAmountConv = setDecimalToStringCurrency(amountValue: userData.balance)
        let targetAmountConv = setDecimalToStringCurrency(amountValue: dreams[passIndex].targetAmount)
        
        dreamTitle.text = dreams[passIndex].title
        percentProgress.text = "\(percentProgressData)%"
        
        let amount = anotherSetDecimalToStringCurrency(amountValue: dreams[passIndex].targetAmount)
        targetAmount.text = "Rp \(amount)"
        progressAmount.text = "\(currentAmountConv) / \(targetAmountConv)"
        progressBar.progress = passProgressData ?? 0.0
        
    }
    
    
    @IBAction func goEditImpian(_ sender: Any) {
        let editDreamVC = EditDreamViewController(nibName: String(describing: EditDreamViewController.self), bundle: nil)
        
        editDreamVC.modalPresentationStyle = .fullScreen
        editDreamVC.modalTransitionStyle = .coverVertical
        
        //Pass Data To Edit
        editDreamVC.passIndex = passIndex
        
        self.present(editDreamVC, animated: false, completion: nil)
    }
    
    @IBAction func confirmButton(_ sender: Any) {
        dreams.remove(at: passIndex ?? 0)
        
        let mainTabVC = MainTabController(nibName: String(describing: MainTabController.self), bundle: nil)
        
        mainTabVC.modalPresentationStyle = .fullScreen
        mainTabVC.modalTransitionStyle = .crossDissolve
        mainTabVC.selectedIndex = 1
        
        self.present(mainTabVC, animated: false, completion: nil)
    }
    
    @IBAction func backButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
   
}

