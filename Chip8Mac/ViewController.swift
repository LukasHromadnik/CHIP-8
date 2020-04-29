//
//  ViewController.swift
//  Chip8Mac
//
//  Created by Lukáš Hromadník on 29/04/2020.
//  Copyright © 2020 Lukáš Hromadník. All rights reserved.
//

import Cocoa
import Chip8

let kSelectedRom: ROM = .maze

class ViewController: NSViewController {
    private weak var selectRomButton: NSButton!
    private weak var pixelView: PixelView!

    private let chip8 = Chip8(rom: kSelectedRom.rawValue)

    // MARK: - Lifecycle

    override func loadView() {
        view = NSView()

        let selectROMButton = NSButton(title: "Select ROM", target: self, action: #selector(selectRomButtonTapped))

        let contentStackView = NSStackView(views: [selectROMButton, NSView()])
        view.addSubview(contentStackView)
        contentStackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            contentStackView.topAnchor.constraint(equalTo: view.topAnchor, constant: 8),
            contentStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8),
            contentStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8),
        ])

        let pixelView = PixelView(width: 64, height: 32)
        view.addSubview(pixelView)
        pixelView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            pixelView.topAnchor.constraint(equalTo: contentStackView.bottomAnchor, constant: 8),
            pixelView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            pixelView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            pixelView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        self.pixelView = pixelView
    }

    override func viewDidAppear() {
        super.viewDidAppear()

        chip8.onDisplayUpdate = { [weak self] display in
            for i in 0..<display.count {
                self?.pixelView.pixels[i].layer?.backgroundColor = display[i] > 0 ? NSColor.white.cgColor : NSColor.black.cgColor
            }
        }
        chip8.run()
    }

    // MARK: - Actions

    @objc
    private func selectRomButtonTapped(_ sender: NSButton) {

    }
}
