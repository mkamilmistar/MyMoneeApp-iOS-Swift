//
//  HomeViewController.swift
//  MyMoneeApp
//
//  Created by MacBook on 11/05/21.
//

import UIKit

class HomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet var notFound: NotFound!
    @IBOutlet var greetingLabel: UILabel!
    @IBOutlet var usagesTableView: UITableView!
    @IBOutlet var userName: UILabel!
    @IBOutlet var balanceView: UIView!
    @IBOutlet var balanceLabel: UILabel!
    @IBOutlet var totalUsageIn: UILabel!
    @IBOutlet var totalUsageOut: UILabel!

    var dataUser: User = AuthUser.data
    var userWallet: Wallet = AuthUser.wallet

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = AppColor.mainBG
        balanceView.backgroundColor = AppColor.mainPurple
        notFound.isHidden = true
        
        //Get All Data In and Out
        let dataIn = usages.filter({$0.status == .pemasukan})
        let dataOut = usages.filter({$0.status == .pengeluaran})
        
        //Asign To Wallet
        userWallet.usageIn = dataIn.map({$0.price}).reduce(0, +)
        userWallet.UsageOut = dataOut.map({$0.price}).reduce(0, +)
        
        let dataUsageIn = anotherSetDecimalToStringCurrency(amountValue: userWallet.usageIn)
        let dataUsageOut = anotherSetDecimalToStringCurrency(amountValue: userWallet.UsageOut)
        
        //Set Data Show
        totalUsageIn.text = "Rp. \(dataUsageIn)"
        totalUsageOut.text = "Rp. \(dataUsageOut)"
        
        userName.text = dataUser.name
        let balance =  setDecimalToString(amountValue: userWallet.balance)
        balanceLabel.text = "Rp \(balance)"
        
        //Set Data Greeting
        schedulerGreetingText()
        
        usagesTableView.delegate = self
        usagesTableView.dataSource = self
        usagesTableView.separatorStyle = .none
        usagesTableView.backgroundColor = .white
        
        let uiNib = UINib(nibName: String(describing: UsageTableViewCell.self), bundle: nil)
        usagesTableView.register(uiNib, forCellReuseIdentifier: String(describing: UsageTableViewCell.self))
    }
    
    //Scheduler the Greeting Text
    func schedulerGreetingText(){
        let time = Date().hour
        
        switch time {
        case 1..<12: self.greetingLabel.text = "Selamat Pagi,"
        case 12..<15: self.greetingLabel.text = "Selamat Siang,"
        case 15..<18: self.greetingLabel.text = "Selamat Sore,"
        case 18..<24: self.greetingLabel.text = "Selamat Malam,"
        default:self.greetingLabel.text = "Selamat Dini Hari,"
        }
    }
    
    @IBAction func goAddUsageView(_ sender: UIButton) {
        let addUsageVC = AddUsageViewController(nibName: String(describing: AddUsageViewController.self), bundle: nil)
        
        addUsageVC.modalPresentationStyle = .fullScreen
        addUsageVC.modalTransitionStyle = .coverVertical
        
        self.present(addUsageVC, animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //deselect row animation
        tableView.deselectRow(at: indexPath, animated: false)
        
        let detailUsageVC = DetailUsageViewController(nibName: String(describing: DetailUsageViewController.self), bundle: nil)
        
        detailUsageVC.modalPresentationStyle = .fullScreen
        detailUsageVC.modalTransitionStyle = .coverVertical
        
        //PassingData
        detailUsageVC.passIndex = indexPath.row
        
        self.present(detailUsageVC, animated: true, completion: nil)
    
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if usages.count > 0 {
            return usages.count
        } else {
            self.usagesTableView.isHidden = true
            self.notFound.isHidden = false
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let trans = tableView.dequeueReusableCell(withIdentifier: String(describing: UsageTableViewCell.self), for: indexPath) as! UsageTableViewCell
        
        //change selected color
        let backgroundView = UIView()
        backgroundView.backgroundColor = .systemGray5
        trans.selectedBackgroundView = backgroundView
        
        //Set Data Cell
        trans.title.text = usages[indexPath.row].title
        trans.date.text = setDateToString(usages[indexPath.row].date)
        let price = setDecimalToString(amountValue: usages[indexPath.row].price)
       
        if usages[indexPath.row].status == .pengeluaran {
            trans.imageStatus.image = UIImage(named: "Arrow_Down_BG")
            trans.price.textColor = AppColor.mainRed
            trans.price.text = "-Rp \(price)"
        } else {
            trans.price.textColor = UIColor.systemGreen
            trans.imageStatus.image = UIImage(named: "Arrow_Up_BG")
            trans.price.textColor = AppColor.mainGreen
            trans.price.text = "+Rp \(price)"
        }
        
        return trans
    }
    
}

extension Date {
    var hour: Int { return Calendar.current.component(.hour, from: self) }
}
