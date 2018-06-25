//
//  AudioPlayer.swift
//  Audition
//
//  Created by Panghu Lee on 2018/6/9.
//  Copyright © 2018 Panghu Lee. All rights reserved.
//

import UIKit
import AVFoundation

public class AudioPlayer: NSObject {
    
    // MARK: Notification
    
    public static let audioPlayChangeProgressNotification: NSNotification.Name = NSNotification.Name(rawValue: "com.audioplayer.progress")
    public static let audioPlayChangeStateNotification: NSNotification.Name = NSNotification.Name(rawValue: "com.audioplayer.state")
    public static let audioPlayChangeFileNotification: NSNotification.Name = NSNotification.Name(rawValue: "com.audioplayer.file")
    
    public enum State {
        case playing
        case suspended
        case stop
        case completed(Error?)
    }
    
    // MARK: property
    
    public static let Sington = AudioPlayer()
    
    fileprivate (set) var source: FileManager.FileInfo?
    
    fileprivate (set) var state: State = .stop {
        didSet {
            DispatchQueue.main.async {
                NotificationCenter.default.post(name: AudioPlayer.audioPlayChangeStateNotification, object: self)
            }
        }
    }
    
    public var isPlaying: Bool { return audioPlayer?.isPlaying ?? false }
    public var duration: TimeInterval { return audioPlayer?.duration ?? 0 }
    public var currentTime: TimeInterval { return audioPlayer?.currentTime ?? 0 }
    
    // MARK: Private
    
    public override init() {
        super.init()
        
        NotificationCenter.default.addObserver(self, selector: #selector(audioSessionRouteChange(_:)), name: AVAudioSession.routeChangeNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(audioSessionInterruption(_:)), name: AVAudioSession.interruptionNotification, object: nil)
        AudioPlayer.setActive(true)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    private var audioPlayer: AVAudioPlayer?
    private var timer: Timer?
    
    // MARK: Control
    
    @discardableResult
    public func play(_ file: FileManager.FileInfo) -> Self {
        guard file.isSound
            else { return self }
        
        stop()
        
        source = file
        audioPlayer = try? AVAudioPlayer(contentsOf: URL(fileURLWithPath: file.path))
        audioPlayer?.delegate = self
        audioPlayer?.prepareToPlay()
        
        timer = Timer(timeInterval: 0.5, target: self, selector: #selector(timeRunloop(_:)), userInfo: nil, repeats: true)
        RunLoop.main.add(timer!, forMode: RunLoopMode.commonModes)
        DispatchQueue.main.async {
            NotificationCenter.default.post(name: AudioPlayer.audioPlayChangeFileNotification, object: self)
        }
        return self
    }
    
    @objc private func timeRunloop(_ sender: UIControl) {
        guard state == .playing
            else { return }
        DispatchQueue.main.async {
            NotificationCenter.default.post(name: AudioPlayer.audioPlayChangeProgressNotification, object: self)
        }
    }
    
    @objc private func audioSessionRouteChange(_ sender: Notification) {
        guard let routeChangeReasonNumber = sender.userInfo?[AVAudioSessionRouteChangeReasonKey] as? NSNumber,
            let routeChangeReason = AVAudioSession.RouteChangeReason(rawValue: routeChangeReasonNumber.uintValue) else {
                return
        }
        
        switch routeChangeReason {
        case .unknown, .categoryChange, .override, .wakeFromSleep, .noSuitableRouteForCategory, .routeConfigurationChange:
            break
        case .newDeviceAvailable:
            break
        case .oldDeviceUnavailable:
            self.suspend()
            break
        }
    }
    
    @objc private func audioSessionInterruption(_ sender: Notification) {
        
        guard let interruptionTypeNumber = sender.userInfo?[AVAudioSessionInterruptionTypeKey] as? NSNumber,
            let interruptionType = AVAudioSession.InterruptionType(rawValue: interruptionTypeNumber.uintValue) else {
                return
        }
        
        switch interruptionType {
        case .began:
            suspend()
        case .ended:
            if let optionsNumber = sender.userInfo?[AVAudioSessionInterruptionOptionKey] as? NSNumber {
                let options = AVAudioSession.InterruptionOptions(rawValue: optionsNumber.uintValue)
                if options.contains(.shouldResume) {
                    resume()
                }
            }
        }
    }
    
    @discardableResult
    public func seek(to time: TimeInterval) -> Self {
        guard let audioPlayer = audioPlayer
            else { return self }
        
        audioPlayer.currentTime = time
        resume()
        return self
    }
    
    @discardableResult
    public func resume() -> Self {
        guard let audioPlayer = audioPlayer,
            audioPlayer.play()
            
            else { return self }
        
        state = .playing
        return self
    }
    
    @discardableResult
    public func suspend() -> Self {
        guard let audioPlayer = audioPlayer
            else { return self }
        
        audioPlayer.pause()
        state = .suspended
        
        return self
    }
    
    @discardableResult
    public func stop() -> Self {
        timer?.invalidate()
        audioPlayer?.stop()
        
        state = .stop
        audioPlayer = nil;
        source = nil;
        timer = nil;
        return self
    }
    
    public class func setActive(_ active: Bool) {
        UIApplication.shared.beginReceivingRemoteControlEvents()
        let session = AVAudioSession.sharedInstance()
        do {
            try session.setCategory(.playback, mode: .default, options: [.defaultToSpeaker])
            try session.setActive(active, options: .notifyOthersOnDeactivation)
        } catch {
            print("Unable to activate audio session:  \(error.localizedDescription)")
        }
    }
    
    public class func outputPortType() -> [AVAudioSession.Port] {
        let session = AVAudioSession.sharedInstance()
        var ports: [AVAudioSession.Port] = []
        for output in session.currentRoute.outputs {
            ports.append(output.portType)
        }
        return ports
    }
}

extension AudioPlayer: AVAudioPlayerDelegate {
    
    public func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        state = .completed(nil)
    }
    
    public func audioPlayerDecodeErrorDidOccur(_ player: AVAudioPlayer, error: Error?) {
        state = .completed(error)
    }
    
}

extension AudioPlayer.State : Equatable {
    public static func == (lhs: AudioPlayer.State, rhs: AudioPlayer.State) -> Bool {
        switch (lhs, rhs) {
        case (.completed(_), .completed(_)):
            return true
        case (.playing, .playing):
            return true
        case (.suspended, .suspended):
            return true
        case (.stop, .stop):
            return true
        default:
            return false
        }
    }
}
