//
//  ProfileViewController.swift
//  Yorgan
//
//  Created by Berat Yükselen on 1.05.2025.
//

import UIKit
import FirebaseFirestore

class ProfileViewController: UIViewController {

    private let scrollView = UIScrollView()
    private let contentView = UIStackView()

    private let userInfoCard = UIView()
    private let nameLabel = UILabel()
    private let surnameLabel = UILabel()
    private let emailLabel = UILabel()

    private let infoHeaderLabel = UILabel()
    private let rateAppButton = UIButton(type: .system)
    private let contactDevButton = UIButton(type: .system)
    private let privacyPolicyButton = UIButton(type: .system)

    private let versionLabel = UILabel()

    private let dataHeaderLabel = UILabel()
    private let backupButton = UIButton(type: .system)
    private let restoreButton = UIButton(type: .system)
    private let resetButton = UIButton(type: .system)

    private let logoutButton = UIButton(type: .system)

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "Profil"
        navigationController?.setNavigationBarHidden(true, animated: false)

        setupScrollView()
        setupUserInfoCard()
        setupInfoSection()
        setupVersionInfo()
        setupDataSection()
        setupLogoutButton()

        fetchUserData()
    }

    private func setupScrollView() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)

        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])

        contentView.axis = .vertical
        contentView.spacing = 20
        contentView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(contentView)

        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 20),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -20),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 20),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -20),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor, constant: -40),
            contentView.heightAnchor.constraint(greaterThanOrEqualTo: scrollView.heightAnchor)
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

    private func setupLogoutButton() {
        logoutButton.setTitle("Çıkış Yap", for: .normal)
        logoutButton.setTitleColor(.systemRed, for: .normal)
        logoutButton.titleLabel?.font = .systemFont(ofSize: 16, weight: .semibold)
        logoutButton.addTarget(self, action: #selector(logoutTapped), for: .touchUpInside)
        contentView.addArrangedSubview(logoutButton)
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

    private func fetchUserData() {
        guard let email = UserDefaults.standard.string(forKey: "currentUserEmail") else {
            print("KAYITLI EMAIL YOK")
            return
        }

        print("📧 Doküman ID ile veri çekiliyor: \(email)")

        let db = Firestore.firestore()
        db.collection("users").document(email).getDocument { snapshot, error in
            if let error = error {
                print("❌ Firestore Hatası: \(error.localizedDescription)")
                return
            }

            guard let data = snapshot?.data() else {
                print("⚠️ Veri bulunamadı.")
                return
            }

            print("✅ Kullanıcı bulundu: \(data)")
            self.nameLabel.text = data["name"] as? String ?? "-"
            self.surnameLabel.text = data["surname"] as? String ?? "-"
            self.emailLabel.text = data["email"] as? String ?? "-"
        }
    }

    // MARK: - Actions
    @objc private func rateAppTapped() {
        if let url = URL(string: "itms-apps://itunes.apple.com/app/idYOUR_APP_ID") {
            UIApplication.shared.open(url)
        }
    }

    @objc private func contactDevTapped() {
        if let url = URL(string: "mailto:berat@example.com") {
            UIApplication.shared.open(url)
        }
    }

    @objc private func privacyPolicyTapped() {
        if let url = URL(string: "https://yourapp.com/privacy") {
            UIApplication.shared.open(url)
        }
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

    @objc private func logoutTapped() {
        UserDefaults.standard.removeObject(forKey: "currentUserEmail")

        let onboardingVC = OnboardingViewController()
        let nav = UINavigationController(rootViewController: onboardingVC)
        nav.modalPresentationStyle = .fullScreen

        if let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate,
           let window = sceneDelegate.window {
            window.rootViewController = nav
            window.makeKeyAndVisible()
        }
    }

}
