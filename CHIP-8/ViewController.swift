//
//  ViewController.swift
//  CHIP-8
//
//  Created by Lukáš Hromadník on 16/04/2020.
//  Copyright © 2020 Lukáš Hromadník. All rights reserved.
//

import UIKit
import Chip8

class PixelView: UIView {
    private let width: Int
    private let height: Int
    let pixels: [UIView]

    init(width: Int, height: Int) {
        self.width = width
        self.height = height

        var pixels: [UIView] = []
        for _ in 0..<height {
            for _ in 0..<width {
                pixels.append(UIView())
            }
        }
        self.pixels = pixels

        super.init(frame: .zero)

        setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setup() {
        let spacing: CGFloat = 0
        for i in 0..<height {
            for j in 0..<width {
                let pixel = pixels[i * width + j]
                pixel.backgroundColor = .black
                addSubview(pixel)
                pixel.translatesAutoresizingMaskIntoConstraints = false
                var constraints: [NSLayoutConstraint] = []
                if i == 0 {
                    constraints.append(pixel.topAnchor.constraint(equalTo: topAnchor))
                }

                if i + 1 == height {
                    constraints.append(pixel.bottomAnchor.constraint(equalTo: bottomAnchor))
                }

                if i > 0 {
                    constraints.append(pixel.topAnchor.constraint(equalTo: pixels[(i - 1) * width + j].bottomAnchor, constant: spacing))
                }

                if j == 0 {
                    constraints.append(pixel.leadingAnchor.constraint(equalTo: leadingAnchor))
                }

                if j + 1 == width {
                    constraints.append(pixel.trailingAnchor.constraint(equalTo: trailingAnchor))
                }

                if j > 0 {
                    constraints.append(pixel.leadingAnchor.constraint(equalTo: pixels[i * width + (j - 1)].trailingAnchor, constant: spacing))
                }

                constraints.append(pixel.heightAnchor.constraint(equalTo: pixel.widthAnchor))
                constraints.append(pixel.widthAnchor.constraint(equalTo: pixels[0].widthAnchor))

                NSLayoutConstraint.activate(constraints)
            }
        }
    }
}

enum Rom: String {
    case brix = "BRIX"
    case connect4 = "CONNECT4"
    case maze = "MAZE"
    case pong = "PONG"
    case test = "test.c8"
    case puzzle = "PUZZLE"
    case ticTacToe = "TICTACTOE"
}

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

        let rom: Rom = .puzzle
        let chip8 = Chip8(rom: rom.rawValue)
        chip8.onDisplayUpdate = { display in
            for i in 0..<display.count {
                pixelView.pixels[i].backgroundColor = display[i] > 0 ? .white : .black
            }
        }
        chip8.run()
    }
}

