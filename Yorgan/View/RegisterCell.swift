//
//  RegisterCell.swift
//  Yorgan
//
//  Created by Berat Yükselen on 14.03.2025.
//

import UIKit

protocol RegisterCellDelegate: AnyObject {
    func textFieldsDidChange(name: String, surname: String)
}

class RegisterCell: UICollectionViewCell, UITextFieldDelegate {
    
    weak var delegate: RegisterCellDelegate?

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
        label.font = UIFont.boldSystemFont(ofSize: 23)
        label.textColor = UIColor.systemGray
        label.textAlignment = .left
        label.numberOfLines = 1
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let nameTextField: UITextField = {
        let textField = UITextField()
        textField.borderStyle = .none
        textField.font = UIFont.systemFont(ofSize: 20)
        textField.textColor = UIColor.systemGray
        textField.placeholder = "Adınızı giriniz..."
        textField.returnKeyType = .next
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    let surnameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 23)
        label.textColor = UIColor.systemGray
        label.textAlignment = .left
        label.numberOfLines = 1
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let surnameTextField: UITextField = {
        let textField = UITextField()
        textField.borderStyle = .none
        textField.font = UIFont.systemFont(ofSize: 20)
        textField.textColor = UIColor.systemGray
        textField.placeholder = "Soyadınızı giriniz..."
        textField.returnKeyType = .done
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        addBottomBorder(to: nameTextField)
        addBottomBorder(to: surnameTextField)
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(registerLabel)
        addSubview(nameLabel)
        addSubview(nameTextField)
        addSubview(surnameLabel)
        addSubview(surnameTextField)
        
        nameTextField.delegate = self
        surnameTextField.delegate = self
        
        nameTextField.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
        surnameTextField.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
        
        NSLayoutConstraint.activate([
            registerLabel.topAnchor.constraint(equalTo: topAnchor, constant: 55),
            registerLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            
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
            surnameTextField.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
    
    @objc private func textDidChange() {
        delegate?.textFieldsDidChange(name: nameTextField.text ?? "", surname: surnameTextField.text ?? "")
    }
    
    private func addBottomBorder(to textField: UITextField) {
        let bottomLine = CALayer()
        bottomLine.backgroundColor = UIColor.systemGray.cgColor
        bottomLine.frame = CGRect(x: 0, y: textField.frame.height - 1, width: textField.frame.width, height: 1)
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

    required init(coder: NSCoder) {
        fatalError("init(coder: ) has not been implemented")
    }
}
