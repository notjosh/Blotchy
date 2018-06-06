//
//  SearchWindowController.swift
//  Blotchy
//
//  Created by Joshua May on 5/6/18.
//  Copyright © 2018 Joshua May. All rights reserved.
//

import Cocoa
import CoreFoundation
import HighlightedWebView

class SearchWindowController: NSWindowController, SearchViewControllerDataSource {
    var searchViewController: SearchViewController? {
        get {
            guard let vc = contentViewController as? SearchViewController else {
                return nil
            }

            return vc
        }
    }

    var searchTerm: String = "" {
        didSet {
            window?.title = "Search: \(searchTerm)"
            searchViewController?.reload()
        }
    }

    override func windowDidLoad() {
        super.windowDidLoad()
    
        searchViewController?.dataSource = self

        // proooobably shouldn't be here, but we're the only window that matters for now eh
        NSApp.activate(ignoringOtherApps: true)

        window?.title = "Search: \(searchTerm)"
        window?.makeKeyAndOrderFront(self)

        if let screen = window?.screen {
            //let fraction: CGFloat = 2
            //let width = screen.visibleFrame.width / fraction
			let screenWidth: CGFloat = screen.visibleFrame.width
			let width: CGFloat = 1024 // smallest responsive size
			
            let frame = NSRect(x: screenWidth - width,
                               y: screen.visibleFrame.minY,
                               width: width,
                               height: screen.visibleFrame.height)

            window?.setFrame(frame, display: true)
        }
    }

}

protocol SearchViewControllerDataSource {
    var searchTerm: String { get }
}

class SearchViewController: NSViewController {
    @IBOutlet var searchEnginesPopUpButton: NSPopUpButton!
    @IBOutlet var searchResultsPopUpButton: NSPopUpButton!
    @IBOutlet var webView: DHWebView!

    var dataSource: SearchViewControllerDataSource?

    override func viewDidLoad() {
        super.viewDidLoad()

        go()
    }

    // MARK: Actions
    @IBAction func handleSearchEngineChange(sender: Any) {
        go()
    }

    func reload() {
        go()
    }

    // MARK: Helper
    func go() {
        guard
            let searchTerm = dataSource?.searchTerm,
            let url = URLForSearchTerm(searchTerm: searchTerm)
            else {
                return
        }

        let request = URLRequest(url: url)
        webView.mainFrame.load(request)
    }

    func URLForSearchTerm(searchTerm: String) -> URL? {
        guard let encoded = searchTerm.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
            return nil
        }

        switch searchEnginesPopUpButton.indexOfSelectedItem {
        case 0: // google
            return URL(string: "https://www.google.com/search?hl=en&q=\(encoded)")
        case 1: // ddg
            return URL(string: "https://duckduckgo.com/?q=\(encoded)")
        case 2: // so
            return URL(string: "https://stackoverflow.com/search?q=\(encoded)")
		case 3: // google I feel lucky
			let iFeelLuckyString : String = ("https://www.google.com/search?hl=en&q=\(encoded)" + "%20&btnI")
			// the '&btnI' is the 'I feel lucky' button. Apparently it won't always work. Works for me.
			return URL(string: iFeelLuckyString)
        default:
            return nil;
        }
    }
}

extension SearchViewController: WebResourceLoadDelegate {
    func webView(_ sender: WebView!, resource identifier: Any!, didFinishLoadingFrom dataSource: WebDataSource!) {
        print("didFinishLoadingFrom")
    }

    func webView(_ sender: WebView!, resource identifier: Any!, didFailLoadingWithError error: Error!, from dataSource: WebDataSource!) {
        print("didFailLoadingWithError")
    }
}

//extension SearchViewController: WKNavigationDelegate {
//    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
//    }
//
//    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
//    }
//
//    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
//    }
//}
//
//extension SearchViewController: WKUIDelegate {
//}



