//
//  FavoritePodcastCell.swift
//  PodCastApp
//
//  Created by MacBook on 30.06.2023.
//

import UIKit


class FavoritePodcastCell : UICollectionViewCell{
    
    var podcast : Podcast! {
        didSet{
            nameLabel.text = podcast.trackName
            artistNameLabel.text = podcast.artistName
            let url = URL(string: podcast.artworkUrl60 ?? "")
            podcastImageView.sd_setImage(with: url)
        }
    }
    
    private lazy var podcastImageView : UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: "appicon")
        return imageView
    }()
    private lazy var nameLabel : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "nameLabel"
        //label.backgroundColor = .lightGray
        label.font = UIFont.systemFont(ofSize: 15, weight: .semibold)
        return label
    }()
    private lazy var artistNameLabel : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "artistName"
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .lightGray
        return label
    }()
    
    
    fileprivate func setUpViews() {
        podcastImageView.heightAnchor.constraint(equalTo: podcastImageView.widthAnchor).isActive = true
        
        let stackView = UIStackView(arrangedSubviews: [podcastImageView,nameLabel,artistNameLabel])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        self.addSubview(stackView)
        stackView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        stackView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        stackView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        stackView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUpViews()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
