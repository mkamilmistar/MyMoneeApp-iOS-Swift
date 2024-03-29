//
//  AddImpianViewController.swift
//  MyMoneeApp
//
//  Created by MacBook on 12/05/21.
//

import UIKit

class AddDreamViewController: UIViewController {

    @IBOutlet var customButton: CustomButton!
    @IBOutlet var formInput: FormInput!
    @IBOutlet var navigationBar: NavigationBar!
    
    var saveButton: UIButton!
    var titleField: UITextField!
    var targetAmountField: UITextField!
    var userData: User = AuthUser.data
    var dreamService = DreamService()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        formInput.titleLabel.text = "Judul"
        formInput.amountLabel.text = "Target Capaian (Rp)"
        saveButton = customButton.mainButton
        saveButton.setTitle("Simpan", for: .normal)
        disabledMainButton(saveButton)
        
        titleField = formInput.titleField
        titleField.delegate = self
        targetAmountField = formInput.amountField
        targetAmountField.delegate = self
        customButton.delegate = self
        navigationBar.delegate = self
        navigationBar.navigationLabel.text = "Tambah Impian"
        setupLoadingView()
    }
}

extension AddDreamViewController: CustomButtonDelegate {
    func customButtonAction() {
        let dreamId: String = NSUUID().uuidString
        let title: String = titleField.text ?? ""
        let targetAmount: Decimal = (targetAmountField.text ?? "").setStringToDecimal
        
        loadingIndicator.isAnimating = true
        dreamService.addDream(dreamDataModel: DreamResponse(
                                dreamId: dreamId, title: title, targetAmount:
                                    targetAmount, userId: String(userData.userId))) {
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                Helper.showToast("Impian Berhasil Disimpan")
                loadingIndicator.isAnimating = false
                self.navigationController?.popToRootViewController(animated: true)
            }
        }
    
    }
}

extension AddDreamViewController: UITextFieldDelegate {
    // button condition
    func textField(_ textField: UITextField,
                   shouldChangeCharactersIn range: NSRange,
                   replacementString string: String) -> Bool {

        let txtField = (textField.text! as NSString).replacingCharacters(in: range, with: string)
        
        if txtField.isEmpty || titleField.text == "" || targetAmountField.text == "" {
            disabledMainButton(saveButton)
        } else {
            enabledMainButton(saveButton)
        }
        
        return true
    }
}

extension AddDreamViewController: NavigationBarDelegate {
    func backBtnAction() {
        self.navigationController?.popToRootViewController(animated: true)
    }
}
