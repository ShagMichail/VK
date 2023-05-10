//
//  ViewController.swift
//  vk
//
//  Created by Михаил Шаговитов on 05.05.2023.
//

import UIKit

final class ConditionsVC: UIViewController {
    
    lazy var contentView = ConditionsView(delegate: self, textFieldDelegat: self)

    override func loadView() {
        view = contentView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavBar()
    }
    
    private func setupNavBar() {
        navigationController?.navigationBar.isHidden = true
    }}

extension ConditionsVC: ConditionsViewDelegate {
    func didTapSimulateButton(quantity: UITextField, numberContacts: UITextField, periodContacts: UITextField) {
        let quantity = quantity.text!
        let numberContacts = numberContacts.text!
        let periodContacts = periodContacts.text!
        
        if (!quantity.isEmpty && !numberContacts.isEmpty && !periodContacts.isEmpty) {
            let controller = SimulationVC(quantity: Int(quantity) ?? 0,
                                          numberContacts: Int(numberContacts) ?? 0,
                                          periodContacts: Int(periodContacts) ?? 0)
            navigationController?.pushViewController(controller, animated: true)
        } else {
            let alert = UIAlertController(title: "Обратите внимание", message: "Не все поля были введены корректно!", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "ОК", style: .cancel))
            self.present(alert, animated: true, completion: nil)
        }
    }
}

extension ConditionsVC: TextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
