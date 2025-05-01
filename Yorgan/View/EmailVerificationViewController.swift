//  EmailVerificationViewController.swift
//  Yorgan
//
//  Created by Berat Yükselen on 8.04.2025.

import UIKit

class EmailVerificationViewController: UIViewController, UITextFieldDelegate {

    var userEmail: String!
    var userName: String?
    var userSurname: String?

    private let containerView = UIView()
    private let descriptionLabel = UILabel()
    private let codeTextField = UITextField()
    private let resendButton = UIButton(type: .system)
    private let timerLabel = UILabel()
    private let closeButton = UIButton(type: .system)
    private var countdownTimer: Timer?
    private var remainingSeconds = 300

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        startTimer()
    }

    private func setupUI() {
        let backgroundColor = UIColor { trait in
            trait.userInterfaceStyle == .dark ? UIColor.black : UIColor.white
        }

        let labelTextColor = UIColor { trait in
            trait.userInterfaceStyle == .dark ? UIColor.white : UIColor.black
        }

        let placeholderColor = UIColor { trait in
            trait.userInterfaceStyle == .dark ? UIColor.lightGray : UIColor.darkGray
        }

        view.backgroundColor = UIColor.black.withAlphaComponent(0.5)

        containerView.backgroundColor = backgroundColor
        containerView.layer.cornerRadius = 32
        containerView.layer.shadowColor = UIColor.black.cgColor
        containerView.layer.shadowOpacity = 0.2
        containerView.layer.shadowOffset = CGSize(width: 0, height: 4)
        containerView.layer.shadowRadius = 12
        containerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(containerView)

        closeButton.setTitle("x", for: .normal)
        closeButton.setTitleColor(labelTextColor, for: .normal)
        closeButton.titleLabel?.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        closeButton.addTarget(self, action: #selector(closeTapped), for: .touchUpInside)
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(closeButton)

        descriptionLabel.textColor = labelTextColor
        descriptionLabel.text = "Lütfen \(userEmail ?? "e-mail") adresinize gönderdiğimiz 6 haneli kodu giriniz:"
        descriptionLabel.numberOfLines = 0
        descriptionLabel.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        descriptionLabel.textAlignment = .center
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(descriptionLabel)

        codeTextField.attributedPlaceholder = NSAttributedString(
            string: "- - - - - -",
            attributes: [
                .foregroundColor: placeholderColor,
                .kern: 8
            ]
        )
        codeTextField.font = UIFont.monospacedDigitSystemFont(ofSize: 40, weight: .medium)
        codeTextField.textAlignment = .center
        codeTextField.keyboardType = .numberPad
        codeTextField.borderStyle = .none
        codeTextField.textColor = labelTextColor
        codeTextField.delegate = self
        codeTextField.translatesAutoresizingMaskIntoConstraints = false
        codeTextField.addTarget(self, action: #selector(codeDidChange), for: .editingChanged)
        containerView.addSubview(codeTextField)

        timerLabel.text = "05:00"
        timerLabel.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        timerLabel.textAlignment = .center
        timerLabel.textColor = labelTextColor
        timerLabel.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(timerLabel)

        resendButton.setTitle("Kodu Tekrar Gönder", for: .normal)
        resendButton.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        resendButton.setTitleColor(.white, for: .normal)
        resendButton.backgroundColor = UIColor.systemBlue
        resendButton.layer.cornerRadius = 24
        resendButton.layer.shadowColor = UIColor.black.cgColor
        resendButton.layer.shadowOpacity = 0.2
        resendButton.layer.shadowOffset = CGSize(width: 0, height: 4)
        resendButton.layer.shadowRadius = 8
        resendButton.isEnabled = false
        resendButton.alpha = 0.5
        resendButton.addTarget(self, action: #selector(resendCode), for: .touchUpInside)
        resendButton.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(resendButton)

        NSLayoutConstraint.activate([
            containerView.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor),
            containerView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 24),
            containerView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -24),
            containerView.heightAnchor.constraint(greaterThanOrEqualToConstant: 300),

            closeButton.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 5),
            closeButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -10),

            descriptionLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 40),
            descriptionLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20),
            descriptionLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20),

            codeTextField.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 20),
            codeTextField.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            codeTextField.widthAnchor.constraint(equalTo: containerView.widthAnchor, multiplier: 0.7),
            codeTextField.heightAnchor.constraint(equalToConstant: 50),

            timerLabel.topAnchor.constraint(equalTo: codeTextField.bottomAnchor, constant: 12),
            timerLabel.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),

            resendButton.topAnchor.constraint(equalTo: timerLabel.bottomAnchor, constant: 16),
            resendButton.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            resendButton.widthAnchor.constraint(equalTo: containerView.widthAnchor, multiplier: 0.7),
            resendButton.heightAnchor.constraint(equalToConstant: 48)
        ])
    }

    @objc private func closeTapped() {
        self.dismiss(animated: true)
    }

    @objc private func codeDidChange() {
        guard let code = codeTextField.text, code.count == 6 else { return }
        verifyCode(code)
    }

    private func verifyCode(_ code: String) {
        AuthService.shared.verifyCode(email: userEmail, code: code) { [weak self] result in
            guard let self = self else { return }

            DispatchQueue.main.async {
                switch result {
                case .success:
                    if let name = self.userName, let surname = self.userSurname {
                        AuthService.shared.registerNewUser(name: name, surname: surname, email: self.userEmail) { success in
                            if success {
                                self.goToHome()
                            } else {
                                self.showError("Kullanıcı kaydedilemedi.")
                            }
                        }
                    } else {
                        self.goToHome()
                    }

                case .failure(let error):
                    self.showError("Kod doğrulanamadı: \(error.localizedDescription)")
                }
            }
        }
    }


    @objc private func resendCode() {
        resendButton.isEnabled = false
        resendButton.alpha = 0.5
        remainingSeconds = 300
        startTimer()

        AuthService.shared.sendEmailVerificationCode(email: userEmail) { result in
            if case .failure(let error) = result {
                self.showError("Kod tekrar gönderilemedi: \(error.localizedDescription)")
            }
        }
    }

    private func startTimer() {
        countdownTimer?.invalidate()
        timerLabel.text = formatTime(remainingSeconds)

        countdownTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            self.remainingSeconds -= 1
            self.timerLabel.text = self.formatTime(self.remainingSeconds)

            if self.remainingSeconds <= 0 {
                self.countdownTimer?.invalidate()
                self.resendButton.isEnabled = true
                self.resendButton.alpha = 1.0
            }
        }
    }

    private func formatTime(_ seconds: Int) -> String {
        let minutes = seconds / 60
        let seconds = seconds % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }

    private func goToHome() {
        let homeVC = MainTabBarController()
        homeVC.modalPresentationStyle = .fullScreen
        self.present(homeVC, animated: true)
    }

    
    private func showError(_ message: String) {
        let alert = UIAlertController(title: "Hata", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Tamam", style: .default))
        present(alert, animated: true)
    }

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentText = textField.text ?? ""
        guard let stringRange = Range(range, in: currentText) else { return false }
        let updatedText = currentText.replacingCharacters(in: stringRange, with: string)
        return updatedText.count <= 6
    }
}

#Preview {
    EmailVerificationViewController()
}
