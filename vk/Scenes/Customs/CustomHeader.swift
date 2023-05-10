//
//  CustomHeader.swift
//  vk
//
//  Created by Михаил Шаговитов on 05.05.2023.
//

import Foundation
import UIKit

final class CustomHeader: UIView {
    
    lazy var navTitle: UILabel = {
        var label = UILabel()
        label.textAlignment = .center
        label.textColor = .white
        return label
    }()
    
    lazy var backButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tintColor = .white
        button.setImage(UIImage(systemName: "arrowshape.turn.up.left"), for: .normal)
        button.imageView?.isUserInteractionEnabled = false
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupElement()
        addSubviews()
        makeConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupElement() {
        navTitle.font = navTitle.font.withSize(30)
    }
    
    private func addSubviews() {
        addSubview(navTitle)
        addSubview(backButton)
    }
    
    private func makeConstraints() {
        backButton.snp.makeConstraints {
            $0.leading.equalTo(safeAreaLayoutGuide).inset(20)
            $0.bottom.equalTo(safeAreaLayoutGuide).inset(20)
            $0.height.equalTo(30)
            $0.width.equalTo(30)
        }

        navTitle.snp.makeConstraints {
            $0.leading.equalTo(backButton.snp.trailing).inset(-20)
            $0.bottom.equalTo(safeAreaLayoutGuide).inset(20)
            $0.leading.equalTo(safeAreaLayoutGuide).inset(20).priority(.low)
        }
    }
}

