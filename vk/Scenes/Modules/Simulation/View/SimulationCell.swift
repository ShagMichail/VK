//
//  SimulationViewCell.swift
//  vk
//
//  Created by Михаил Шаговитов on 05.05.2023.
//

import UIKit
import SnapKit

final class SimulationCell: UICollectionViewCell {
    
    var human: Human?
    
    lazy var containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOffset = CGSize(width: 0.0, height: 10.0)
        view.layer.shadowOpacity = 0.3
        view.layer.shadowRadius = 10
        view.layer.cornerRadius = 20
        view.backgroundColor = .systemGreen
        return view
    }()
    
    lazy var humanImage: UIImageView = {
       let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.sizeToFit()
        iv.layer.cornerRadius = 10
        return iv
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupAddition()
        setupElements()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        super .init(coder: coder)
    }
    
    func setupElements() {
        humanImage.image = UIImage(named: "human")
    }
    
    func configure(human: Human) {
        self.human = human
        containerView.backgroundColor = human.infection ? UIColor(named: "red") : .systemGreen
    }
    
    private func setupAddition() {
        contentView.addSubview(containerView)
        containerView.addSubview(humanImage)
    }
}

extension SimulationCell {
    
    func setupLayout() {
        
        containerView.snp.makeConstraints {
            $0.top.bottom.leading.trailing.equalTo(safeAreaLayoutGuide)
        }
        
        humanImage.snp.makeConstraints {
            $0.top.equalTo(containerView.snp.top).inset(20)
            $0.bottom.equalTo(containerView.snp.bottom).inset(20)
            $0.leading.equalTo(containerView.snp.leading).inset(0)
            $0.trailing.equalTo(containerView.snp.trailing).inset(0)
        }
    }
}

extension SimulationCell {
    
    static var nib  : UINib{
        return UINib(nibName: identifire, bundle: nil)
    }
    
    static var identifire : String{
        return String(describing: self)
    }
}

