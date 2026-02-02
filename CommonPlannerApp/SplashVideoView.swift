//
//  SplashVideoView.swift
//  CommonPlannerApp
//
//  Created by Furkan Akar on 2.02.2026.
//

import SwiftUI
import AVFoundation

struct SplashVideoView: UIViewRepresentable {
    let player: AVPlayer

    func makeUIView(context: Context) -> UIView {
        let view = PlayerUIView()
        view.backgroundColor = UIColor.white
        view.playerLayer.player = player
        view.playerLayer.videoGravity = .resizeAspect // oranı koru, stretch yok
        return view
    }

    func updateUIView(_ uiView: UIView, context: Context) {
        guard let v = uiView as? PlayerUIView else { return }
        v.playerLayer.player = player
    }
}

final class PlayerUIView: UIView {
    override class var layerClass: AnyClass { AVPlayerLayer.self }
    var playerLayer: AVPlayerLayer { layer as! AVPlayerLayer }

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        backgroundColor = .white
    }
}
