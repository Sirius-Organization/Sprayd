//
//  ArtistProfileAssembly.swift
//  Sprayd
//
//  Created by loxxy on 09.04.2026.
//

import SwiftUI

struct ArtistProfileAssembly {
    func build(
        username: String = "Username",
        bio: String = "Description",
        works: [ArtItem] = []
    ) -> some View {
        ArtistProfileView(
            viewModel: ArtistProfileViewModel(
                username: username,
                bio: bio,
                works: works
            )
        )
    }
}
