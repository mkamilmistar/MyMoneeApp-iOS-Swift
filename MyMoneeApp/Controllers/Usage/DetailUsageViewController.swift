//
//  DetailUsageViewController.swift
//  MyMoneeApp
//
//  Created by MacBook on 12/05/21.
//

import UIKit

class DetailUsageViewController: UIViewController {

    @IBOutlet weak var backButton: UIButton!
    @IBOutlet var idUsage: UILabel!
    @IBOutlet var iconStatus: UIImageView!
    @IBOutlet var titleUsage: UILabel!
    @IBOutlet var status: UILabel!
    @IBOutlet var price: UILabel!
    @IBOutlet var dateUsage: UILabel!
    
    var passIndex: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mainNoBackgroundButton(backButton)
        
        //setViewVariable
        idUsage.text = usages[passIndex].id
        titleUsage.text = usages[passIndex].title
        
        if usages[passIndex].status == .pemasukan {
            iconStatus.image = UIImage(named: "Arrow_Up_BG")
            status.text = "Pemasukan"
            price.textColor = AppColor.mainGreen
        } else {
            iconStatus.image = UIImage(named: "Arrow_Down_BG")
            status.text = "Pengeluaran"
            price.textColor = AppColor.mainRed

        }
        
        dateUsage.text = usages[passIndex].date
        let stringPrice = setDecimalToString(amountValue: usages[passIndex].price)
        price.text = "Rp \(stringPrice)"
        
    }
    
    @IBAction func goEditUsage(_ sender: UIButton) {
        let editUsageVC = EditUsageViewController(nibName: String(describing: String(describing: EditUsageViewController.self)), bundle: nil)
        
        editUsageVC.modalPresentationStyle = .fullScreen
        editUsageVC.modalTransitionStyle = .coverVertical
        
        //Pass Data
        editUsageVC.passIndex = self.passIndex
        
        self.present(editUsageVC, animated: false)
    }
    
    @IBAction func backToHome(_ sender: UITapGestureRecognizer){
        
        self.dismiss(animated: true, completion: nil)
    }

}
