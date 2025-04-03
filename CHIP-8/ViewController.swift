//
//  ViewController.swift
//  CHIP-8
//
//  Created by Lukáš Hromadník on 16/04/2020.
//  Copyright © 2020 Lukáš Hromadník. All rights reserved.
//

import UIKit
import Chip8

let kSelectedRom: ROM = .brix

class KeyButton: UIButton {
    override var bounds: CGRect {
        didSet {
            layer.cornerRadius = bounds.size.height / 2
            layer.borderColor = tintColor.cgColor
            layer.borderWidth = 1
        }
    }
}

class KeyboardView: UIView {
    var onKeyDown: ((Int) -> Void)?
    var onKeyUp: ((Int) -> Void)?

    // MARK: - Initialization

    override init(frame: CGRect) {
        super.init(frame: frame)

        setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setup() {
        let keys = [1, 2, 3, 0xC, 4, 5, 6, 0xD, 7, 8, 9, 0xE, 0xA, 0, 0xB, 0xF]
        let buttons: [KeyButton] = keys.map {
            let keyButton = KeyButton(type: .system)
            keyButton.setTitle(String(format: "%X", $0), for: .normal)
            keyButton.translatesAutoresizingMaskIntoConstraints = false
            keyButton.tag = $0
            keyButton.addTarget(self, action: #selector(keyButtonDown), for: .touchDown)
            keyButton.addTarget(self, action: #selector(keyButtonUp), for: .touchUpInside)
            keyButton.addTarget(self, action: #selector(keyButtonUp), for: .touchUpOutside)
            NSLayoutConstraint.activate([
                keyButton.heightAnchor.constraint(equalTo: keyButton.widthAnchor)
            ])
            return keyButton
        }

        let rows: [UIStackView] = stride(from: 0, to: buttons.count, by: 4).map { i in
            let row = UIStackView(arrangedSubviews: Array(buttons[i..<i + 4]))
            row.spacing = 8
            row.distribution = .fillEqually
            return row
        }
        let contentView = UIStackView(arrangedSubviews: rows)
        contentView.spacing = 8
        contentView.axis = .vertical
        addSubview(contentView)
        contentView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: topAnchor),
            contentView.leadingAnchor.constraint(equalTo: leadingAnchor),
            contentView.bottomAnchor.constraint(equalTo: bottomAnchor),
            contentView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }

    // MARK: - Actions

    @objc
    private func keyButtonDown(_ sender: KeyButton) {
        onKeyDown?(sender.tag)
    }

    @objc
    private func keyButtonUp(_ sender: KeyButton) {
        onKeyUp?(sender.tag)
    }
}

class ViewController: UIViewController {
    private weak var pixelView: PixelView!
    private weak var keyboardView: KeyboardView!

    private let chip8 = Chip8(rom: kSelectedRom.rawValue)

    // MARK: - Lifecycle

    override func loadView() {
        super.loadView()

        view.backgroundColor = .systemBackground

        let pixelView = PixelView(width: 64, height: 32)
        pixelView.layer.borderWidth = 1
        pixelView.layer.borderColor = UIColor.white.cgColor
        view.addSubview(pixelView)
        pixelView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            pixelView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 32),
            pixelView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            pixelView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        self.pixelView = pixelView

        let keyboardView = KeyboardView()
        view.addSubview(keyboardView)
        keyboardView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            keyboardView.topAnchor.constraint(equalTo: pixelView.bottomAnchor, constant: 48),
            keyboardView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            keyboardView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16)
        ])
        self.keyboardView = keyboardView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        chip8.onDisplayUpdate = { [weak self] display in
            for i in 0..<display.count {
                self?.pixelView.pixels[i].backgroundColor = display[i] > 0 ? .white : .black
            }
        }
        keyboardView.onKeyDown = chip8.press

        keyboardView.onKeyUp = chip8.release
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        chip8.run()
    }
}

