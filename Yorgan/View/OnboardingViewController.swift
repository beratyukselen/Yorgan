//
//  OnboardingViewController.swift
//  Yorgan
//
//  Created by Berat Yükselen on 12.03.2025.
//

import UIKit

class OnboardingViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    private var viewModel = OnboardingViewModel()
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.isPagingEnabled = true
        cv.showsHorizontalScrollIndicator = false
        cv.delegate = self
        cv.dataSource = self
        cv.register(OnboardingCell.self, forCellWithReuseIdentifier: "cell")
        return cv
    }()
    
    private let pageControl: UIPageControl = {
        let pc = UIPageControl()
        pc.currentPage = 0
        pc.numberOfPages = 3
        pc.pageIndicatorTintColor = UIColor.systemGray
        pc.currentPageIndicatorTintColor = .systemBlue
        return pc
    }()
    
    private let nextButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("DEVAM", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .systemBlue
        button.layer.cornerRadius = 17
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
        return button
    }()
    
    private let skipButton: UIButton = {
        let button = UIButton(type: .system)

        let attributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor(named: "textColor") ?? UIColor.black,
            .font: UIFont.systemFont(ofSize: 15, weight: .medium)
        ]

        let title = NSMutableAttributedString(string: "ATLA", attributes: attributes)

        let imageAttachment = NSTextAttachment()
        if let chevronImage = UIImage(systemName: "chevron.right")?.withTintColor(UIColor(named: "textColor") ?? .black, renderingMode: .alwaysOriginal) {
            imageAttachment.image = chevronImage
        }
        let imageString = NSAttributedString(attachment: imageAttachment)

        title.append(imageString)

        button.setAttributedTitle(title, for: .normal)
        
        return button
    }()
    
    private let loginButton: UIButton = {
        let button = UIButton(type: .system)
        
        let normalAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 15),
            .foregroundColor: UIColor(named: "textColor") ?? UIColor.black
        ]
        
        let boldAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.boldSystemFont(ofSize: 15),
            .foregroundColor: UIColor(named: "textColor") ?? UIColor.black
        ]
        
        let attributedString = NSMutableAttributedString(string: "Zaten üye misin?", attributes: normalAttributes)
        
        let boldPart = NSAttributedString(string: " Giriş", attributes: boldAttributes)
        attributedString.append(boldPart)
        
        let normalPart = NSAttributedString(string: " Yap", attributes: normalAttributes)
        attributedString.append(normalPart)
        
        button.setAttributedTitle(attributedString, for: .normal)
        
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: "backgroundColor")
        
        navigationController?.setNavigationBarHidden(true, animated: false)
        
        nextButton.addTarget(self, action: #selector(handleNext), for: .touchUpInside)
        skipButton.addTarget(self, action: #selector(handleSkip), for: .touchUpInside)
        loginButton.addTarget(self, action: #selector(handleLogin), for: .touchUpInside)

        setupViews()
    }
    
    private func setupViews() {
        view.addSubview(collectionView)
        view.addSubview(pageControl)
        view.addSubview(nextButton)
        view.addSubview(skipButton)
        view.addSubview(loginButton)

        collectionView.translatesAutoresizingMaskIntoConstraints = false
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        nextButton.translatesAutoresizingMaskIntoConstraints = false
        skipButton.translatesAutoresizingMaskIntoConstraints = false
        loginButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            pageControl.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 70),
            pageControl.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            nextButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -60),
            nextButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            nextButton.widthAnchor.constraint(equalToConstant: 340),
            nextButton.heightAnchor.constraint(equalToConstant: 50),
            
            skipButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 17),
            skipButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            loginButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -15),
            loginButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }

    @objc private func handleNext() {
        if pageControl.currentPage == viewModel.pageCount - 1 {
            goToRegisterScreen()
        } else {
            let nextIndex = min(pageControl.currentPage + 1, viewModel.pageCount - 1)

            let contentOffset = CGPoint(x: CGFloat(nextIndex) * collectionView.frame.width, y: 0)
            collectionView.setContentOffset(contentOffset, animated: true)

            pageControl.currentPage = nextIndex

            if pageControl.currentPage == viewModel.pageCount - 1 {
                nextButton.setTitle("KAYIT OL", for: .normal)
            } else {
                nextButton.setTitle("DEVAM", for: .normal)
            }
        }
    }

    
    @objc private func handleSkip() {
        finishOnboarding()
    }
    
    @objc private func handleLogin() {
        let loginVC = LoginViewController()
        navigationController?.pushViewController(loginVC, animated: true)
    }

    
    private func goToRegisterScreen() {
        let registerVC = RegisterViewController()
        navigationController?.pushViewController(registerVC, animated: true)
    }

    private func finishOnboarding() {
        let registerVC = RegisterViewController()
        navigationController?.pushViewController(registerVC, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.pageCount
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! OnboardingCell
        let page = viewModel.getPage(at: indexPath.item)
        cell.onboardingLabel.text = page.onboarding
        cell.imageView.image = UIImage(named: page.image)
        cell.titleLabel.text = page.title
        cell.descriptionLabel.text = page.description
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: view.frame.height)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let pageIndex = round(scrollView.contentOffset.x / view.frame.width)
        pageControl.currentPage = Int(pageIndex)
        
        if pageControl.currentPage == viewModel.pageCount - 1 {
            nextButton.setTitle("KAYIT OL", for: .normal)
        } else {
            nextButton.setTitle("DEVAM", for: .normal)
        }
    }
}

#Preview {
    OnboardingViewController()
}

