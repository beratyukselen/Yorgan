//
//  LoginCell.swift
//  Yorgan
//
//  Created by Berat Yükselen on 29.04.2025.
//

import UIKit

class LoginCell: UIViewController {
    
    let emailLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 23)
        label.textColor = UIColor.systemGray
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let emailTextField: UITextField = {
        let textField = UITextField()
        textField.borderStyle = .none
        textField.font = UIFont.systemFont(ofSize: 20)
        textField.textColor = UIColor.systemGray
        textField.keyboardType = .emailAddress
        textField.returnKeyType = .done
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(emailLabel)
        addSubview(emailTextField)
        
        NSLayoutConstraint.activate([
            
            emailLabel.topAnchor.constraint(equalTo: topAnchor, constant: 165),
            emailLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 40),
            
            emailTextField.topAnchor.constraint(equalTo: emailLabel.bottomAnchor, constant: 10),
            emailTextField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 40),
            emailTextField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -40),
            emailTextField.heightAnchor.constraint(equalToConstant: 40),
            
        ])
    }
    

    required init(coder: NSCoder) {
        fatalError("init(coder: ) has not been implemented")
    }
}
