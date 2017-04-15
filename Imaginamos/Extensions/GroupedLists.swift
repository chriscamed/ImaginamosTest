//
//  GroupedLists.swift
//  Imaginamos
//
//  Created by Camilo Medina on 4/12/17.
//  Copyright © 2017 Imaginamos. All rights reserved.
//

import Foundation

public extension Sequence {
    func groupBy<U: Hashable>(_ key: (Iterator.Element) -> U) -> [U:[Iterator.Element]] {
        var categories: [U: [Iterator.Element]] = [:]
        for element in self {
            let key = key(element)
            if case nil = categories[key]?.append(element) {
                categories[key] = [element]
            }
        }
        return categories
    }
}
