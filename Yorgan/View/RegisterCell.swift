//
//  RegisterCell.swift
//  Yorgan
//
//  Created by Berat Yükselen on 14.03.2025.
//

import UIKit

protocol RegisterCellDelegate: AnyObject {
    func textFieldsDidChange(name: String?, surname: String?, phone: String?, pageIndex: Int)
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
    
    let phoneLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 23)
        label.textColor = UIColor.systemGray
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let phoneTextField: UITextField = {
        let textField = UITextField()
        textField.borderStyle = .none
        textField.font = UIFont.systemFont(ofSize: 20)
        textField.textColor = UIColor.systemGray
        textField.keyboardType = .phonePad
        textField.returnKeyType = .done
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    let countryCodeLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.systemGray
        label.font = UIFont.systemFont(ofSize: 20)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
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

        if !phoneTextField.isHidden {
            addBottomBorder(to: phoneTextField)
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(titleLabel)
        addSubview(nameLabel)
        addSubview(nameTextField)
        addSubview(surnameLabel)
        addSubview(surnameTextField)
        addSubview(phoneLabel)
        addSubview(phoneTextField)
        addSubview(countryCodeLabel)
        addSubview(infoLabel)
        
        phoneTextField.delegate = self
        nameTextField.delegate = self
        surnameTextField.delegate = self
        
        nameTextField.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
        surnameTextField.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
        phoneTextField.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
        
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
            
            phoneLabel.topAnchor.constraint(equalTo: topAnchor, constant: 165),
            phoneLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 40),
            
            countryCodeLabel.centerYAnchor.constraint(equalTo: phoneTextField.centerYAnchor),
            countryCodeLabel.leadingAnchor.constraint(equalTo: phoneLabel.leadingAnchor),
            countryCodeLabel.widthAnchor.constraint(equalToConstant: 50),

            phoneTextField.topAnchor.constraint(equalTo: phoneLabel.bottomAnchor, constant: 15),
            phoneTextField.leadingAnchor.constraint(equalTo: countryCodeLabel.trailingAnchor, constant: 5),
            phoneTextField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -40),
            phoneTextField.heightAnchor.constraint(equalToConstant: 40),
            
            infoLabel.topAnchor.constraint(equalTo: phoneTextField.bottomAnchor, constant: 15),
            infoLabel.leadingAnchor.constraint(equalTo: phoneLabel.leadingAnchor),
            infoLabel.trailingAnchor.constraint(equalTo: phoneTextField.trailingAnchor),
        ])
    }
    
    @objc private func textDidChange() {
        delegate?.textFieldsDidChange(
            name: nameTextField.text,
            surname: surnameTextField.text,
            phone: phoneTextField.text,
            pageIndex: phoneTextField.isHidden ? 0 : 1
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

        phoneLabel.isHidden = isNamePage
        phoneTextField.isHidden = isNamePage
        countryCodeLabel.isHidden = isNamePage
        infoLabel.isHidden = isNamePage

        if isNamePage {
            nameLabel.text = page.name
            nameTextField.placeholder = page.namePlaceholder

            surnameLabel.text = page.surname
            surnameTextField.placeholder = page.surnamePlaceholder
        } else {
            phoneLabel.text = page.phone
            phoneTextField.placeholder = page.phonePlaceholder
            countryCodeLabel.text = page.country
            infoLabel.text = page.info
        }
    }


    required init(coder: NSCoder) {
        fatalError("init(coder: ) has not been implemented")
    }
}
