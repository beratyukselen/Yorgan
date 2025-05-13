//
//  ProfileViewController.swift
//  Yorgan
//
//  Created by Berat Yükselen on 1.05.2025.
//

import UIKit

class ProfileViewController: UIViewController {

    private let scrollView = UIScrollView()
    private let contentView = UIStackView()

    // Kullanıcı Bilgi Kartı
    private let userInfoCard = UIView()
    private let nameLabel = UILabel()
    private let surnameLabel = UILabel()
    private let emailLabel = UILabel()

    // Bilgi Grubu
    private let infoHeaderLabel = UILabel()
    private let rateAppButton = UIButton(type: .system)
    private let contactDevButton = UIButton(type: .system)
    private let privacyPolicyButton = UIButton(type: .system)

    // Versiyon
    private let versionLabel = UILabel()

    // Veri Grubu
    private let dataHeaderLabel = UILabel()
    private let backupButton = UIButton(type: .system)
    private let restoreButton = UIButton(type: .system)
    private let resetButton = UIButton(type: .system)

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "Profil"

        setupScrollView()
        setupUserInfoCard()
        setupInfoSection()
        setupVersionInfo()
        setupDataSection()

        // Örnek veriler
        nameLabel.text = "Berat"
        surnameLabel.text = "Yükselen"
        emailLabel.text = "berat@example.com"
    }

    private func setupScrollView() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentView.axis = .vertical
        contentView.spacing = 20
        contentView.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(scrollView)
        scrollView.addSubview(contentView)

        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 20),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 20),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -20),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor, constant: -40)
        ])
    }

    private func setupUserInfoCard() {
        userInfoCard.backgroundColor = .systemGray6
        userInfoCard.layer.cornerRadius = 12
        userInfoCard.layer.masksToBounds = true
        userInfoCard.translatesAutoresizingMaskIntoConstraints = false

        let stack = UIStackView(arrangedSubviews: [nameLabel, surnameLabel, emailLabel])
        stack.axis = .vertical
        stack.spacing = 8
        stack.alignment = .center
        stack.translatesAutoresizingMaskIntoConstraints = false

        [nameLabel, surnameLabel, emailLabel].forEach {
            $0.font = .systemFont(ofSize: 18, weight: .medium)
        }

        userInfoCard.addSubview(stack)
        contentView.addArrangedSubview(userInfoCard)

        NSLayoutConstraint.activate([
            stack.centerXAnchor.constraint(equalTo: userInfoCard.centerXAnchor),
            stack.centerYAnchor.constraint(equalTo: userInfoCard.centerYAnchor),
            userInfoCard.heightAnchor.constraint(equalToConstant: 120)
        ])
    }

    private func setupInfoSection() {
        infoHeaderLabel.text = "Bilgi"
        infoHeaderLabel.font = .boldSystemFont(ofSize: 16)
        contentView.addArrangedSubview(infoHeaderLabel)

        configureButton(rateAppButton, title: "Bizi Oyla", action: #selector(rateAppTapped))
        configureButton(contactDevButton, title: "Geliştirici ile İletişim", action: #selector(contactDevTapped))
        configureButton(privacyPolicyButton, title: "Gizlilik Sözleşmesi", action: #selector(privacyPolicyTapped))
    }

    private func setupVersionInfo() {
        versionLabel.textAlignment = .center
        versionLabel.font = .systemFont(ofSize: 14)
        versionLabel.textColor = .secondaryLabel
        versionLabel.text = "Versiyon: \(Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0")"
        contentView.addArrangedSubview(versionLabel)
    }

    private func setupDataSection() {
        dataHeaderLabel.text = "Veri İşlemleri"
        dataHeaderLabel.font = .boldSystemFont(ofSize: 16)
        contentView.addArrangedSubview(dataHeaderLabel)

        configureButton(backupButton, title: "Verileri Yedekle", action: #selector(backupTapped))
        configureButton(restoreButton, title: "Yedekten Geri Yükle", action: #selector(restoreTapped))
        configureButton(resetButton, title: "Verileri Sıfırla", action: #selector(resetTapped))
    }

    private func configureButton(_ button: UIButton, title: String, action: Selector) {
        let container = UIView()
        container.backgroundColor = .systemGray6
        container.layer.cornerRadius = 10
        container.translatesAutoresizingMaskIntoConstraints = false

        button.setTitle(title, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        button.setTitleColor(.systemBlue, for: .normal)
        button.contentHorizontalAlignment = .left
        button.addTarget(self, action: action, for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false

        container.addSubview(button)
        contentView.addArrangedSubview(container)

        NSLayoutConstraint.activate([
            button.topAnchor.constraint(equalTo: container.topAnchor, constant: 12),
            button.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 12),
            button.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -12),
            button.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -12)
        ])
    }

    // MARK: - Actions
    @objc private func rateAppTapped() {
        print("App Store'a yönlendirme")
    }

    @objc private func contactDevTapped() {
        print("Mail uygulamasını aç")
    }

    @objc private func privacyPolicyTapped() {
        print("Gizlilik sözleşmesi sayfası")
    }

    @objc private func backupTapped() {
        print("Veriler yedekleniyor")
    }

    @objc private func restoreTapped() {
        print("Yedek veriler yükleniyor")
    }

    @objc private func resetTapped() {
        print("Tüm veriler sıfırlanıyor")
    }
}
