//
//  InfoView.swift
//  vk
//
//  Created by Михаил Шаговитов on 05.05.2023.
//

import UIKit
import SnapKit

protocol TextFieldDelegate: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
}

protocol ConditionsViewDelegate: AnyObject {
    func didTapSimulateButton(quantity: UITextField, numberContacts: UITextField, periodContacts: UITextField)
}

final class ConditionsView: UIView {
    
    weak var delegate: ConditionsViewDelegate?
    weak var textFieldDelegat: TextFieldDelegate?
    
    lazy var headerView: CustomHeader = {
        var view = CustomHeader()
        view.navTitle.text = "Как на этот раз?"
        view.backButton.removeFromSuperview()
        view.backgroundColor = UIColor(named: "red")
        return view
    }()
    
    lazy var bloodImageView: UIImageView = {
        var imageView = UIImageView()
        imageView.image = UIImage(named: "blood")
        imageView.sizeToFit()
        return imageView
    }()
    
    lazy var quantityLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.textColor = UIColor.black
        label.numberOfLines = 2
        label.text = "Сколько людей рассматриваем?"
        return label
    }()
    
    lazy var quantityTextField: CustomTextField = {
        let tf = CustomTextField(placeholder: "Введите количество")
        tf.returnKeyType = .done
        tf.textContentType = .telephoneNumber
        tf.keyboardType = .numberPad
        tf.keyboardAppearance = .light
        tf.addDoneCanselToolBar()
        return tf
    }()
    
    lazy var numberContactsLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.textColor = UIColor.black
        label.text = "Сколько человек заражаются при контакте?"
        return label
    }()
    
    lazy var numberContactsTextField: CustomTextField = {
        let tf = CustomTextField(placeholder: "Введите количество")
        tf.returnKeyType = .done
        tf.textContentType = .telephoneNumber
        tf.keyboardType = .numberPad
        tf.keyboardAppearance = .light
        tf.addDoneCanselToolBar()
        return tf
    }()
    
    lazy var periodContactsLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.textColor = UIColor.black
        label.text = "Как часто проверяем зараженных?"
        return label
    }()

    lazy var periodContactsTextField: CustomTextField = {
        let tf = CustomTextField(placeholder: "Введите время")
        tf.returnKeyType = .done
        tf.textContentType = .telephoneNumber
        tf.keyboardType = .numberPad
        tf.keyboardAppearance = .light
        tf.addDoneCanselToolBar()
        return tf
    }()
    
    lazy var simulateButton: UIButton = {
        var button = UIButton(type: .system)
        
        button.setTitle("Запустить моделирование", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .regular)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = UIColor(named: "red")
        
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOffset = CGSize(width: 0.0, height: 10.0)
        button.layer.shadowOpacity = 0.3
        button.layer.shadowRadius = 10
        button.layer.cornerRadius = 20
        button.addTarget(self, action: #selector(didTapSimulateButton), for: .touchUpInside)
        return button
    }()
    
    required init(delegate: ConditionsViewDelegate, textFieldDelegat: TextFieldDelegate) {
        super.init(frame: .zero)
        self.delegate = delegate
        self.textFieldDelegat = textFieldDelegat
        addSubviews()
        makeConstraints()
        setupElement()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupElement() {
//        headerView.backButton.addTarget(self, action: #selector(didTapMenuButton), for: .touchUpInside)
        quantityTextField.delegate = textFieldDelegat
        numberContactsTextField.delegate = textFieldDelegat
        periodContactsTextField.delegate = textFieldDelegat
    }
    
    private func addSubviews() {
        addSubview(headerView)
        addSubview(bloodImageView)
        addSubview(quantityLabel)
        addSubview(quantityTextField)
        addSubview(numberContactsLabel)
        addSubview(numberContactsTextField)
        addSubview(periodContactsLabel)
        addSubview(periodContactsTextField)
        addSubview(simulateButton)
    }
    
    /// Устанавливаем констрейнты
    private func makeConstraints() {
        headerView.snp.makeConstraints {
            $0.top.equalTo(0)
            $0.leading.trailing.equalTo(safeAreaLayoutGuide)
            $0.height.equalTo(120)
        }
        
        bloodImageView.snp.makeConstraints {
            $0.top.equalTo(headerView.snp.bottom).inset(9)
            $0.leading.trailing.equalTo(safeAreaLayoutGuide)
            $0.height.equalTo(180)
        }
        
        quantityLabel.snp.makeConstraints {
            $0.top.equalTo(bloodImageView.snp.bottom).inset(80)
            $0.leading.trailing.equalTo(safeAreaLayoutGuide).inset(30)
        }
        
        quantityTextField.snp.makeConstraints {
            $0.top.equalTo(quantityLabel.snp.bottom).inset(-10)
            $0.leading.trailing.equalTo(safeAreaLayoutGuide).inset(30)
        }
        
        numberContactsLabel.snp.makeConstraints {
            $0.top.equalTo(quantityTextField.snp.bottom).inset(-20)
            $0.leading.trailing.equalTo(safeAreaLayoutGuide).inset(30)
        }
        
        numberContactsTextField.snp.makeConstraints {
            $0.top.equalTo(numberContactsLabel.snp.bottom).inset(-10)
            $0.leading.trailing.equalTo(safeAreaLayoutGuide).inset(30)
        }
        
        periodContactsLabel.snp.makeConstraints {
            $0.top.equalTo(numberContactsTextField.snp.bottom).inset(-20)
            $0.leading.trailing.equalTo(safeAreaLayoutGuide).inset(30)
        }
        
        periodContactsTextField.snp.makeConstraints {
            $0.top.equalTo(periodContactsLabel.snp.bottom).inset(-10)
            $0.leading.trailing.equalTo(safeAreaLayoutGuide).inset(30)
        }
        
        simulateButton.snp.makeConstraints {
            $0.top.equalTo(periodContactsTextField.snp.bottom).inset(-20)
            $0.leading.trailing.equalTo(safeAreaLayoutGuide).inset(30)
            $0.height.equalTo(50)
        }
    }
    
    @objc func didTapSimulateButton(quantity: UITextField, numberContacts: UITextField, periodContacts: UITextField) {
        delegate?.didTapSimulateButton(quantity: self.quantityTextField,
                                       numberContacts: self.numberContactsTextField,
                                       periodContacts: self.periodContactsTextField)
    }
}
