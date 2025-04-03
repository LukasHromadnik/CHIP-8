//
//  AppDelegate.swift
//  Chip8Mac
//
//  Created by Lukáš Hromadník on 29/04/2020.
//  Copyright © 2020 Lukáš Hromadník. All rights reserved.
//

import Cocoa

final class AppDelegate: NSObject, NSApplicationDelegate {
    private var window: NSWindow?

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        let windowSize = NSSize(width: 640, height: 320 + 32)
        let screenSize = NSScreen.main?.frame.size ?? .zero
        let rect = NSRect(
            x: (screenSize.width - windowSize.width) / 2,
            y: (screenSize.height - windowSize.height) / 2,
            width: windowSize.width,
            height: windowSize.height
        )
        window = NSWindow(contentRect: rect, styleMask: [.miniaturizable, .closable, .resizable, .titled], backing: .buffered, defer: false)
        let controller = ViewController()
        controller.view.frame = NSRect(x: 0, y: 0, width: windowSize.width, height: windowSize.height)
        window?.contentViewController = controller
        window?.makeKeyAndOrderFront(nil)
    }
}
