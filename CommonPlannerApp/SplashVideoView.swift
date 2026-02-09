//
//  SplashVideoView.swift
//  CommonPlannerApp
//
//  Created by Furkan Akar on 2.02.2026.
//

import SwiftUI
import AVFoundation
import AVKit

struct SplashVideoView: View {
    let url: URL
    let isTransitioning: Bool
    let onVideoFinished: () -> Void



    @State private var frontPlayer = AVPlayer()
    @State private var backPlayer  = AVPlayer()

    @State private var videoAspectRatio: CGFloat = 16.0 / 9.0

    var body: some View {
        ZStack {
            // Background: fill + blur (no black bars feeling)
            PlayerLayerView(player: backPlayer, videoGravity: .resizeAspectFill)
                .ignoresSafeArea()
                .blur(radius: 14)
                .overlay(Color.black.opacity(0.03))
                .opacity(isTransitioning ? 0.92 : 1.0)
                .animation(.easeInOut(duration: 0.55), value: isTransitioning)


            // Foreground: guaranteed "fit" (no cropping)
            PlayerLayerView(
                player: frontPlayer,
                videoGravity: isTransitioning ? .resizeAspectFill : .resizeAspect
            )
                .aspectRatio(videoAspectRatio, contentMode: isTransitioning ? .fill : .fit)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
                .overlay(EdgeFadeOverlay().clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous)))
                .mask(SoftEdgeMask())
                .scaleEffect(isTransitioning ? 2.4 : 1.0)
                .opacity(isTransitioning ? 0.0 : 1.0)
                .animation(.easeInOut(duration: 0.40).delay(0.10), value: isTransitioning)

        }
        .onAppear {
            setupPlayers()
        }
        .onDisappear {
            frontPlayer.pause()
            backPlayer.pause()
        }
    }

    private func setupPlayers() {
        let item1 = AVPlayerItem(url: url)
        let item2 = AVPlayerItem(url: url)

        frontPlayer.replaceCurrentItem(with: item1)
        if let item = frontPlayer.currentItem {
            NotificationCenter.default.addObserver(
                forName: .AVPlayerItemDidPlayToEndTime,
                object: item,
                queue: .main
            ) { _ in
                onVideoFinished()
            }
        }

        backPlayer.replaceCurrentItem(with: item2)

        // Splash best-practice
        frontPlayer.isMuted = false
        backPlayer.isMuted  = true

        frontPlayer.actionAtItemEnd = .pause
        backPlayer.actionAtItemEnd  = .pause

        // Read aspect ratio from asset track (so fit is true-to-video)
        let asset = AVAsset(url: url)
        if let track = asset.tracks(withMediaType: .video).first {
            let size = track.naturalSize.applying(track.preferredTransform)
            let w = abs(size.width)
            let h = abs(size.height)
            if h > 0 {
                videoAspectRatio = w / h
            }
        }

        backPlayer.play()
        frontPlayer.play()
    }
}

private struct PlayerLayerView: UIViewRepresentable {
    let player: AVPlayer
    let videoGravity: AVLayerVideoGravity

    func makeUIView(context: Context) -> PlayerUIView {
        let v = PlayerUIView()
        v.playerLayer.player = player
        v.playerLayer.videoGravity = videoGravity
        v.backgroundColor = .clear
        return v
    }

    func updateUIView(_ uiView: PlayerUIView, context: Context) {
        uiView.playerLayer.player = player
        uiView.playerLayer.videoGravity = videoGravity
    }
}

private final class PlayerUIView: UIView {
    override static var layerClass: AnyClass { AVPlayerLayer.self }
    var playerLayer: AVPlayerLayer { layer as! AVPlayerLayer }
}

private struct SoftEdgeMask: View {
    var body: some View {
        Rectangle()
            .fill(
                LinearGradient(
                    colors: [
                        .clear,
                        .white,
                        .white,
                        .clear
                    ],
                    startPoint: .leading,
                    endPoint: .trailing
                )
            )
            .overlay(
                Rectangle()
                    .fill(
                        LinearGradient(
                            colors: [
                                .clear,
                                .white,
                                .white,
                                .clear
                            ],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
            )
    }
}
private struct EdgeFadeOverlay: View {
    var body: some View {
        ZStack {
            // Kenarlarda çok hafif karartma (vignette)
            LinearGradient(
                colors: [
                    Color.black.opacity(0.10),
                    Color.clear,
                    Color.clear,
                    Color.black.opacity(0.10)
                ],
                startPoint: .leading,
                endPoint: .trailing
            )

            LinearGradient(
                colors: [
                    Color.black.opacity(0.10),
                    Color.clear,
                    Color.clear,
                    Color.black.opacity(0.10)
                ],
                startPoint: .top,
                endPoint: .bottom
            )
        }
        .blendMode(.multiply)
        .opacity(0.55) // fazla gelirse 0.35'e indir
        .allowsHitTesting(false)
    }
}
