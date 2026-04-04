//
//  Icons.swift
//  Sprayd
//
//  Created by лизо4ка курунок on 04.04.2026.
//

import SwiftUI

struct Icons {
    static var magnifyingGlass: some View {
        Image(systemName: "magnifyingglass")
            .foregroundStyle(.gray)
    }
    
    static var person: some View {
        Image(systemName: "person.fill")
            .foregroundStyle(.white)
    }
    
    static var chevronRight: some View {
        Image(systemName: "chevron.right")
            .foregroundStyle(.black.opacity(0.75))
    }
    
    static var location: some View {
        Image("locationIcon")
            .renderingMode(.template)
            .resizable()
            .scaledToFit()
            .frame(width: 18, height: 18)
    }
    
    static var photo: some View {
        Image(systemName: "photo")
    }
    
    static var personCircle: some View {
        Image(systemName: "person.crop.circle.fill")
            .resizable()
            .frame(maxWidth: .infinity)
    }
    
    static var pencil: some View {
        Image(systemName: "pencil")
    }
    
    static var plus: some View {
        Image(systemName: "plus")
    }
    
    static var heart: some View {
        Image("heartIcon")
            .renderingMode(.template)
            .resizable()
            .scaledToFit()
            .foregroundStyle(Color.accentRed)
            .frame(width: 18, height: 18)
    }
    
    static var filledHeart: some View {
        Image("filledHeartIcon")
            .renderingMode(.template)
            .resizable()
            .scaledToFit()
            .foregroundStyle(Color.accentRed)
            .frame(width: 18, height: 18)
    }
    
    static var checkmark: Image {
        Image("checkIcon")
    }
    
    static var camera: some View {
        Image(systemName: "camera")
            .fontWeight(.medium)
    }
    
    static var rightArrow: some View {
        Image("rightArrowIcon")
            .foregroundStyle(Color.white)
    }
    
    static var leftArrow: some View {
        Image("leftArrowIcon")
    }
}
