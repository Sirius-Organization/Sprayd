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
        Image("pencilIcon")
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
    
    static var map: some View {
        Image("mapIcon")
            .renderingMode(.template)
            .foregroundColor(.accentRed)
    }
    
    static var home: some View {
        Image("homeIcon")
            .renderingMode(.template)
            .foregroundColor(.accentRed)
    }
    
    static var profileIcon: some View {
        Image("profileIcon")
            .renderingMode(.template)
            .foregroundColor(.accentRed)
    }
    
    static var logOut: some View {
        Image(systemName: "rectangle.portrait.and.arrow.right")
            .foregroundStyle(Color.white)
    }
    
    static var validationCheckmark: some View {
        Image(systemName: "checkmark")
            .font(.system(size: 11, weight: .bold))
            .foregroundStyle(.white)
            .frame(width: 22, height: 22)
            .background(Color.green)
            .clipShape(Circle())
    }
    
    static var validationXmark: some View {
        Image(systemName: "xmark")
            .font(.system(size: 11, weight: .bold))
            .foregroundStyle(.white)
            .frame(width: 22, height: 22)
            .background(Color.red)
            .clipShape(Circle())
    }
}
