//
//  UserProfileAssembly.swift
//  Sprayd
//
//  Created by loxxy on 09.04.2026.
//

import SwiftUI

struct UserProfileAssembly {
    func build(
        username: String = "Username",
        bio: String = "Description",
        posts: [ArtItem] = []
    ) -> some View {
        UserProfileView(
            viewModel: UserProfileViewModel(
                username: username,
                bio: bio,
                posts: posts
            )
        )
    }
}
