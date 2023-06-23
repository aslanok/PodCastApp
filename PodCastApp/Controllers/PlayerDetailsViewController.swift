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
    
    private lazy var contentView : UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        return view
    }()
    
    private lazy var backButton : UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Dismiss", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .semibold)
        button.setTitleColor(UIColor.black, for: .normal)
        return button
    }()
    
    private lazy var episodeImage : UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var episodeSlider : UISlider = {
        let slider = UISlider()
        slider.translatesAutoresizingMaskIntoConstraints = false
        return slider
    }()
    
    private lazy var episodeTitle : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = ""
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        return label
    }()
    
    private lazy var authorNameLabel : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Author"
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        label.textColor = UIColor.systemPurple
        return label
    }()
    
    private lazy var topButtonStackView : UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 20
        return stackView
    }()
    
    private lazy var backWardButton : UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: "rewind15"), for: .normal)
        return button
    }()
    
    private lazy var forwardButton : UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: "forward15"), for: .normal)
        return button
    }()
    
    private lazy var playPauseButton : UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: "pause"), for: .normal)
        return button
    }()
    
    private lazy var mutedVolumeButton : UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: "muted_volume"), for: .normal)
        return button
    }()
    
    private lazy var maxVolumeButton : UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: "max_volume"), for: .normal)
        return button
    }()
    
    private lazy var volumeSlider : UISlider = {
        let slider = UISlider()
        slider.translatesAutoresizingMaskIntoConstraints = false
        return slider
    }()
    
    private lazy var startTimeEpisodeLabel : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "00:00:00"
        label.textColor = .lightGray
        return label
    }()
    
    private lazy var endTimeEpisodeLabel : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "88:88:88"
        label.textColor = .lightGray
        return label
    }()
    
    private let player : AVPlayer = {
        let avPlayer = AVPlayer()
        avPlayer.automaticallyWaitsToMinimizeStalling = false
        return avPlayer
    }()
    
    init(episode : Episode) {
        super.init(nibName: nil, bundle: nil)
        self.episode = episode
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setDefaults()
        setUpView()
        playEpisode()
    }
    
    func setDefaults(){
        episodeTitle.text = episode?.title
        authorNameLabel.text = episode?.author
        episodeImage.sd_setImage(with: URL(string: episode?.imageUrl ?? ""))
        backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        playPauseButton.addTarget(self, action: #selector(handlePlayPause), for: .touchUpInside)
    }
    
    
    func setUpView(){
        view.addSubview(contentView)
        contentView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24).isActive = true
        contentView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24).isActive = true
        contentView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -24).isActive = true
        contentView.topAnchor.constraint(equalTo: view.topAnchor, constant: 60).isActive = true
        
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
        
        contentView.addSubview(startTimeEpisodeLabel)
        startTimeEpisodeLabel.topAnchor.constraint(equalTo: episodeSlider.bottomAnchor, constant: 5).isActive = true
        startTimeEpisodeLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        
        contentView.addSubview(endTimeEpisodeLabel)
        endTimeEpisodeLabel.topAnchor.constraint(equalTo: episodeSlider.bottomAnchor, constant: 5).isActive = true
        endTimeEpisodeLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        
        
        contentView.addSubview(episodeTitle)
        episodeTitle.topAnchor.constraint(equalTo: startTimeEpisodeLabel.bottomAnchor, constant: 10).isActive = true
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
        mutedVolumeButton.topAnchor.constraint(equalTo: topButtonStackView.bottomAnchor, constant: 40).isActive = true
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
        dismiss(animated: true)
    }
    
    fileprivate func playEpisode(){
        print("trying to play episode at url : \(episode?.streamUrl)")
        guard let url = URL(string: episode?.streamUrl ?? "") else { return }
        let playerItem = AVPlayerItem(url: url)
        player.replaceCurrentItem(with: playerItem)
        player.play()
    }
    
    @objc func handlePlayPause(){
        if player.timeControlStatus == .paused {
            player.play()
            playPauseButton.setImage(UIImage(named: "pause"), for: .normal)
        } else {
            player.pause()
            playPauseButton.setImage(UIImage(named: "play"), for: .normal)
        }
    }
    
    
    

}
