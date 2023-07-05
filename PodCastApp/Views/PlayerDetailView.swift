//
//  PlayerDetailsView.swift
//  PodCastApp
//
//  Created by MacBook on 23.06.2023.
//

import UIKit
import AVKit
import MediaPlayer

class PlayerDetailView : UIView {
    
    internal var contentView : UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    internal var backButton : UIButton!
    internal var episodeImage : UIImageView!
    internal var episodeSlider : UISlider!
    internal var episodeTitle : UILabel!
    internal var authorNameLabel : UILabel!
    internal var topButtonStackView : UIStackView!
    internal var backWardButton : UIButton!
    internal var forwardButton : UIButton!
    internal var playPauseButton : UIButton!
    internal var mutedVolumeButton : UIButton!
    internal var maxVolumeButton : UIButton!
    internal var volumeSlider : UISlider!
    internal var currentTimeLabel : UILabel!
    internal var durationLabel : UILabel!

    private var panGesture : UIPanGestureRecognizer!
    internal lazy var minimizeContentView : UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        //view.backgroundColor = .lightGray
        return view
    }()

    internal lazy var seperatorLineView : UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .lightGray
        return view
    }()
    
    internal lazy var minimizeStackView : UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.spacing = 8
        return stackView
    }()
    
    internal lazy var minimizeImageView : UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "appicon")
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    internal lazy var minimizeEpisodeTitle : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Episode Title"
        label.font = UIFont.systemFont(ofSize: 15)
        return label
    }()
    
    internal lazy var minimizePausePlayButton : UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: "pause"), for: .normal)
        button.tintColor = .black
        button.addTarget(self, action: #selector(handlePlayPause), for: .touchUpInside)
        return button
    }()
    
    internal lazy var minimizeForwardButton : UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: "forward15"), for: .normal)
        button.tintColor = .black
        button.addTarget(self, action: #selector(handleFastForward), for: .touchUpInside)
        return button
    }()
    
    let player : AVPlayer = {
        let avPlayer = AVPlayer()
        avPlayer.automaticallyWaitsToMinimizeStalling = false
        return avPlayer
    }()
    internal let shrunkenTransform = CGAffineTransform(scaleX: 0.7, y: 0.7)
    
    var episode : Episode? {
        didSet{
            minimizeEpisodeTitle.text = episode?.title
            episodeTitle.text = episode?.title
            authorNameLabel.text = episode?.author
            episodeImage.sd_setImage(with: URL(string: episode?.imageUrl ?? ""))
            
            setUpAudioSession()
            playEpisode()
            
            //minimizeImageView.sd_setImage(with: URL(string: episode?.imageUrl ?? ""))
            minimizeImageView.sd_setImage(with: URL(string: episode?.imageUrl ?? "")) { image, _, _, _ in
                guard let image = image else { return }
                
                var nowPlayingInfo = MPNowPlayingInfoCenter.default().nowPlayingInfo
                
                let artwork = MPMediaItemArtwork(boundsSize: image.size) { _ -> UIImage in
                    return image
                }
                nowPlayingInfo?[MPMediaItemPropertyArtwork] = artwork
                //MPNowPlayingInfoCenter.default().nowPlayingInfo = nowPlayingInfo

                
            }
            
        }
    }
    
    fileprivate func setUpGestures() {
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTapMaximize))
        self.addGestureRecognizer(gestureRecognizer)
        panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan))
        minimizeContentView.addGestureRecognizer(panGesture)
        //contentView.addGestureRecognizer(UIGestureRecognizer(target: self, action: #selector(handleDissmissalPan)))
    }
    
    fileprivate func setUpAudioSession(){
        do{
            try AVAudioSession.sharedInstance().setCategory(.playback)
            try AVAudioSession.sharedInstance().setActive(true)
        } catch let sessionErr{
            print("failed to activate session :", sessionErr)
        }
    }
    
    fileprivate func setUpRemoteControl(){
        UIApplication.shared.beginReceivingRemoteControlEvents()
        
        let commandCenter = MPRemoteCommandCenter.shared()
        
        commandCenter.playCommand.isEnabled = true
        commandCenter.playCommand.addTarget { _ -> MPRemoteCommandHandlerStatus in
            print("Should play podcast")
            self.player.play()
            self.playPauseButton.setImage(UIImage(named: "pause"), for: .normal)
            self.minimizePausePlayButton.setImage(UIImage(named: "pause"), for: .normal)
            self.setupElapsedTime(playbackRate: 1)
            return .success
        }
        commandCenter.pauseCommand.isEnabled = true
        commandCenter.pauseCommand.addTarget { _ -> MPRemoteCommandHandlerStatus in
            print("Should pause podcast")
            self.player.pause()
            self.playPauseButton.setImage(UIImage(named: "play"), for: .normal)
            self.minimizePausePlayButton.setImage(UIImage(named: "play"), for: .normal)
            self.setupElapsedTime(playbackRate: 0)
            
            return .success
        }
        commandCenter.togglePlayPauseCommand.isEnabled = true
        commandCenter.togglePlayPauseCommand.addTarget { _ -> MPRemoteCommandHandlerStatus in
            self.handlePlayPause()
            return .success
        }
        
        commandCenter.nextTrackCommand.addTarget{ _ -> MPRemoteCommandHandlerStatus in
            self.handleNextTrack()
            return .success
        }
        
    }
    
    var playlistEpisodes = [Episode]()
    
    @objc fileprivate func handleNextTrack(){
        print("play next episode")
        playlistEpisodes.forEach({print($0.title) } )
        if playlistEpisodes.count == 0{
            return
        }
        let currentEpisodeIndex = playlistEpisodes.index{ ep -> Bool in
            return self.episode?.title == ep.title && self.episode?.author == ep.author
        }
        guard let index = currentEpisodeIndex else { return }
        
        let nextEpisode : Episode
        if index == playlistEpisodes.count - 1 {
            nextEpisode = playlistEpisodes[0]
        } else {
            nextEpisode = playlistEpisodes[index + 1]
        }
        
        self.episode = nextEpisode
    }
    
    fileprivate func setupElapsedTime(playbackRate : Float){
        let elapsedTime = CMTimeGetSeconds(player.currentTime())
        MPNowPlayingInfoCenter.default().nowPlayingInfo?[MPNowPlayingInfoPropertyElapsedPlaybackTime] = elapsedTime
        MPNowPlayingInfoCenter.default().nowPlayingInfo?[MPNowPlayingInfoPropertyPlaybackRate] = playbackRate
        
    }

    init(){
        super.init(frame: .zero)
        setUpRemoteControl()
        setupInterruptionObserver()
        //setUpAudioSession()
        setUpGestures()
        loadView()
    }
    
    fileprivate func setupInterruptionObserver(){
        NotificationCenter.default.addObserver(self, selector: #selector(handleInterruption), name: .AVCaptureSessionWasInterrupted, object: nil)
    }
    
    @objc func handleInterruption(notification : Notification){
        guard let userInfo = notification.userInfo else {return}
        guard let type = userInfo[AVAudioSessionInterruptionTypeKey] as? UInt else { return }
        if type == AVAudioSession.InterruptionType.began.rawValue {
            print("interruption began")
            playPauseButton.setImage(UIImage(named: "play"), for: .normal)
            minimizePausePlayButton.setImage(UIImage(named: "play"), for: .normal)
        } else {
            guard let options = userInfo[AVAudioSessionInterruptionOptionKey] as? UInt else { return }
            if options == AVAudioSession.InterruptionOptions.shouldResume.rawValue {
                player.play()
                playPauseButton.setImage(UIImage(named: "pause"), for: .normal)
                minimizePausePlayButton.setImage(UIImage(named: "pause"), for: .normal)
                print("interruption ended")
            }
           
        }
        
    }
    
    fileprivate func setUpNowPlayingInfo(){
        var nowPlayingInfo = [String: Any]()
        nowPlayingInfo[MPMediaItemPropertyTitle] = episode?.title
        nowPlayingInfo[MPMediaItemPropertyArtist] = episode?.author
        MPNowPlayingInfoCenter.default().nowPlayingInfo = nowPlayingInfo
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func handleDissmissalPan(gesture : UIPanGestureRecognizer){
        if gesture.state == .changed {
            let translation = gesture.translation(in: superview)
            contentView.transform = CGAffineTransform(translationX: 0, y: translation.y)
        }
        
    }
    
    fileprivate func playEpisode(){
        if episode?.fileUrl != nil {
            playEpisodeUsingFileUrl()
        } else {
            print("trying to play episode at url : \(episode?.streamUrl)")
            guard let url = URL(string: episode?.streamUrl ?? "") else { return }
            let playerItem = AVPlayerItem(url: url)
            player.replaceCurrentItem(with: playerItem)
            player.play()
        }
        
    }
    
    fileprivate func playEpisodeUsingFileUrl() {
        print("Attempt to play episode with file url:", episode?.fileUrl ?? "")
        
        // let's figure out the file name for our episode file url
        guard let fileURL = URL(string: episode?.fileUrl ?? "") else { return }
        let fileName = fileURL.lastPathComponent
        
        guard var trueLocation = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return }
        
        trueLocation.appendPathComponent(fileName)
        print("True Location of episode:", trueLocation.absoluteString)
        let playerItem = AVPlayerItem(url: trueLocation)
        player.replaceCurrentItem(with: playerItem)
        player.play()
    }
    
    
    fileprivate func observeBoundaryTime() {
        let time = CMTimeMake(value: 1, timescale: 3)
        let times = [NSValue(time: time)]
        player.addBoundaryTimeObserver(forTimes: times, queue: .main) { [weak self] in
            self?.enlargeEpisodeImageView()
            self?.setUpLockScreenDuration()
        }
    }
    
    fileprivate func setUpLockScreenDuration(){
        guard let duration = player.currentItem?.duration else { return }
        let durationSeconds = CMTimeGetSeconds(duration)
        MPNowPlayingInfoCenter.default().nowPlayingInfo?[MPMediaItemPropertyPlaybackDuration] = durationSeconds
        
    }
    
    func loadView(){
        setUpView()
        
        observePlayerCurrentTime()
        
        observeBoundaryTime()
        
        backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        playPauseButton.addTarget(self, action: #selector(handlePlayPause), for: .touchUpInside)
        episodeSlider.addTarget(self, action: #selector(handleCurrentTimeSliderChange), for: .valueChanged)
        backWardButton.addTarget(self, action: #selector(handleRewind), for: .touchUpInside)
        forwardButton.addTarget(self, action: #selector(handleFastForward), for: .touchUpInside)
        volumeSlider.addTarget(self, action: #selector(handleVolumeChange(_:)), for: .valueChanged)
        
        
    }

    fileprivate func observePlayerCurrentTime() {
        let interval = CMTimeMake(value: 1, timescale: 2)
        player.addPeriodicTimeObserver(forInterval: interval, queue: .main) { [weak self] time in
            // weak self koymadan önce ekranı kapatınca ses akmaya devam ediyordu ama şimdi ses artık akmıyor
            // weak self koyduğumuzda sayfa kaybolunca burdaki referanslar da kayboluyor
            self?.currentTimeLabel.text = time.toDisplayString()
            let durationTime = self?.player.currentItem?.duration
            self?.durationLabel.text = durationTime?.toDisplayString()
            //self?.setUpLockScreenCurrentView()
            self?.updateEpisodeSlider()
        }
    }
    
    fileprivate func setUpLockScreenCurrentView(){
        var nowPlayingInfo = MPNowPlayingInfoCenter.default().nowPlayingInfo
        
        guard let currentItem = player.currentItem else { return }
        let durationInSeconds = CMTimeGetSeconds(currentItem.duration)
        let elapsedTime = CMTimeGetSeconds(player.currentTime())
        
        nowPlayingInfo?[MPNowPlayingInfoPropertyElapsedPlaybackTime] = elapsedTime
        nowPlayingInfo?[MPMediaItemPropertyPlaybackDuration] = durationInSeconds
        MPNowPlayingInfoCenter.default().nowPlayingInfo = nowPlayingInfo
    }
    
    fileprivate func updateEpisodeSlider(){
        let currentTimeSeconds = CMTimeGetSeconds(player.currentTime())
        let durationSeconds = CMTimeGetSeconds(player.currentItem?.duration ?? CMTimeMake(value: 1, timescale: 1))
        let percentage = currentTimeSeconds / durationSeconds
        episodeSlider.value = Float(percentage)
    }
    
    fileprivate func enlargeEpisodeImageView(){
        UIView.animate(withDuration: 0.75, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.episodeImage.transform = .identity
        })
    }

    fileprivate func shrinkEpisodeImageView(){
        UIView.animate(withDuration: 0.75, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.episodeImage.transform = self.shrunkenTransform
        })
    }

    func setUpView(){
        self.backgroundColor = .white
        backButton = UIButton(type : .system)
        backButton.translatesAutoresizingMaskIntoConstraints = false
        backButton.setTitle("Dismiss", for: .normal)
        backButton.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .semibold)
        backButton.setTitleColor(UIColor.black, for: .normal)

        episodeImage = UIImageView()
        episodeImage.translatesAutoresizingMaskIntoConstraints = false
        episodeImage.layer.cornerRadius = 5
        episodeImage.clipsToBounds = true
        episodeImage.transform = shrunkenTransform
        
        episodeSlider = UISlider()
        episodeSlider.translatesAutoresizingMaskIntoConstraints = false
        episodeSlider.minimumValue = 1
        episodeSlider.minimumValue = 0
        
        episodeTitle = UILabel()
        episodeTitle.translatesAutoresizingMaskIntoConstraints = false
        episodeTitle.text = ""
        episodeTitle.textAlignment = .center
        episodeTitle.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        
        authorNameLabel = UILabel()
        authorNameLabel.translatesAutoresizingMaskIntoConstraints = false
        authorNameLabel.text = "Author"
        authorNameLabel.textAlignment = .center
        authorNameLabel.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        authorNameLabel.textColor = UIColor.systemPurple
        
        topButtonStackView = UIStackView()
        topButtonStackView.translatesAutoresizingMaskIntoConstraints = false
        topButtonStackView.axis = .horizontal
        topButtonStackView.distribution = .fillEqually
        topButtonStackView.spacing = 20
        
        backWardButton = UIButton(type: .system)
        backWardButton.translatesAutoresizingMaskIntoConstraints = false
        backWardButton.setImage(UIImage(named: "rewind15"), for: .normal)
        backWardButton.tintColor = UIColor.black
        
        forwardButton = UIButton(type: .system)
        forwardButton.translatesAutoresizingMaskIntoConstraints = false
        forwardButton.setImage(UIImage(named: "forward15"), for: .normal)
        forwardButton.tintColor = UIColor.black
        
        playPauseButton = UIButton(type: .system)
        playPauseButton.translatesAutoresizingMaskIntoConstraints = false
        playPauseButton.setImage(UIImage(named: "pause"), for: .normal)
        playPauseButton.tintColor = UIColor.black
        
        mutedVolumeButton = UIButton()
        mutedVolumeButton.translatesAutoresizingMaskIntoConstraints = false
        mutedVolumeButton.setImage(UIImage(named: "muted_volume"), for: .normal)
        
        maxVolumeButton = UIButton()
        maxVolumeButton.translatesAutoresizingMaskIntoConstraints = false
        maxVolumeButton.setImage(UIImage(named: "max_volume"), for: .normal)
        
        volumeSlider = UISlider()
        volumeSlider.translatesAutoresizingMaskIntoConstraints = false
        volumeSlider.value = 0.5
        
        currentTimeLabel = UILabel()
        currentTimeLabel.translatesAutoresizingMaskIntoConstraints = false
        currentTimeLabel.text = "00:00:00"
        currentTimeLabel.textColor = .lightGray
        
        durationLabel = UILabel()
        durationLabel.translatesAutoresizingMaskIntoConstraints = false
        durationLabel.text = "88:88:88"
        durationLabel.textColor = .lightGray
        
        self.addSubview(minimizeContentView)
        minimizeContentView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        minimizeContentView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        minimizeContentView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        minimizeContentView.heightAnchor.constraint(equalToConstant: 64).isActive = true
        
        
        minimizeImageView.widthAnchor.constraint(equalToConstant: 48).isActive = true
        minimizePausePlayButton.widthAnchor.constraint(equalToConstant: 48).isActive = true
        minimizeForwardButton.widthAnchor.constraint(equalToConstant: 48).isActive = true
        
        minimizeStackView.addArrangedSubview(minimizeImageView)
        minimizeStackView.addArrangedSubview(minimizeEpisodeTitle)
        minimizeStackView.addArrangedSubview(minimizePausePlayButton)
        minimizeStackView.addArrangedSubview(minimizeForwardButton)
        
        minimizeContentView.addSubview(minimizeStackView)
        minimizeStackView.centerYAnchor.constraint(equalTo: minimizeContentView.centerYAnchor).isActive = true
        minimizeStackView.heightAnchor.constraint(equalToConstant: 48).isActive = true
        minimizeStackView.leadingAnchor.constraint(equalTo: minimizeContentView.leadingAnchor, constant: 8).isActive = true
        minimizeStackView.trailingAnchor.constraint(equalTo: minimizeContentView.trailingAnchor, constant: -8).isActive = true
        
        minimizeContentView.addSubview(seperatorLineView)
        seperatorLineView.topAnchor.constraint(equalTo: minimizeContentView.topAnchor).isActive = true
        seperatorLineView.leadingAnchor.constraint(equalTo: minimizeContentView.leadingAnchor).isActive = true
        seperatorLineView.trailingAnchor.constraint(equalTo: minimizeContentView.trailingAnchor).isActive = true
        seperatorLineView.heightAnchor.constraint(equalToConstant: 0.5).isActive = true

        self.addSubview(contentView)
        contentView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 24).isActive = true
        contentView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -24).isActive = true
        contentView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -24).isActive = true
        contentView.topAnchor.constraint(equalTo: self.topAnchor, constant: 60).isActive = true
        
        contentView.addSubview(backButton)
        backButton.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        backButton.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        backButton.widthAnchor.constraint(equalToConstant: 80).isActive = true
        
        contentView.addSubview(episodeImage)
        episodeImage.topAnchor.constraint(equalTo: backButton.bottomAnchor, constant: 10).isActive = true
        episodeImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 0).isActive = true
        episodeImage.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        episodeImage.heightAnchor.constraint(equalTo: episodeImage.widthAnchor).isActive = true
        
        contentView.addSubview(episodeSlider)
        episodeSlider.topAnchor.constraint(equalTo: episodeImage.bottomAnchor, constant: 20).isActive = true
        episodeSlider.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        episodeSlider.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        
        contentView.addSubview(currentTimeLabel)
        currentTimeLabel.topAnchor.constraint(equalTo: episodeSlider.bottomAnchor, constant: 5).isActive = true
        currentTimeLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        
        contentView.addSubview(durationLabel)
        durationLabel.topAnchor.constraint(equalTo: episodeSlider.bottomAnchor, constant: 5).isActive = true
        durationLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        
        contentView.addSubview(episodeTitle)
        episodeTitle.topAnchor.constraint(equalTo: currentTimeLabel.bottomAnchor, constant: 10).isActive = true
        episodeTitle.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        episodeTitle.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        
        contentView.addSubview(authorNameLabel)
        authorNameLabel.topAnchor.constraint(equalTo: episodeTitle.bottomAnchor, constant: 10).isActive = true
        authorNameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        authorNameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        
        topButtonStackView.addArrangedSubview(backWardButton)
        topButtonStackView.addArrangedSubview(playPauseButton)
        topButtonStackView.addArrangedSubview(forwardButton)
        
        contentView.addSubview(topButtonStackView)
        topButtonStackView.topAnchor.constraint(equalTo: authorNameLabel.bottomAnchor, constant: 40).isActive = true
        topButtonStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        topButtonStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        topButtonStackView.heightAnchor.constraint(equalToConstant: 60).isActive = true
        
        contentView.addSubview(mutedVolumeButton)
        mutedVolumeButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -100).isActive = true
        mutedVolumeButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        mutedVolumeButton.widthAnchor.constraint(equalToConstant: 30).isActive = true
        mutedVolumeButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        contentView.addSubview(maxVolumeButton)
        maxVolumeButton.centerYAnchor.constraint(equalTo: mutedVolumeButton.centerYAnchor).isActive = true
        maxVolumeButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        maxVolumeButton.widthAnchor.constraint(equalToConstant: 30).isActive = true
        maxVolumeButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        contentView.addSubview(volumeSlider)
        volumeSlider.centerYAnchor.constraint(equalTo: mutedVolumeButton.centerYAnchor).isActive = true
        volumeSlider.leadingAnchor.constraint(equalTo: mutedVolumeButton.trailingAnchor, constant: 10).isActive = true
        volumeSlider.trailingAnchor.constraint(equalTo: maxVolumeButton.leadingAnchor, constant: -10).isActive = true
    }

    @objc func backButtonTapped(){
        // self.removeFromSuperview()
        let mainTabBarController = UIApplication.shared.keyWindow?.rootViewController as? MainTabBarController
        mainTabBarController?.minimizePlayerDetails()
        panGesture.isEnabled = true
    }

    @objc func handlePan(gesture : UIPanGestureRecognizer){
        if gesture.state == .changed {
            handlePanChanged(gesture: gesture)
        } else if gesture.state == .ended {
            handlePanEnded(gesture: gesture)
        }
    }

    func handlePanChanged(gesture : UIPanGestureRecognizer){
        let translation = gesture.translation(in: self.superview)
        self.transform = CGAffineTransform(translationX: 0, y: translation.y)
        self.minimizeContentView.alpha = 1 + translation.y / 200
        self.contentView.alpha = -translation.y / 200
    }

    func handlePanEnded(gesture : UIPanGestureRecognizer){
        let translation = gesture.translation(in: self.superview)
        let velocity = gesture.velocity(in: self.superview)
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.transform = .identity
            if translation.y < -200 || velocity.y < -500 {
                UIApplication.mainTabBarController()?.maximizePlayerDetails(episode: nil)
                gesture.isEnabled = false
            } else {
                self.minimizeContentView.alpha = 1
                self.contentView.alpha = 0
            }
        })
    }
    
    @objc func handlePlayPause(){
        if player.timeControlStatus == .paused {
            player.play()
            playPauseButton.setImage(UIImage(named: "pause"), for: .normal)
            minimizePausePlayButton.setImage(UIImage(named: "pause"), for: .normal)
            enlargeEpisodeImageView()
            self.setupElapsedTime(playbackRate: 1)
        } else {
            player.pause()
            playPauseButton.setImage(UIImage(named: "play"), for: .normal)
            minimizePausePlayButton.setImage(UIImage(named: "play"), for: .normal)
            shrinkEpisodeImageView()
            self.setupElapsedTime(playbackRate: 0)
        }
    }
    
    @objc func handleTapMaximize(){
        UIApplication.mainTabBarController()?.maximizePlayerDetails(episode: nil)
        panGesture.isEnabled = false
    }
    
    @objc func handleCurrentTimeSliderChange(){
        let percentage = episodeSlider.value
        guard let duration = player.currentItem?.duration else { return }
        let durationInSeconds = CMTimeGetSeconds(duration)
        let seekTimeInSeconds = Float64(percentage) * durationInSeconds
        let seekTime = CMTimeMakeWithSeconds(seekTimeInSeconds, preferredTimescale: 1)
        
        MPNowPlayingInfoCenter.default().nowPlayingInfo?[MPNowPlayingInfoPropertyElapsedPlaybackTime] = seekTimeInSeconds
        
        
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
