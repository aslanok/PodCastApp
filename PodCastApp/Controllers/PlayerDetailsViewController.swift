//
//  PlayerDetailsViewController.swift
//  PodCastApp
//
//  Created by MacBook on 22.06.2023.
//

import UIKit
import AVKit

class PlayerDetailsViewController: UIViewController {
    private var episode : Episode?
    
    internal var mainView : PlayerDetailView{
        return self.view as! PlayerDetailView
    }
    
    let player : AVPlayer = {
        let avPlayer = AVPlayer()
        avPlayer.automaticallyWaitsToMinimizeStalling = false
        return avPlayer
    }()
    
    init(episode : Episode?) {
        super.init(nibName: nil, bundle: nil)
        self.episode = episode
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func obersvePlayerCurrentTime() {
        let interval = CMTimeMake(value: 1, timescale: 2)
        player.addPeriodicTimeObserver(forInterval: interval, queue: .main) { [weak self] time in
            // weak self koymadan önce ekranı kapatınca ses akmaya devam ediyordu ama şimdi ses artık akmıyor
            // weak self koyduğumuzda sayfa kaybolunca burdaki referanslar da kayboluyor
            self?.mainView.currentTimeLabel.text = time.toDisplayString()
            let durationTime = self?.player.currentItem?.duration
            self?.mainView.durationLabel.text = durationTime?.toDisplayString()
            self?.updateEpisodeSlider()
        }
    }
    
    fileprivate func updateEpisodeSlider(){
        let currentTimeSeconds = CMTimeGetSeconds(player.currentTime())
        let durationSeconds = CMTimeGetSeconds(player.currentItem?.duration ?? CMTimeMake(value: 1, timescale: 1))
        let percentage = currentTimeSeconds / durationSeconds
        self.mainView.episodeSlider.value = Float(percentage)
        
    }
    
    override func loadView() {
        super.loadView()
        
        view = PlayerDetailView()
        obersvePlayerCurrentTime()
        
        
        let time = CMTimeMake(value: 1, timescale: 3)
        let times = [NSValue(time: time)]
        player.addBoundaryTimeObserver(forTimes: times, queue: .main) { [weak self] in
            self?.enlargeEpisodeImageView()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setDefaults()
        playEpisode()
    }
    
    func setDefaults(){
        mainView.episodeTitle.text = episode?.title
        mainView.authorNameLabel.text = episode?.author
        mainView.episodeImage.sd_setImage(with: URL(string: episode?.imageUrl ?? ""))
        mainView.backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        mainView.playPauseButton.addTarget(self, action: #selector(handlePlayPause), for: .touchUpInside)
        mainView.episodeSlider.addTarget(self, action: #selector(handleCurrentTimeSliderChange), for: .valueChanged)
        mainView.backWardButton.addTarget(self, action: #selector(handleRewind), for: .touchUpInside)
        mainView.forwardButton.addTarget(self, action: #selector(handleFastForward), for: .touchUpInside)
        mainView.volumeSlider.addTarget(self, action: #selector(handleVolumeChange(_:)), for: .valueChanged)
    }
    
    @objc func backButtonTapped(){
        let mainTabBarController = UIApplication.shared.keyWindow?.rootViewController as? MainTabBarController
        mainTabBarController?.minimizePlayerDetails()
        //dismiss(animated: true)
    }
    
    fileprivate func enlargeEpisodeImageView(){
        UIView.animate(withDuration: 0.75, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.mainView.episodeImage.transform = .identity
        })
    }
    
    fileprivate func shrinkEpisodeImageView(){
        UIView.animate(withDuration: 0.75, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.mainView.episodeImage.transform = self.mainView.shrunkenTransform
        })
    }
    
    fileprivate func playEpisode(){
        guard let url = URL(string: episode?.streamUrl ?? "") else { return }
        let playerItem = AVPlayerItem(url: url)
        player.replaceCurrentItem(with: playerItem)
        player.play()
    }
    
    @objc func handlePlayPause(){
        if player.timeControlStatus == .paused {
            player.play()
            mainView.playPauseButton.setImage(UIImage(named: "pause"), for: .normal)
            enlargeEpisodeImageView()
        } else {
            player.pause()
            mainView.playPauseButton.setImage(UIImage(named: "play"), for: .normal)
            shrinkEpisodeImageView()
        }
    }
    
    @objc func handleCurrentTimeSliderChange(){
        let percentage = mainView.episodeSlider.value
        guard let duration = player.currentItem?.duration else { return }
        let durationInSeconds = CMTimeGetSeconds(duration)
        let seekTimeInSeconds = Float64(percentage) * durationInSeconds
        let seekTime = CMTimeMakeWithSeconds(seekTimeInSeconds, preferredTimescale: 1)
        player.seek(to: seekTime)
    }
    
    @objc func handleFastForward(){
        seekToCurrentTime(delta: 15)
    }
    
    @objc func handleRewind(){
        seekToCurrentTime(delta: -15)
    }
    
    fileprivate func seekToCurrentTime(delta : Int64){
        let seconds = CMTimeMake(value: delta, timescale: 1)
        let seekTime = CMTimeAdd(player.currentTime(), seconds)
        player.seek(to: seekTime)
    }

    @objc func handleVolumeChange(_ sender : UISlider){
        player.volume = sender.value
    }
    
    

}
