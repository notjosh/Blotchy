//
//  SearchEngine.swift
//  Blotchy
//
//  Created by Joshua May on 21/6/18.
//  Copyright © 2018 Joshua May. All rights reserved.
//

import Foundation

struct SearchEngine {
    let name: String
    let template: String

    func url(for searchTerms: String) -> URL? {
        guard let encoded = searchTerms.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
            return nil
        }

        let string = template
            .replacingOccurrences(of: "{searchTerms}", with: encoded)
            .replacingOccurrences(of: "{inputEncoding?}", with: "UTF-8")
            .replacingOccurrences(of: "{outputEncoding?}", with: "UTF-8")

        return URL(string: string)
    }
}
