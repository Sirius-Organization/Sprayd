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

struct ArtAnnotationTip: Tip {
    var title: Text {
        Text("Discover map pins")
    }
    
    var message: Text? {
        Text("Tap on the pins to learn more about the artists and their works.")
    }
    
    var image: Image? {
        Image(systemName: "mappin.circle")
    }
}

