//
//  ViewController.swift
//  ExampleAVPlayer
//
//  Created by 황재현 on 4/16/24.
//

import UIKit
import AVFoundation
import SnapKit
import Then
import RxSwift
import RxCocoa
import RxAVFoundation


class ViewController: UIViewController {
    /// 뷰모델
    var vm = MainVM()
    
    var viewPlayer = CustomVideoView().then {
        $0.backgroundColor = .black
    }
    /// 영상 길이
    var duration: String = ""
    /// URL
    var urlString = "http://qthttp.apple.com.edgesuite.net/1010qwoeiuryfg/sl.m3u8"
    
    /// 영상 정지인지 아닌지 체크
    var isPause: Bool = false
    
    lazy var playButton = UIButton().then {
        $0.setTitle(isPause == true ? "실행" : "정지", for: .normal)
        $0.backgroundColor = .blue
    }
    
    /// 처음으로 되돌리기 버튼
    var resetButton = UIButton().then {
        $0.setTitle("처음으로", for: .normal)
        $0.backgroundColor = .red
    }
    
    var disposeBag = DisposeBag()
    
    // MARK: - viewDidLoad()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        
        bindingVM()
    }
    
    
    func configureUI() {
        view.addSubview(viewPlayer)
        
        viewPlayer.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.leading.trailing.equalTo(view)
            make.height.equalTo(480)
        }
        
        view.addSubview(playButton)
        
        view.addSubview(resetButton)
        
        resetButton.snp.makeConstraints { make in
            make.leading.trailing.equalTo(view)
            make.bottom.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(44)
        }
        
        playButton.snp.makeConstraints { make in
            make.leading.trailing.equalTo(view)
            make.bottom.equalTo(resetButton.snp.topMargin).inset(-16)
            make.height.equalTo(44)
        }
        
        /// 플레이어 URL
        guard let url = URL(string: urlString) else { return }
        let item = AVPlayerItem(url: url)
        
        let player = AVPlayer(playerItem: item)
        viewPlayer.player = player
        viewPlayer.player?.volume = 1
        viewPlayer.player?.play()
    }
    
    func bindingVM() {
        // 실행 및 정지버튼 타이틀 바인딩
        vm.buttonName
            .bind(to: playButton.rx.title())
            .disposed(by: disposeBag)
        
        playButton.rx.tap.subscribe { [weak self] tap in
            guard let self = self else { return }
            print("playButton click")
            self.isPause.toggle()
            
            self.changeButtonTitle(isPause: self.isPause)
        }.disposed(by: disposeBag)
        
        resetButton.rx.tap.subscribe { [weak self] _ in
            guard let self = self else { return }
            print("resetButton click")
            // 플레이어 처음으로 돌림
            viewPlayer.player?.seek(to: .zero)
            self.isPause = false
            self.changeButtonTitle(isPause: self.isPause)
        }.disposed(by: disposeBag)
        
        viewPlayer.player?.rx.status.subscribe(onNext: { [weak self] status in
            guard let self = self else { return }
            switch status {
            case .readyToPlay:
                print("status = readyToPlay")
            case .failed:
                print("status = failed")
            case .unknown:
                print("status = unknown")
            }
        }).disposed(by: disposeBag)
        
        viewPlayer.player?.rx.rate.subscribe(onNext: { [weak self] rate in
            guard let self = self else { return }
            print("rata = \(rate)")
        }).disposed(by: disposeBag)
        
        viewPlayer.player?.rx.currentItem.subscribe(onNext: { [weak self] item in
            guard let self = self else { return }
//            print("item = \(String(describing: item?.duration))")
            var second = CMTimeGetSeconds(item!.duration)
            print("item = \(second)")
        }).disposed(by: disposeBag)
        
        viewPlayer.player?.rx.timeControlStatus.subscribe(onNext: { [weak self] control in
            guard let self = self else { return }
            print("control = \(control)")
        }).disposed(by: disposeBag)
    }
    
    /// 버튼 타이틀 변경
    func changeButtonTitle(isPause: Bool) {
        vm.buttonName.onNext(isPause == true ? "실행" : "정지")
        isPause == true ? viewPlayer.player?.pause() : viewPlayer.player?.play()
    }
}

