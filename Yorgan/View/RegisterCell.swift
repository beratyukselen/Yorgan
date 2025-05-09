//
//  RegisterCell.swift
//  Yorgan
//
//  Created by Berat Yükselen on 14.03.2025.
//

import UIKit

protocol RegisterCellDelegate: AnyObject {
    func textFieldsDidChange(name: String?, surname: String?, email: String?, pageIndex: Int)
}

class RegisterCell: UICollectionViewCell, UITextFieldDelegate {
    
    weak var delegate: RegisterCellDelegate?

    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 28)
        label.textColor = UIColor.systemBlue
        label.textAlignment = .center
        label.numberOfLines = 1
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 23)
        label.textColor = UIColor.systemGray
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let nameTextField: UITextField = {
        let textField = UITextField()
        textField.borderStyle = .none
        textField.font = UIFont.systemFont(ofSize: 20)
        textField.textColor = UIColor.systemGray
        textField.returnKeyType = .next
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    let surnameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 23)
        label.textColor = UIColor.systemGray
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let surnameTextField: UITextField = {
        let textField = UITextField()
        textField.borderStyle = .none
        textField.font = UIFont.systemFont(ofSize: 20)
        textField.textColor = UIColor.systemGray
        textField.returnKeyType = .done
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
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
    
    let infoLabel: UILabel = {
        let label = UILabel()
        label.textColor = .systemBlue
        label.font = UIFont.boldSystemFont(ofSize: 9.5)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if !nameTextField.isHidden {
            addBottomBorder(to: nameTextField)
            addBottomBorder(to: surnameTextField)
        }

        if !emailTextField.isHidden {
            addBottomBorder(to: emailTextField)
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(titleLabel)
        addSubview(nameLabel)
        addSubview(nameTextField)
        addSubview(surnameLabel)
        addSubview(surnameTextField)
        addSubview(emailLabel)
        addSubview(emailTextField)
        addSubview(infoLabel)
        
        emailTextField.delegate = self
        nameTextField.delegate = self
        surnameTextField.delegate = self
        
        nameTextField.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
        surnameTextField.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
        emailTextField.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 55),
            titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            
            nameLabel.topAnchor.constraint(equalTo: topAnchor, constant: 165),
            nameLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 40),

            nameTextField.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 10),
            nameTextField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 40),
            nameTextField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -40),
            nameTextField.heightAnchor.constraint(equalToConstant: 40),

            surnameLabel.topAnchor.constraint(equalTo: nameTextField.bottomAnchor, constant: 20),
            surnameLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 40),

            surnameTextField.topAnchor.constraint(equalTo: surnameLabel.bottomAnchor, constant: 10),
            surnameTextField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 40),
            surnameTextField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -40),
            surnameTextField.heightAnchor.constraint(equalToConstant: 40),
            
            emailLabel.topAnchor.constraint(equalTo: topAnchor, constant: 165),
            emailLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 40),

            emailTextField.topAnchor.constraint(equalTo: emailLabel.bottomAnchor, constant: 10),
            emailTextField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 40),
            emailTextField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -40),
            emailTextField.heightAnchor.constraint(equalToConstant: 40),
            
            infoLabel.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 15),
            infoLabel.leadingAnchor.constraint(equalTo: emailLabel.leadingAnchor),
            infoLabel.trailingAnchor.constraint(equalTo: emailTextField.trailingAnchor),
        ])
    }
    
    @objc private func textDidChange() {
        delegate?.textFieldsDidChange(
            name: nameTextField.text,
            surname: surnameTextField.text,
            email: emailTextField.text,
            pageIndex: emailTextField.isHidden ? 0 : 1
        )
    }

    
    private func addBottomBorder(to textField: UITextField) {
        textField.layer.sublayers?.filter({ $0.name == "bottomBorder" }).forEach({ $0.removeFromSuperlayer() })

        let bottomLine = CALayer()
        bottomLine.backgroundColor = UIColor.systemGray.cgColor
        bottomLine.frame = CGRect(x: 0, y: textField.frame.height - 1, width: textField.frame.width, height: 1)
        bottomLine.name = "bottomBorder"
        textField.layer.addSublayer(bottomLine)
        textField.layer.masksToBounds = true
    }

    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == nameTextField {
            surnameTextField.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
        }
        return true
        
    }
    
    func configure(with page: RegisterPage, at index: Int) {
        titleLabel.text = page.title

        let isNamePage = (index == 0)

        nameLabel.isHidden = !isNamePage
        nameTextField.isHidden = !isNamePage
        surnameLabel.isHidden = !isNamePage
        surnameTextField.isHidden = !isNamePage

        emailLabel.isHidden = isNamePage
        emailTextField.isHidden = isNamePage
        infoLabel.isHidden = isNamePage

        if isNamePage {
            nameLabel.text = page.name
            nameTextField.placeholder = page.namePlaceholder

            surnameLabel.text = page.surname
            surnameTextField.placeholder = page.surnamePlaceholder
        } else {
            emailLabel.text = page.email
            emailTextField.placeholder = page.emailPlaceholder
            infoLabel.text = page.info
        }
    }
    
    func getEmail() -> String? {
        return emailTextField.isHidden ? nil : emailTextField.text
    }

    required init(coder: NSCoder) {
        fatalError("init(coder: ) has not been implemented")
    }
}


