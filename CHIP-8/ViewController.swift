//
//  ViewController.swift
//  CHIP-8
//
//  Created by Lukáš Hromadník on 16/04/2020.
//  Copyright © 2020 Lukáš Hromadník. All rights reserved.
//

import UIKit
import Chip8

let kSelectedRom: Rom = .puzzle

class ViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .lightGray

        let pixelView = PixelView(width: 64, height: 32)
        view.addSubview(pixelView)
        pixelView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            pixelView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 32),
            pixelView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            pixelView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])

        let chip8 = Chip8(rom: kSelectedRom.rawValue)
        chip8.onDisplayUpdate = { display in
            for i in 0..<display.count {
                pixelView.pixels[i].backgroundColor = display[i] > 0 ? .white : .black
            }
        }
        chip8.run()
    }
}

