//
//  RegisterViewController.swift
//  Yorgan
//
//  Created by Berat Yükselen on 14.03.2025.
//

import UIKit

class RegisterViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    private var viewModel = RegisterViewModel()
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.isPagingEnabled = true
        cv.showsHorizontalScrollIndicator = false
        cv.delegate = self
        cv.dataSource = self
        cv.register(RegisterCell.self, forCellWithReuseIdentifier: "cell")
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
    
    private let backButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "chevron.left"), for: .normal)
        button.tintColor = UIColor(named: "textColor")
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        backButton.addTarget(self, action: #selector(handleBack), for: .touchUpInside)
        setupViews()
    }
    
    private func setupViews() {
        view.addSubview(collectionView)
        view.addSubview(pageControl)
        view.addSubview(backButton)
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            pageControl.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 70),
            pageControl.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            backButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            backButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10)
            
        ])
    }
    
    @objc private func handleBack() {
        navigationController?.popViewController(animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.pageCount // Kaç sayfa varsa o kadar hücre oluştur
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! RegisterCell
        let page = viewModel.getPage(at: indexPath.item)
        cell.registerLabel.text = page.register
        cell.nameLabel.text = page.name
        cell.surnameLabel.text = page.surname
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: view.frame.height)
    }
}
