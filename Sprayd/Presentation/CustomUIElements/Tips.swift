//
//  MapTips.swift
//  Sprayd
//
//  Created by лизо4ка курунок on 08.04.2026.
//

import TipKit

enum TipEvents {
    static let firstClosed = Tips.Event(id: "firstClosed")
}

struct MapTip: Tip {
    var title: Text {
        Text("The city is a gallery")
    }
    
    var message: Text? {
        Text("Explore the world map of street art and add your own discoveries to it.")
    }
    
    var image: Image? {
        Image(systemName: "map.fill")
    }
}

struct FeedTip: Tip {
    var title: Text {
        Text("Find new piece of art here")
    }
    
    var message: Text? {
        Text("Search, city selections, interesting art objects nearby")
    }
    
    var image: Image? {
        Image(systemName: "magnifyingglass")
    }
}

