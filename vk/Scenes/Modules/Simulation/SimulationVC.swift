//
//  SimulationVC.swift
//  vk
//
//  Created by Михаил Шаговитов on 05.05.2023.
//

import UIKit

final class SimulationVC: UIViewController {
    
    private var arrayHuman: [Human] = []
    private var arrayHummanCell: [SimulationCell] = []
    
    private var allSick: Int = 0
    private var allHealthy: Int = 0
    
    private var resultSick: Int = 0
    
    private var quantity: Int
    private var numberContacts: Int
    private var periodContacts: Int
    
    let simulationQueue = DispatchQueue(label: "simulation", qos: .background, attributes: .concurrent)
    
    lazy var contentView = SimulationView(delegate: self)
    
    required init(quantity: Int,
                  numberContacts: Int,
                  periodContacts: Int) {
        self.quantity = quantity
        self.numberContacts = numberContacts
        self.periodContacts = periodContacts
        self.allHealthy = quantity
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        generateHuman()
        setupView()
        addGesture()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupTabBar()
        setupNavBar()
    }
    
    override func loadView() {
        view = contentView
    }
    
    private func generateHuman() {
        for i in 1...quantity {
            let human = Human(index: i, infection: false)
            arrayHuman.append(human)
        }
        contentView.healthyLabel.text = "Здоровых: \(allHealthy)"
        contentView.sickLabel.text = "Больных: \(allSick)"
    }
    
    private func setupView() {
        view.backgroundColor = UIColor.white
    }
    
    private func setupNavBar() {
        navigationController?.navigationBar.isHidden = true
    }
    
    private func setupTabBar() {
        self.tabBarController?.tabBar.isHidden = false
    }
    
    private func addGesture() {
        let pinchGesture = UIPinchGestureRecognizer(target: self, action: #selector(pinchAction))
        contentView.collectionView.addGestureRecognizer(pinchGesture)
    }
    
    @objc func pinchAction(_ sender: UIPinchGestureRecognizer) {
        if let view = sender.view {
            view.transform = view.transform.scaledBy(x: sender.scale, y: sender.scale)
            sender.scale = 1
        }
    }
}

extension SimulationVC: SimulationViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width/4, height: collectionView.frame.width/4)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 15
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .init(top: 15, left: 15, bottom: 50, right: 15)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        guard let currentCell = collectionView.cellForItem(at: indexPath) as? SimulationCell else { return }
        let human = arrayHuman[indexPath.row]
        currentCell.containerView.backgroundColor = UIColor(named: "red")
        self.arrayHuman[(human.index - 1)].infection = true
        self.infectionSimulation(human: human, numberContacts: numberContacts, periodContacts: self.periodContacts)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.arrayHuman.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! SimulationCell
        arrayHummanCell.append(cell)
        let human = arrayHuman[indexPath.row]
        cell.configure(human: human)
        return cell
    }
    
    func didTapBackButton() {
        navigationController?.popToRootViewController(animated: true)
    }
    
}

extension SimulationVC {
    private func infectionSimulation(human: Human, numberContacts: Int, periodContacts: Int) {
        
        let simulationTime = Double(periodContacts)
        
        var afterIndex = human.index
        var beforeIndex = (human.index - 2)
        
        simulationQueue.asyncAfter(deadline: .now() + simulationTime, flags: .barrier) {
            if self.resultSick < self.quantity {
                
                let randomNumberContacts = Int.random(in: 0...numberContacts)
                
                for _ in 0..<randomNumberContacts {
                    let randomIndex = Int.random(in: 1...2)
                    
                    if randomIndex == 1 {
                        if afterIndex < self.quantity {
                            if !self.arrayHuman[afterIndex].infection {
                                self.arrayHuman[afterIndex].infection = true
                            }
                            afterIndex += 1
                        }
                    } else {
                        if beforeIndex >= 0 {
                            if !self.arrayHuman[beforeIndex].infection {
                                self.arrayHuman[beforeIndex].infection = true
                            }
                            beforeIndex -= 1
                        }
                    }
                }
                
                DispatchQueue.main.async {                         self.contentView.collectionView.reloadData()
                    for i in self.arrayHuman.indices {
                        if self.arrayHuman[i].infection {
                            if self.allSick < self.quantity {
                                self.allSick += 1
                            }
                            if self.allHealthy > 0 {
                                self.allHealthy -= 1
                            }
                        }
                    }
                    self.contentView.healthyLabel.text = "Здоровых: \(self.allHealthy)"
                    self.contentView.sickLabel.text = "Больных: \(self.allSick)"
                    self.resultSick = self.allSick
                    self.allHealthy = self.quantity
                    self.allSick = 0
                    if beforeIndex <= 0 {
                        beforeIndex = 1
                    }
                    if afterIndex > self.quantity - 1 {
                        afterIndex = self.quantity - 1
                    }
                    if self.resultSick < self.quantity {
                        if (!self.arrayHuman[beforeIndex].infection) || (!self.arrayHuman[afterIndex].infection)  {
                            self.infectionSimulation(human: self.arrayHuman[beforeIndex], numberContacts: numberContacts, periodContacts: self.periodContacts)
                            self.infectionSimulation(human: self.arrayHuman[afterIndex], numberContacts: numberContacts, periodContacts: self.periodContacts)
                        }
                    }
                }
            }
        }
    }
}
