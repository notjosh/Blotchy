//
//  ContextService.swift
//  Blotchy
//
//  Created by Joshua May on 21/6/18.
//  Copyright © 2018 Joshua May. All rights reserved.
//

import Foundation

class ContextService {
    static let shared: ContextService = ContextService()

    var contexts: [Context] {
        return _contexts
    }

    fileprivate var _contexts: [Context]

    init() {
        let searchEngines = SearchEngineService.shared.searchEngines

        self._contexts = [
            Context(name: "Swift", searchEngine: searchEngines[1 % searchEngines.count], terms: ["-site:apple.com", "swift"]),
            Context(name: "objc", searchEngine: searchEngines[1 % searchEngines.count], terms: ["-site:apple.com", "objective-c"]),
            Context(name: "JavaScript", searchEngine: searchEngines[1 % searchEngines.count], terms: ["javascript"]),
            Context(name: "CSS via SO", searchEngine: searchEngines[2 % searchEngines.count], terms: ["css"]),
            Context(name: "(context 4)", searchEngine: searchEngines[3 % searchEngines.count], terms: ["foo", "bar"]),
            Context(name: "(context 5)", searchEngine: searchEngines[4 % searchEngines.count], terms: ["bar", "baz"]),
            Context(name: "(context 6)", searchEngine: searchEngines[5 % searchEngines.count], terms: ["foo", "bar"]),
            Context(name: "(context 7)", searchEngine: searchEngines[6 % searchEngines.count], terms: ["bar", "baz"]),
            Context(name: "(context 8)", searchEngine: searchEngines[7 % searchEngines.count], terms: ["foo", "bar"]),
            Context(name: "(context 9)", searchEngine: searchEngines[8 % searchEngines.count], terms: ["bar", "baz"]),
        ]
    }

    func update(_ context: Context, at index: Int) {
        guard _contexts.indices.contains(index) else {
            return
        }

        _contexts[index] = context
    }

    func remove(at index: Int) {
        _contexts.remove(at: index)
    }
}
