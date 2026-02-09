//
//  SplashView.swift
//  CommonPlannerApp
//
//  Created by Furkan Akar on 2.02.2026.
//

import SwiftUI

struct SplashView: View {
    @State private var isActive = false
    @State private var isTransitioning = false

    var body: some View {
        Group {
            if isActive {
                HomeView()
            } else {
                ZStack {
                    Color.white.ignoresSafeArea()

                    if let url = Bundle.main.url(forResource: "splash", withExtension: "mp4") {
                        SplashVideoView(
                            url: url,
                            isTransitioning: isTransitioning,
                            onVideoFinished: handleVideoFinished
                        )
                    } else {
                        // Video bulunamazsa direkt Home'a geç
                        HomeView()
                    }
                }
            }
        }
    }

    private func handleVideoFinished() {
        // 1) Zoom + fade animasyonunu başlat
        isTransitioning = true

        // 2) Animasyon bitince Home'a geç
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.55) {
            isActive = true
        }
    }
}
