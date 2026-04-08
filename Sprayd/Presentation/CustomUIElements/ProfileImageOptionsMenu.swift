//
//  ProfileImageOptionsMenu.swift
//  Sprayd
//
//  Created by loxxy on 07.04.2026.
//

import SwiftUI

struct ProfileImageOptionsMenu: View {
    // MARK: - Fields
    private var choosePhotoLibrary: () -> Void
    private var chooseCamera: () -> Void
    
    // MARK: - Lifecycle
    init(
        choosePhotoLibrary: @escaping () -> Void,
        chooseCamera: @escaping () -> Void
    ) {
        self.choosePhotoLibrary = choosePhotoLibrary
        self.chooseCamera = chooseCamera
    }
    
    // MARK: - Body
    var body: some View {
        VStack(spacing: 0) {
            ProfileImageOptionButton(
                title: "Choose from Library",
                icon: Icons.photo
            ) {
                choosePhotoLibrary()
            }
            
            Divider()
                .padding(.horizontal, Metrics.oneAndHalfModule)
            
            ProfileImageOptionButton(
                title: "Take Photo",
                icon: Icons.camera
            ) {
                chooseCamera()
            }
        }
        .frame(width: 220)
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 18))
    }
}
