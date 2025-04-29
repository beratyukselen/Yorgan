//  HomeViewController.swift
//  Yorgan
//
//  Created by Berat Yükselen on 10.04.2025.

import UIKit

class HomeViewController: UIViewController {

    var username: String?

    private let welcomeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 28)
        label.textColor = UIColor.label
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.systemBackground
        setupUI()
    }

    private func setupUI() {
        view.addSubview(welcomeLabel)

        NSLayoutConstraint.activate([
            welcomeLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            welcomeLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 32)
        ])

        if let name = username {
            welcomeLabel.text = "Hoşgeldin, \(name)!"
        } else {
            welcomeLabel.text = "Hoşgeldin!"
        }
    }
}


