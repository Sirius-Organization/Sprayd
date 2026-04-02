//
//  ProfileView.swift
//  Sprayd
//
//  Created by Егор Мальцев on 01.04.2026.
//

import SwiftUI

struct ProfileView: View {
    // MARK: - Constants
    private enum Const {
        // Strings
        static let buttonBottomText: String = "Add new street"
        
        // UI constraint properties
        static let profileImageSize: CGFloat = 160
        static let profileImageCornerRadius: CGFloat = profileImageSize / 2
        
        // Fonts
        static let usernameFont: Font = .custom("Climate Crisis", size: 22)
        static let descriptionFont: Font = .custom("InstrumentSans-Medium", size: 13)
        static let optionsFont: Font = .custom("InstrumentSans-Medium", size: 16)
        static let sectionTitleFont: Font = .custom("Climate Crisis", size: 20)
        static let buttonBottomTextFont: Font = .custom("InstrumentSans-Medium", size: 13)
    }
    
    // MARK: - Fields
    @State private var selectedOption = "Posted"
    
    // MARK: - Body
    var body: some View {
        ZStack {
            Color(Color.appBackground)
                        .ignoresSafeArea()
            
            
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    Image(systemName: "person.crop.circle.fill")
                        .resizable()
                        .frame(width: Const.profileImageSize, height: Const.profileImageSize)
                        .cornerRadius(Const.profileImageCornerRadius)
                        .frame(maxWidth: .infinity)
                    
                    HStack {
                        Text("Username")
                            .font(Const.usernameFont)
                        Image(systemName: "pencil")
                    }
                    .frame(maxWidth: .infinity)
                    
                    HStack {
                        Text("Description")
                            .font(Const.descriptionFont)
                        Image(systemName: "pencil")
                    }
                    .frame(maxWidth: .infinity)
                    
                    Picker("", selection: $selectedOption) {
                        Text("Posted").tag("Posted")
                        Text("Visited").tag("Visited")
                    }
                    .pickerStyle(.segmented)
                    .padding(.horizontal)
                    
                    Text("Posted")
                        .frame(maxWidth: 150)
                        .font(Const.sectionTitleFont)
                    
                    VStack(alignment: .center) {
                        AddButton()
                        
                        Text(Const.buttonBottomText)
                            .font(Const.buttonBottomTextFont)
                    }
                    .frame(maxWidth: .infinity)
                    
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
    }
}

#Preview {
    ProfileView()
}
