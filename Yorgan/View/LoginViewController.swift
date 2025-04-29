//
//  LoginViewController.swift
//  Yorgan
//
//  Created by Berat Yükselen on 14.03.2025.
//

import UIKit

class LoginViewController: UIViewController, UITextFieldDelegate {

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "GİRİŞ"
        label.font = UIFont.boldSystemFont(ofSize: 28)
        label.textColor = UIColor.systemBlue
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let emailLabel: UILabel = {
        let label = UILabel()
        label.text = "E-MAIL"
        label.font = UIFont.boldSystemFont(ofSize: 23)
        label.textColor = UIColor.systemGray
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let emailTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "E-Mail adresinizi giriniz..."
        tf.borderStyle = .none
        tf.font = UIFont.systemFont(ofSize: 20)
        tf.textColor = UIColor.systemGray
        tf.keyboardType = .emailAddress
        tf.returnKeyType = .done
        tf.autocapitalizationType = .none
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()

    private let emailUnderline: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.systemGray
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let infoLabel: UILabel = {
        let label = UILabel()
        label.text = "E-Mail adresinizi sadece güvenlik ve doğrulama amaçlı istiyoruz."
        label.font = UIFont.boldSystemFont(ofSize: 9.5)
        label.textColor = .systemBlue
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let continueButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("DEVAM", for: .normal)
        btn.setTitleColor(.white, for: .normal)
        btn.backgroundColor = .systemGray
        btn.layer.cornerRadius = 17
        btn.isEnabled = false
        return btn
    }()
    
    private let backButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "chevron.left"), for: .normal)
        button.tintColor = UIColor(named: "textColor")
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: "backgroundColor")
        setupLayout()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
        
        emailTextField.delegate = self
        
        emailTextField.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
        continueButton.addTarget(self, action: #selector(handleContinue), for: .touchUpInside)
        backButton.addTarget(self, action: #selector(handleBack), for: .touchUpInside)
    }

    private func setupLayout() {
        [titleLabel, emailLabel, emailTextField, emailUnderline, infoLabel, continueButton, backButton].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }

        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 15),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),

            emailLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 90),
            emailLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),

            emailTextField.topAnchor.constraint(equalTo: emailLabel.bottomAnchor, constant: 10),
            emailTextField.leadingAnchor.constraint(equalTo: emailLabel.leadingAnchor),
            emailTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
            emailTextField.heightAnchor.constraint(equalToConstant: 40),

            emailUnderline.topAnchor.constraint(equalTo: emailTextField.bottomAnchor),
            emailUnderline.leadingAnchor.constraint(equalTo: emailTextField.leadingAnchor),
            emailUnderline.trailingAnchor.constraint(equalTo: emailTextField.trailingAnchor),
            emailUnderline.heightAnchor.constraint(equalToConstant: 1),

            infoLabel.topAnchor.constraint(equalTo: emailUnderline.bottomAnchor, constant: 10),
            infoLabel.leadingAnchor.constraint(equalTo: emailLabel.leadingAnchor),

            continueButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -50),
            continueButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            continueButton.widthAnchor.constraint(equalToConstant: 340),
            continueButton.heightAnchor.constraint(equalToConstant: 50),
            
            backButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            backButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 17)
            
        ])
    }

    @objc private func textDidChange() {
        let isValid = isValidEmail(emailTextField.text ?? "")
        continueButton.isEnabled = isValid
        continueButton.backgroundColor = isValid ? .systemBlue : .systemGray
    }

    @objc private func handleContinue() {
        guard let email = emailTextField.text, isValidEmail(email) else { return }

        AuthService.shared.sendEmailVerificationCode(email: email, isLogin: true) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success:
                    let popup = EmailVerificationViewController()
                    popup.userEmail = email
                    popup.modalPresentationStyle = .overCurrentContext
                    popup.modalTransitionStyle = .crossDissolve
                    self?.present(popup, animated: true)
                case .failure(let error):
                    print("Kod gönderilemedi: \(error.localizedDescription)")
                }
            }
        }
    }
    
    @objc private func handleBack() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    private func isValidEmail(_ email: String) -> Bool {
        let regex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        return NSPredicate(format: "SELF MATCHES %@", regex).evaluate(with: email)
    }
}

#Preview {
    LoginViewController()
}
