//
//  ViewController.swift
//  CHIP-8
//
//  Created by Lukáš Hromadník on 16/04/2020.
//  Copyright © 2020 Lukáš Hromadník. All rights reserved.
//

import UIKit
import Chip8

class ViewController: UIViewController {
    weak var collectionView: UICollectionView!

    var display: [UInt8] = [] {
        didSet {
            collectionView.reloadData()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .lightGray

        let collectionViewLayout = UICollectionViewFlowLayout()
        collectionViewLayout.itemSize = CGSize(width: 4, height: 4)
        collectionViewLayout.minimumInteritemSpacing = 1
        collectionViewLayout.sectionInset = UIEdgeInsets(top: 1, left: 0, bottom: 0, right: 0)

        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout)
        collectionView.backgroundColor = .clear
        collectionView.dataSource = self
//        collectionView.delegate = self
        view.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
        self.collectionView = collectionView

        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "Cell")

        let chip8 = Chip8()
        chip8.onDisplayUpdate = { [weak self] in self?.display = $0 }
        chip8.run()
    }
}

extension ViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        32
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        64
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let index = indexPath.item + indexPath.section * 32
        if index >= display.count {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath)
            cell.backgroundColor = .white
            return cell
        }

        let color: UIColor = display[index] == 1 ? .black : .white

        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath)
        cell.backgroundColor = color
        return cell
    }
}

