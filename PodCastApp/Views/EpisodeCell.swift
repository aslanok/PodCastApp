//
//  EpisodeCell.swift
//  PodCastApp
//
//  Created by MacBook on 21.06.2023.
//

import UIKit
import SDWebImage

class EpisodeCell : UITableViewCell {
    
    let dateFormatter = DateFormatter()
    
    private lazy var episodeImage : UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var pubDateLabel : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Pub Date"
        label.textColor = .purple
        label.font = UIFont.systemFont(ofSize: 16)
        return label
    }()
    
    private lazy var titleLabel : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Title Label"
        label.numberOfLines = 2
        label.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        return label
    }()
    
    private lazy var descriptionLabel : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Description Label"
        label.numberOfLines = 2
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .lightGray
        return label
    }()
    
    var progressLabel : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        label.font = UIFont.boldSystemFont(ofSize: 30)
        label.shadowColor = .black
        label.text = "100%"
        label.isHidden = true
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(episodeImage)
        contentView.addSubview(pubDateLabel)
        contentView.addSubview(titleLabel)
        contentView.addSubview(descriptionLabel)
        contentView.addSubview(progressLabel)
        
        episodeImage.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        episodeImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20).isActive = true
        episodeImage.heightAnchor.constraint(equalToConstant: 70).isActive = true
        episodeImage.widthAnchor.constraint(equalToConstant: 70).isActive = true
        
        titleLabel.centerYAnchor.constraint(equalTo: episodeImage.centerYAnchor, constant: -7).isActive = true
        titleLabel.leadingAnchor.constraint(equalTo: episodeImage.trailingAnchor, constant: 10).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10).isActive = true
        //titleLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        pubDateLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor).isActive = true
        pubDateLabel.bottomAnchor.constraint(equalTo: titleLabel.topAnchor, constant: -5).isActive = true
        pubDateLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10).isActive = true
        //pubDateLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 5).isActive = true
        descriptionLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor).isActive = true
        descriptionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10).isActive = true
        //descriptionLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        progressLabel.centerYAnchor.constraint(equalTo: episodeImage.centerYAnchor).isActive = true
        progressLabel.centerXAnchor.constraint(equalTo: episodeImage.centerXAnchor).isActive = true
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUp(episode : Episode){
        dateFormatter.dateFormat = "MMMM dd, yyyy"
        let imageUrl = URL(string: episode.imageUrl?.toSecureHTTPS() ?? "")
        episodeImage.sd_setImage(with: imageUrl)
        self.titleLabel.text = episode.title
        self.descriptionLabel.text = episode.description
        self.pubDateLabel.text = dateFormatter.string(from: episode.pubDate ?? Date())
    }
    
    
    
}
