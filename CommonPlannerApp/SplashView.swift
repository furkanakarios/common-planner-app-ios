//
//  SplashView.swift
//  CommonPlannerApp
//
//  Created by Furkan Akar on 2.02.2026.
//

import SwiftUI
import AVKit

struct SplashView: View {
    @State private var player: AVPlayer?
    @State private var isActive = false

    var body: some View {
        Group {
            if isActive {
                HomeView()
            } else {
                ZStack {
                    Color.white.ignoresSafeArea()

                    if let player {
                        SplashVideoView(player: player)
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .ignoresSafeArea()
                    }
                }
            }
        }
        .onAppear {
            playVideo()
        }
    }

    private func playVideo() {
        guard let url = Bundle.main.url(forResource: "splash", withExtension: "mp4") else {
            // Video bulunamazsa direkt Home'a geç
            isActive = true
            return
        }

        let player = AVPlayer(url: url)
        self.player = player

        // Video bittiğinde Home'a geç
        NotificationCenter.default.addObserver(
            forName: .AVPlayerItemDidPlayToEndTime,
            object: player.currentItem,
            queue: .main
        ) { _ in
            withAnimation(.easeOut(duration: 0.3)) {
                isActive = true
            }
        }

        player.play()
    }
}
