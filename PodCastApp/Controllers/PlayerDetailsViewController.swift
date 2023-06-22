//
//  PlayerDetailsViewController.swift
//  PodCastApp
//
//  Created by MacBook on 22.06.2023.
//

import UIKit

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
    
    private lazy var authorName : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Author"
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 15, weight: .semibold)
        label.textColor = UIColor.systemPurple
        return label
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
    }
    
    func setDefaults(){
        episodeTitle.text = episode?.title
        episodeImage.sd_setImage(with: URL(string: episode?.imageUrl ?? ""))
        backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
    }
    
    @objc func backButtonTapped(){
        dismiss(animated: true)
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
        
        contentView.addSubview(episodeTitle)
        episodeTitle.topAnchor.constraint(equalTo: episodeSlider.bottomAnchor, constant: 10).isActive = true
        episodeTitle.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        episodeTitle.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        
        contentView.addSubview(authorName)
        authorName.topAnchor.constraint(equalTo: episodeTitle.bottomAnchor, constant: 10).isActive = true
        authorName.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        authorName.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        
        
    }
    

}
