//
//  MapView.swift
//  Sprayd
//
//  Created by Егор Мальцев on 31.03.2026.
//

import SwiftUI
import MapKit

struct MainMapView: View {
    @State private var viewModel = MainMapViewModel()

    var body: some View {
        @Bindable var viewModel = viewModel

        Map(position: $viewModel.position) {
            ForEach(viewModel.markers) { marker in
                Marker(marker.title, coordinate: marker.coordinate)
            }
        }
        .ignoresSafeArea()
    }
}

#Preview {
    MainMapView()
}
