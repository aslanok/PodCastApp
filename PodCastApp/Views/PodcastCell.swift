//
//  PodcastCell.swift
//  PodCastApp
//
//  Created by MacBook on 19.06.2023.
//

import UIKit

class PodcastCell: UITableViewCell {
    
    private lazy var trackImage : UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "appicon")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var trackLabel : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "trackLabel"
        label.font = UIFont.boldSystemFont(ofSize: 17)
        return label
    }()
    
    private lazy var artistNameLabel : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "artist Name"
        label.font = UIFont.systemFont(ofSize: 16)
        return label
    }()
    
    private lazy var episodeCountLabel : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "episodeCount"
        label.textColor = .darkGray
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()
    
    var podcast : Podcast? {
        didSet{
            trackLabel.text = podcast?.trackName
            artistNameLabel.text = podcast?.artistName
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(trackImage)
        contentView.addSubview(trackLabel)
        contentView.addSubview(artistNameLabel)
        contentView.addSubview(episodeCountLabel)
        
        trackImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20).isActive = true
        trackImage.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        trackImage.widthAnchor.constraint(equalToConstant: 80).isActive = true
        trackImage.heightAnchor.constraint(equalToConstant: 80).isActive = true
        
        artistNameLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor, constant: 0).isActive = true
        artistNameLabel.leadingAnchor.constraint(equalTo: trackLabel.leadingAnchor).isActive = true
        //artistNameLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        trackLabel.bottomAnchor.constraint(equalTo: artistNameLabel.topAnchor, constant: -5).isActive = true
        trackLabel.leadingAnchor.constraint(equalTo: trackImage.trailingAnchor, constant: 10).isActive = true
        //trackLabel.heightAnchor.constraint(equalToConstant: 14).isActive = true
        
        episodeCountLabel.topAnchor.constraint(equalTo: artistNameLabel.bottomAnchor, constant: 5).isActive = true
        episodeCountLabel.leadingAnchor.constraint(equalTo: artistNameLabel.leadingAnchor).isActive = true
        //episodeCountLabel.heightAnchor.constraint(equalToConstant: 14).isActive = true
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
