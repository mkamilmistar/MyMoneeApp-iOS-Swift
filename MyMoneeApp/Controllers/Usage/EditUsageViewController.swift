//
//  EditUsageViewController.swift
//  MyMoneeApp
//
//  Created by MacBook on 12/05/21.
//

import UIKit

class EditUsageViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UITextFieldDelegate {

    @IBOutlet var usageTypeCollection: UICollectionView!
    @IBOutlet var titleTxtField: UITextField!
    @IBOutlet var priceTxtField: UITextField!
    @IBOutlet var customBtn: AnotherButton!
    
    var updateButton: UIButton!
    var deleteButton: UIButton!
    
    private var usageTypeData: Int? 
    
    var passIndex: Int!
    var userData: User = AuthUser.data
    var passBalance: Decimal = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //set Style init
        updateButton = customBtn.firstButton
        updateButton.setTitle("Perbarui", for: .normal)
        
        deleteButton = customBtn.secondButton
        deleteButton.setTitle("Hapus", for: .normal)
        
        enabledMainButton(updateButton)
        mainDeleteButton(deleteButton)
        
        usageTypeCollection.delegate = self
        usageTypeCollection.dataSource = self
        usageTypeCollection.allowsMultipleSelection = false
        
        let uiNib = UINib(nibName: String(describing: UsageTypeCell.self), bundle: nil)
        usageTypeCollection.register(uiNib, forCellWithReuseIdentifier: String(describing: UsageTypeCell.self))
        
        titleTxtField.delegate = self
        priceTxtField.delegate = self
        customBtn.delegate = self
        
        //Set Value
        titleTxtField.text = usages[passIndex].title
        priceTxtField.text = setDecimalToString(amountValue: usages[passIndex].amount)
        
        //Initialize Selected Value
        if usages[passIndex].status == .moneyIn {
            usageTypeData = 0
        } else {
            usageTypeData = 1
        }
        
    }
    
    //when select
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let cell = collectionView.cellForItem(at: indexPath)
    
        cell?.layer.borderColor = AppColor.mainPurple.cgColor
        cell?.layer.borderWidth = 3.0
        cell?.layer.cornerRadius = 8.0
        
        usageTypeData = indexPath.row
        
        if (titleTxtField.text != "") && (priceTxtField.text != "") {
            enabledMainButton(updateButton)
        }
        
    }
    
    //when deselect
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath)
        cell?.layer.borderWidth = 0
        cell?.layer.borderColor = UIColor.white.cgColor
        usageTypeCollection.deselectItem(at: indexPath, animated: false)

    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categoryUsage.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = usageTypeCollection.dequeueReusableCell(withReuseIdentifier: String(describing: UsageTypeCell.self), for: indexPath) as! UsageTypeCell
        
        //Selected in First Show
        if indexPath.row == usageTypeData {
            usageTypeCollection.selectItem(at: indexPath, animated: true, scrollPosition: .centeredHorizontally)
            selectBorder(cell)
        } else {
           deselectBorder(cell)
        }
        
        //Shadow View
        setShadow(cell)
        
        cell.title.text = categoryUsage[indexPath.row].label
        
        if categoryUsage[indexPath.row].type == .moneyIn {
            cell.imageStatus.image = UIImage(named: "Arrow_Up")
        }
        else if categoryUsage[indexPath.row].type == .moneyOut{
            cell.imageStatus.image = UIImage(named: "Arrow_Down")
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width / 2 - 10, height: 75)
    }
    
}

extension EditUsageViewController {
    @IBAction func backToDetailUsage(_ sender: UITapGestureRecognizer) {
        self.navigationController?.popViewController(animated: true)
    }
    
    //button condition
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {

        let txtField = (textField.text! as NSString).replacingCharacters(in: range, with: string)

        if txtField.isEmpty || usageTypeData == nil {
            disabledMainButton(updateButton)
        } else {
            enabledMainButton(updateButton)
        }
        return true
    }
   
    func updateUsage() {
        let id = usages[passIndex].id
        let title = titleTxtField.text ?? ""
        let amount = setStringToDecimal(
            amountValue: priceTxtField.text?.replacingOccurrences(of: ".", with: "") ?? "")
        let date = usages[passIndex].date
        var status: UsageType
        
        if usageTypeData == 0 {
            status = .moneyIn
            passBalance = userData.balance - usages[passIndex].amount
          
            if status != usages[passIndex].status {
                userData.balance = userData.balance + (amount*2)
            } else {
                userData.balance = passBalance + amount
            }
            
        } else {
            status = .moneyOut
            passBalance = userData.balance + usages[passIndex].amount
            
            if status != usages[passIndex].status {
                userData.balance = userData.balance - (amount*2)
            } else {
                userData.balance = passBalance - amount
            }
            
        }

        usages[passIndex] = Usage(id: id, title: title, price: amount, date: date, status: status, UserId: userData.id)
        
    }
    
    func deleteUsage(){
        //Balance Conditional
        if usages[passIndex].status == .moneyIn {
            userData.balance -= usages[passIndex].amount
        } else {
            userData.balance += usages[passIndex].amount
        }
        
        //Delete
        usages.remove(at: passIndex)
        
        //Navigate
        self.navigationController?.popToRootViewController(animated: true)
    }
}

extension EditUsageViewController: AnotherButtonDelegate {
    func firstBtnAction() {
        updateUsage()
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    func secondBtnAction() {
        let alert = UIAlertController(title: "Menghapus Penggunaan", message: "Apakah anda yakin ingin menghapus penggunaan \"\(usages[passIndex].title)\" ?", preferredStyle: .alert)
        
        let deleteButton = UIAlertAction(title: "Hapus", style: .destructive) { (_) -> Void in
            self.deleteUsage()
        }
        
        let cancelButton = UIAlertAction(title: "Batal", style: .cancel)
        
        alert.addAction(cancelButton)
        alert.addAction(deleteButton)
        
        present(alert, animated: true, completion: nil)
    }
    
}
