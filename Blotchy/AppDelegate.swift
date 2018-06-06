//
//  AppDelegate.swift
//  Blotchy
//
//  Created by Joshua May on 5/6/18.
//  Copyright © 2018 Joshua May. All rights reserved.
//

import Cocoa

let SearchWindowControllerIdentifier = "SearchWindowController"

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    var cursorGestureTracker: CursorGestureTracker = CursorGestureTracker()

    var searchWindowController: SearchWindowController? {
        get {
            return NSApp
                .windows
                .compactMap { $0.windowController }
                .first { $0 is SearchWindowController } as? SearchWindowController
        }
    }

    static var shared: AppDelegate {
        get {
            return NSApp.delegate as! AppDelegate
        }
    }

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        cursorGestureTracker.delegate = self
        cursorGestureTracker.start()
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        cursorGestureTracker.stop()
    }

    var storyboard: NSStoryboard {
        get {
            return NSStoryboard.main!
        }
    }
}

extension AppDelegate: CursorGestureTrackerDelegate {
    func didFlingLeft() {
        print("made it left")

        searchWindowController?.close()
    }

    func didFlingRight() {
        print("made it right")

        let grabber = AccessibilitySelectedTextGrabber()

        guard let selectedText = grabber.selectedTextInActiveApp() else {
            print("can't find any selected text, dammit")
            return
        }

        // we should only have one of these windows, okay
        if let searchWindowController = searchWindowController {
            searchWindowController.searchTerm = selectedText
            return
        }

        let wc = storyboard.instantiateController(withIdentifier: SearchWindowControllerIdentifier)

        guard let swc = wc as? SearchWindowController else {
            return
        }

        swc.searchTerm = selectedText

        swc.window?.level = .floating
        swc.window?.isReleasedWhenClosed = true
        swc.window?.makeKeyAndOrderFront(self)
    }
}
