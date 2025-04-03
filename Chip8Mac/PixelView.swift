//
//  PixelView.swift
//  Chip8Mac
//
//  Created by Lukáš Hromadník on 29/04/2020.
//  Copyright © 2020 Lukáš Hromadník. All rights reserved.
//

import Cocoa

class PixelView: NSView {
    private let width: Int
    private let height: Int
    let pixels: [NSView]

    init(width: Int, height: Int) {
        self.width = width
        self.height = height

        var pixels: [NSView] = []
        for _ in 0..<height {
            for _ in 0..<width {
                pixels.append(NSView())
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
                pixel.wantsLayer = true
                pixel.layer?.backgroundColor = NSColor.black.cgColor
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
