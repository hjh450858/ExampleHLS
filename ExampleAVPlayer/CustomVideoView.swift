//
//  CustomPlayer.swift
//  ExampleAVPlayer
//
//  Created by 황재현 on 4/16/24.
//

import Foundation
import AVFoundation
import UIKit


/// 커스텀된 플레이어
class CustomVideoView: UIView {
    /// 재정의
    override class var layerClass: AnyClass {
        return AVPlayerLayer.self
    }
    
    /// 플레이어 레이어
    var playerLayer: AVPlayerLayer {
        let layer = layer as! AVPlayerLayer
        // 영상비율 설정
        layer.videoGravity = .resizeAspect
        return layer
    }
    /// 플레이어
    var player: AVPlayer? {
        get {
            return playerLayer.player
        }
        
        set {
            playerLayer.player = newValue
        }
    }
}
