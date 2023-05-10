//
//  SimulationView.swift
//  vk
//
//  Created by Михаил Шаговитов on 05.05.2023.
//

import UIKit
import SnapKit

protocol SimulationViewDelegate: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    
    func didTapBackButton()
}

final class SimulationView: UIView {
    
    weak var delegate: SimulationViewDelegate?
    
    lazy var headerView: CustomHeader = {
        var view = CustomHeader()
        view.backgroundColor = UIColor(named: "red")
        view.navTitle.text = "Симуляция"
        return view
    }()
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.showsVerticalScrollIndicator = false
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.register(SimulationCell.self, forCellWithReuseIdentifier: "cell")
        return cv
    }()
    
    lazy var healthyLabel: UILabel = {
        var label = UILabel()
        label.font = .systemFont(ofSize: 20)
        return label
    }()
    
    lazy var sickLabel: UILabel = {
        var label = UILabel()
        label.font = .systemFont(ofSize: 20)
        return label
    }()
    
    required init(delegate: SimulationViewDelegate) {
        super.init(frame: .zero)
        setupElement()
        addSubviews()
        makeConstraints()
        collectionView.delegate = delegate
        collectionView.dataSource = delegate
        self.delegate = delegate
    }
    
    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupElement() {
        headerView.backButton.addTarget(self, action: #selector(didTapBackButton), for: .touchUpInside)
    }
    
    private func addSubviews() {
        addSubview(headerView)
        addSubview(collectionView)
        addSubview(sickLabel)
        addSubview(healthyLabel)
    }
    
    private func makeConstraints() {
        headerView.snp.makeConstraints {
            $0.top.equalTo(0)
            $0.leading.trailing.equalTo(safeAreaLayoutGuide)
            $0.height.equalTo(120)
        }
        
        healthyLabel.snp.makeConstraints {
            $0.top.equalTo(headerView.snp.bottom).inset(-10)
            $0.height.equalTo(30)
            $0.leading.equalTo(safeAreaLayoutGuide).inset(20)
        }
        
        sickLabel.snp.makeConstraints {
            $0.top.equalTo(headerView.snp.bottom).inset(-10)
            $0.height.equalTo(30)
            $0.trailing.equalTo(safeAreaLayoutGuide).inset(20)
        }
        
        collectionView.snp.makeConstraints {
            $0.top.equalTo(sickLabel.snp.bottom).inset(-10)
            $0.bottom.equalTo(0)
            $0.leading.trailing.equalTo(safeAreaLayoutGuide).inset(30)
        }
    }
    
    @objc func didTapBackButton() {
        delegate?.didTapBackButton()
    }
}
