//
//  ViewController.swift
//  Chip8Mac
//
//  Created by Lukáš Hromadník on 29/04/2020.
//  Copyright © 2020 Lukáš Hromadník. All rights reserved.
//

import Cocoa
import Chip8

let kSelectedRom: ROM = .tetris
let kRegisteredKeys: [UInt16] = [
    18, 19, 20, 21, // 1, 2, 3, 4
    12, 13, 14, 15, // q, w, e, r
    0, 1, 2, 3,     // a, s, d, f
    6, 7, 8, 9      // y, x, c, v
]
let kRegisteredKeysMapping: [UInt16: Int] = [
    18: 1,   19: 2, 20: 3,  21: 0xC,
    12: 4,   13: 5, 14: 6,  15: 0xD,
     0: 7,    1: 8,  2: 9,   3: 0xE,
     6: 0xA,  7: 0,  8: 0xB, 9: 0xF
]

class ViewController: NSViewController {
    private weak var selectRomButton: NSButton!
    private weak var pixelView: PixelView!

    private let chip8 = Chip8(rom: kSelectedRom.rawValue)

    // MARK: - Lifecycle

    override func loadView() {
        view = NSView()

        let selectROMButton = NSButton(title: "Select ROM", target: self, action: #selector(selectRomButtonTapped))
        let restartButton = NSButton(title: "Restart", target: self, action: #selector(restartButtonTapped))

        let contentStackView = NSStackView(views: [selectROMButton, restartButton, NSView()])
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

    override func viewDidLoad() {
        super.viewDidLoad()

        NSEvent.addLocalMonitorForEvents(matching: .keyDown) { [weak self] in
            guard kRegisteredKeys.contains($0.keyCode) else { return $0 }
            self?.onKeyDown($0)
            return nil
        }

        NSEvent.addLocalMonitorForEvents(matching: .keyUp) { [weak self] in
            guard kRegisteredKeys.contains($0.keyCode) else { return $0 }
            self?.onKeyUp($0)
            return nil
        }
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
        print(#function)
    }

    @objc
    private func restartButtonTapped(_ sender: NSButton) {
        chip8.restart()
    }

    private func onKeyDown(_ event: NSEvent) {
        guard let key = kRegisteredKeysMapping[event.keyCode] else { assertionFailure(); return }
        chip8.press(key)
    }

    private func onKeyUp(_ event: NSEvent) {
        guard let key = kRegisteredKeysMapping[event.keyCode] else { assertionFailure(); return }
        chip8.release(key)
    }
}
