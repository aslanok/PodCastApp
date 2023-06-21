//
//  PlayerDetailsViewController.swift
//  PodCastApp
//
//  Created by MacBook on 22.06.2023.
//

import UIKit

class PlayerDetailsViewController: UIViewController {
    
    private lazy var contentView : UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .lightGray
        return view
    }()
    
    private lazy var backButton : UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
    }
    
    func setUpView(){
        view.addSubview(contentView)
        contentView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24).isActive = true
        contentView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24).isActive = true
        contentView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -24).isActive = true
        contentView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0).isActive = true
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
