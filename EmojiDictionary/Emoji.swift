//
//  Emoji.swift
//  EmojiDictionary
//
//  Created by Eliana Boado on 2/21/19.
//  Copyright © 2019 Eliana Boado. All rights reserved.
//

import Foundation

struct Emoji {
    var symbol: String;
    var name: String;
    var description: String;
    var usage: String;
    init(symbol: String, name: String, description: String, usage: String) {
        self.symbol = symbol;
        self.name = name;
        self.description = description;
        self.usage = usage
    }
}
