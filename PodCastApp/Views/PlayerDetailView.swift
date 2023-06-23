//
//  PlayerDetailsView.swift
//  PodCastApp
//
//  Created by MacBook on 23.06.2023.
//

import Foundation
import UIKit

class PlayerDetailView : UIView {
    
    internal var contentView : UIView!
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
    
    internal let shrunkenTransform = CGAffineTransform(scaleX: 0.7, y: 0.7)
    
    init(){
        super.init(frame: .zero)
        loadView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func loadView(){
        self.backgroundColor = .white
        contentView = UIView()
        contentView.translatesAutoresizingMaskIntoConstraints = false
        
        backButton = UIButton()
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
        
        currentTimeLabel = UILabel()
        currentTimeLabel.translatesAutoresizingMaskIntoConstraints = false
        currentTimeLabel.text = "00:00:00"
        currentTimeLabel.textColor = .lightGray
        
        durationLabel = UILabel()
        durationLabel.translatesAutoresizingMaskIntoConstraints = false
        durationLabel.text = "88:88:88"
        durationLabel.textColor = .lightGray
        
        
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
    
    
    
}
