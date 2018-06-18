//
//  swift
//  Audition
//
//  Created by Panghu Lee on 2018/6/17.
//  Copyright © 2018 Panghu Lee. All rights reserved.
//

import UIKit
import MediaPlayer

class PlayboardView: UIView {
    
    enum Style {
        case fold
        case unfold
    }
    
    public var style: Style = .unfold {
        didSet { didSetStyle() }
    }
    
    private let playlist = AudioPlayerList.default
    
    public let audioTabbar = AudioTabbar()
    public let foldItem = ArrowFoldItem()
    public let coverImageView = UIImageView(image: UIImage(named: "AudioIcon"))
    
    public let progressSlider = UISlider()
    
    private let currentTimeLabel = UILabel()
    private let durationLabel = UILabel()
    private let nameLabel = UILabel()
    
    private let previousItem = UIButton()
    private let nextItem = UIButton()
    private let playItem = UIButton()
    
    public let slider = UISlider()
    private var volumeViewSlider: UISlider?
    private let volumeminLabel = UILabel()
    private let volumemaxLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        NotificationCenter.default.addObserver(self, selector: #selector(audioPlayChangeProgress(_:)), name: AudioPlayer.audioPlayChangeProgressNotification, object: playlist.audioPlayer)
        NotificationCenter.default.addObserver(self, selector: #selector(audioPlayChangeState(_:)), name: AudioPlayer.audioPlayChangeStateNotification, object: playlist.audioPlayer)
        NotificationCenter.default.addObserver(self, selector: #selector(audioPlayChangeFile(_:)), name: AudioPlayer.audioPlayChangeFileNotification, object: playlist.audioPlayer)
        NotificationCenter.default.addObserver(self, selector: #selector(systemVolumeDidChange(_:)), name: NSNotification.Name(rawValue: "AVSystemController_SystemVolumeDidChangeNotification"), object: nil)
        
        addSubview(audioTabbar)
        addSubview(coverImageView)
        addSubview(progressSlider)
        addSubview(foldItem)
    }
    
    override func sizeThatFits(_ size: CGSize) -> CGSize {
        let width = UIScreen.main.bounds.width - 62 * 2
        var height = width + 62
        height += progressSlider.sizeThatFits(size).height + 62
        height += currentTimeLabel.sizeThatFits(size).height + 10
        height += nameLabel.sizeThatFits(size).height + 40
        height += playItem.sizeThatFits(size).height + 30
        height += slider.sizeThatFits(size).height + 15
        height += 20
        return CGSize.init(width: UIScreen.main.bounds.width, height: height)
    }
    
    override func sizeToFit() {
        frame.size = sizeThatFits(CGSize.zero)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc private func onClickPrevious(_ sender: UIControl) {
        playlist.previous()
    }
    
    @objc private func onClickNext(_ sender: UIControl) {
        playlist.next()
    }
    
    @objc private func onClickPlay(_ sender: UIControl) {
        if playlist.isPlaying {
            playlist.suspend()
        } else {
            playlist.resume()
        }
    }
    
    @objc private func onChangeVolume(_ sender: UIControl) {
        volumeViewSlider?.value = slider.value
        volumeViewSlider?.sendActions(for: .valueChanged)
    }
    
    @objc private func onChangeProgress(_ sender: UIControl) {
        playlist.seek(to: Double(progressSlider.value) * playlist.duration)
    }
    
    @objc private func audioPlayChangeProgress(_ sender: NSNotification) {
        if !progressSlider.isTracking {
            currentTimeLabel.text = timeToString(playlist.currentTime)
            durationLabel.text = timeToString(playlist.duration)
            progressSlider.value = Float(playlist.currentTime / playlist.duration)
        }
    }
    
    @objc private func audioPlayChangeState(_ sender: NSNotification) {
        playItem.setTitle(String(playlist.isPlaying ? .pause : .play), for: .normal)
    }
    
    @objc private func audioPlayChangeFile(_ sender: NSNotification) {
        nameLabel.text = playlist.currentSource?.name
    }
    
    @objc private func systemVolumeDidChange(_ sender: NSNotification) {
        if let volume = sender.userInfo?["AVSystemController_AudioVolumeNotificationParameter"] as? NSNumber {
            slider.value = volume.floatValue
        }
    }
    
    func timeToString(_ time: TimeInterval) -> String {
        let date = Date.init(timeIntervalSince1970: time)
        let format = DateFormatter()
        format.dateFormat = "mm:ss"
        return format.string(from: date)
    }
    
}

extension PlayboardView {
    
    public func didSetStyle() {
        
        switch style {
        case .fold:
            audioTabbar.alpha = 1
            foldItem.alpha = 0
            progressSlider.alpha = 0.1
            currentTimeLabel.alpha = 0.1
            durationLabel.alpha = 0.1
            coverImageView.snp.remakeConstraints { maker in
                maker.edges.equalTo(audioTabbar.icon)
            }
            progressSlider.snp.remakeConstraints { maker in
                maker.leading.equalToSuperview().inset(25)
                maker.width.equalTo(UIScreen.main.bounds.width - 50)
                maker.top.equalTo(coverImageView.snp.bottom).offset(10)
            }
            break
        case .unfold:
            audioTabbar.alpha = 0
            foldItem.alpha = 1
            progressSlider.alpha = 1
            currentTimeLabel.alpha = 1
            durationLabel.alpha = 1
            let width = UIScreen.main.bounds.width - 62 * 2
            coverImageView.snp.remakeConstraints { maker in
                maker.width.height.equalTo(width)
                maker.top.leading.equalToSuperview().inset(62)
            }
            progressSlider.snp.remakeConstraints { maker in
                maker.leading.equalToSuperview().inset(25)
                maker.width.equalTo(UIScreen.main.bounds.width - 50)
                maker.top.equalTo(coverImageView.snp.bottom).offset(62)
            }
            break
        }
    }
    
    override func jo_setupSubviews() {
        super.jo_setupSubviews()
        setupAudioTabbar()
        setupCover()
        setupTimeLable()
        setupItem()
        setupSlider()
        setupProgress()
    }
    
    override func jo_makeSubviewsLayout() {
        super.jo_makeSubviewsLayout()
        
        foldItem.snp.makeConstraints { maker in
            maker.centerX.equalToSuperview()
            maker.top.equalToSuperview()
        }
        
        currentTimeLabel.snp.makeConstraints { maker in
            maker.leading.equalTo(progressSlider).offset(-2)
            maker.top.equalTo(progressSlider.snp.bottom).offset(10)
        }
        
        durationLabel.snp.makeConstraints { maker in
            maker.trailing.equalTo(progressSlider).offset(2)
            maker.top.equalTo(progressSlider.snp.bottom).offset(10)
        }
        
        nameLabel.snp.makeConstraints { maker in
            maker.centerX.equalToSuperview()
            maker.top.equalTo(progressSlider.snp.bottom).offset(40)
            maker.width.equalToSuperview().multipliedBy(0.8)
        }
        
        playItem.snp.makeConstraints { maker in
            maker.centerX.equalToSuperview()
            maker.top.equalTo(nameLabel.snp.bottom).offset(30)
        }
        
        nextItem.snp.makeConstraints { maker in
            maker.centerY.equalTo(playItem)
            maker.leading.equalTo(playItem.snp.trailing).offset(55)
        }
        
        previousItem.snp.makeConstraints { maker in
            maker.centerY.equalTo(playItem)
            maker.trailing.equalTo(playItem.snp.leading).offset(-55)
        }
        
        slider.snp.makeConstraints { maker in
            maker.centerX.equalToSuperview()
            maker.top.equalTo(playItem.snp.bottom).offset(15)
            maker.width.equalToSuperview().multipliedBy(0.78)
        }
        
        volumeminLabel.snp.makeConstraints { maker in
            maker.centerY.equalTo(slider)
            maker.trailing.equalTo(slider.snp.leading).offset(-5)
        }
        
        volumemaxLabel.snp.makeConstraints { maker in
            maker.centerY.equalTo(slider)
            maker.leading.equalTo(slider.snp.trailing).offset(5)
        }
    }
    
    private func setupAudioTabbar() {
        audioTabbar.contentView.jo.setSeparator(.top)
        audioTabbar.frame.origin = .zero
        audioTabbar.icon.isHidden = true
    }
    
    private func setupCover() {
        coverImageView.clipsToBounds = true
        coverImageView.layer.cornerRadius = 5
    }
    
    private func setupTimeLable() {
        currentTimeLabel.font = .systemFont(ofSize: 13)
        currentTimeLabel.textColor = .lightGray
        currentTimeLabel.text = "--:--"
        addSubview(currentTimeLabel)
        
        durationLabel.font = .systemFont(ofSize: 13)
        durationLabel.textColor = .lightGray
        durationLabel.text = "--:--"
        addSubview(durationLabel)
        
        nameLabel.font = .boldSystemFont(ofSize: 30)
        nameLabel.textColor = .black
        nameLabel.text = "Not Playing"
        nameLabel.textAlignment = .center
        nameLabel.numberOfLines = 2
        nameLabel.text = playlist.currentSource?.name ?? "Not Playing"
        addSubview(nameLabel)
    }
    
    private func setupItem() {
        previousItem.titleLabel?.font = UIFont(icon: 40)
        previousItem.setTitle(String(.previous), for: .normal)
        previousItem.setTitleColor(UIColor(white: 0.35, alpha: 1), for: .normal)
        previousItem.addTarget(self, action: #selector(onClickPrevious(_:)), for: .touchUpInside)
        addSubview(previousItem)
        
        nextItem.titleLabel?.font = UIFont(icon: 40)
        nextItem.setTitle(String(.next), for: .normal)
        nextItem.setTitleColor(UIColor(white: 0.35, alpha: 1), for: .normal)
        nextItem.addTarget(self, action: #selector(onClickNext(_:)), for: .touchUpInside)
        addSubview(nextItem)
        
        playItem.titleLabel?.font = UIFont(icon: 55)
        playItem.setTitle(String(playlist.isPlaying ? .pause : .play), for: .normal)
        playItem.setTitleColor(.black, for: .normal)
        playItem.addTarget(self, action: #selector(onClickPlay(_:)), for: .touchUpInside)
        addSubview(playItem)
    }
    
    private func setupProgress() {
        progressSlider.isContinuous = false;
        progressSlider.minimumTrackTintColor = UIColor(white: 0.35, alpha: 1)
        progressSlider.value = Float(playlist.currentTime / playlist.duration)
        progressSlider.addTarget(self, action: #selector(onChangeProgress(_:)), for: .valueChanged)
        progressSlider.thumbTintColor = .clear
        addSubview(progressSlider)
    }
    
    private func setupSlider() {

        volumeminLabel.font = UIFont(icon: 22)
        volumeminLabel.text = String(.volumemin)
        volumeminLabel.textColor = UIColor(white: 0.35, alpha: 1)
        addSubview(volumeminLabel)
        
        volumemaxLabel.font = UIFont(icon: 22)
        volumemaxLabel.text = String(.volumemax)
        volumemaxLabel.textColor = UIColor(white: 0.35, alpha: 1)
        addSubview(volumemaxLabel)
        
        slider.minimumTrackTintColor = UIColor(white: 0.35, alpha: 1)
        slider.value = AVAudioSession.sharedInstance().outputVolume
        slider.addTarget(self, action: #selector(onChangeVolume(_:)), for: .valueChanged)
        addSubview(slider)
        
        let volumeViewnew = MPVolumeView()
        for subview in volumeViewnew.subviews where NSStringFromClass(subview.classForCoder) == "MPVolumeSlider" {
            if let volumeSlider = subview as? UISlider {
                volumeViewSlider = volumeSlider
            }
        }
    }
    
}
