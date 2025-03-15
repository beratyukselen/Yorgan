//
//  RegisterCell.swift
//  Yorgan
//
//  Created by Berat Yükselen on 14.03.2025.
//

import UIKit

class RegisterCell: UICollectionViewCell {

    let registerLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 28)
        label.textAlignment = .center
        label.numberOfLines = 1
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 25)
        label.textAlignment = .left
        label.numberOfLines = 2
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let surnameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 25)
        label.textAlignment = .left
        label.numberOfLines = 3
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let nameTextField: UITextField = {
       let textField = UITextField()
       return textField
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(registerLabel)
        addSubview(nameLabel)
        addSubview(surnameLabel)
        
        NSLayoutConstraint.activate([
        
            registerLabel.topAnchor.constraint(equalTo: topAnchor, constant: 55),
            registerLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            
            nameLabel.topAnchor.constraint(equalTo: topAnchor, constant: 120),
            
            surnameLabel.topAnchor.constraint(equalTo: topAnchor, constant: 150)
            
            
        ])
    }

    required init(coder: NSCoder) {
        fatalError("init(coder: ) has not been implemented")
    }
}
