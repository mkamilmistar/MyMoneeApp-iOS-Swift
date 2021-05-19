//
//  AddUsageViewController.swift
//  MyMoneeApp
//
//  Created by MacBook on 12/05/21.
//

import UIKit

class AddUsageViewController: UIViewController {

    @IBOutlet var usagesTypeCollection: UICollectionView!
    @IBOutlet var customButton: CustomButton!
    @IBOutlet var formInput: FormInput!
    
    var usageTypeData: Int? = nil
    var userData: User = AuthUser.data
    var saveButton: UIButton!
    var titleTxtField: UITextField!
    var amountTxtField: UITextField!
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Set Button
        saveButton = customButton.mainButton
        saveButton.setTitle("Simpan", for: .normal)
        disabledMainButton(saveButton)
        
        usagesTypeCollection.delegate = self
        usagesTypeCollection.dataSource = self
        usagesTypeCollection.allowsMultipleSelection = false
        
        let uiNib = UINib(nibName: String(describing: UsageTypeCell.self), bundle: nil)
        usagesTypeCollection.register(uiNib, forCellWithReuseIdentifier: String(describing: UsageTypeCell.self))
        
        formInput.titleLabel.text = "Judul"
        titleTxtField = formInput.titleField
        titleTxtField.delegate = self
        
        formInput.amountLabel.text = "Jumlah (Rp)"
        amountTxtField = formInput.AmountField
        amountTxtField.delegate = self
        customButton.delegate = self
        
    }
    
    @IBAction func backHome(_ sender: Any) {
        self.navigationController?.popToRootViewController(animated: true)
    }
}

extension AddUsageViewController: UITextFieldDelegate {
    //button condition
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {

        let txtField = (textField.text! as NSString).replacingCharacters(in: range, with: string)

        if txtField.isEmpty || usageTypeData == nil || titleTxtField.text == "" || amountTxtField.text == "" {
            disabledMainButton(saveButton)
        } else {
            enabledMainButton(saveButton)
        }
        
        return true
    }
}

extension AddUsageViewController: CustomButtonDelegate {
    //SAVE
    func customButtonAction() {
        let id: String = String.randomCapitalizeWithNumber()
        let title: String = titleTxtField.text ?? ""
        let price: Decimal = Decimal.setStringToDecimal(amountValue: amountTxtField.text ?? "")
        let status: UsageType
        
        if usageTypeData == 0 {
            status = .moneyIn
            userData.balance += price
        } else {
            status = .moneyOut
            userData.balance -= price
        }
        
        //Input To Array
        usages.append(Usage(id: id, title: title, price: price, date: Date(), status: status, UserId: userData.userId))
        
        self.navigationController?.popToRootViewController(animated: true)
    }
}

extension AddUsageViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    //when select
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath)
        cell?.layer.borderColor = AppColor.mainPurple.cgColor
        cell?.layer.borderWidth = 3.0
        cell?.layer.cornerRadius = 8.0
        
        //Asign data usageTypeData
        usageTypeData = indexPath.row
        
        if (titleTxtField.text != "") && (amountTxtField.text != "") {
            enabledMainButton(saveButton)
        }
        
    }
    
    //when deselect
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath)
        cell?.layer.borderWidth = 0
        cell?.layer.borderColor = UIColor.white.cgColor
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categoryUsage.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = usagesTypeCollection.dequeueReusableCell(withReuseIdentifier: String(describing: UsageTypeCell.self), for: indexPath) as! UsageTypeCell
        
        setShadow(cell)
        
        cell.title.text = categoryUsage[indexPath.row].label
        
        if categoryUsage[indexPath.row].type == .moneyIn {
            cell.imageStatus.image = UIImage(named: categoryUsage[indexPath.row].icon)
        } else {
            cell.imageStatus.image = UIImage(named: categoryUsage[indexPath.row].icon)
        }
        
        return cell

    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width / 2 - 10, height: 75)
    }
}
