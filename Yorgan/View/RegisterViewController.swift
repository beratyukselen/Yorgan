//
//  RegisterViewController.swift
//  Yorgan
//
//  Created by Berat Yükselen on 14.03.2025.
//

import UIKit

class RegisterViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, RegisterCellDelegate {
    
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
        return button
    }()
    
    private let nextButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("DEVAM", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = UIColor.systemGray
        button.layer.cornerRadius = 17
        button.isEnabled = false
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: "backgroundColor")
        
        navigationController?.setNavigationBarHidden(true, animated: false)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
        backButton.addTarget(self, action: #selector(handleBack), for: .touchUpInside)
        nextButton.addTarget(self, action: #selector(handleNext), for: .touchUpInside)
        
        setupViews()
    }
    
    private func setupViews() {
        view.addSubview(collectionView)
        view.addSubview(pageControl)
        view.addSubview(backButton)
        view.addSubview(nextButton)
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        backButton.translatesAutoresizingMaskIntoConstraints = false
        nextButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            pageControl.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 70),
            pageControl.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            backButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            backButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 17),
            
            nextButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -60),
            nextButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            nextButton.widthAnchor.constraint(equalToConstant: 340),
            nextButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    @objc private func handleBack() {
            if pageControl.currentPage == 0 {
                navigationController?.popViewController(animated: true)
            } else {
                let prevIndex = max(pageControl.currentPage - 1, 0)
                let contentOffset = CGPoint(x: CGFloat(prevIndex) * collectionView.frame.width, y: 0)
                collectionView.setContentOffset(contentOffset, animated: true)
                pageControl.currentPage = prevIndex
            }
        }
    
    @objc private func handleNext() {
        let nextIndex = min(pageControl.currentPage + 1, viewModel.pageCount - 1)
        
        let contentOffset = CGPoint(x: CGFloat(nextIndex) * collectionView.frame.width, y: 0)
        collectionView.setContentOffset(contentOffset, animated: true)
        
        pageControl.currentPage = nextIndex
        
    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.pageCount
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! RegisterCell
        cell.delegate = self
        let page = viewModel.getPage(at: indexPath.item)
        cell.configure(with: page, at: indexPath.item)
        return cell
    }

    
    func textFieldsDidChange(name: String?, surname: String?, phone: String?, pageIndex: Int) {

        var isValid = false

        if pageIndex == 0 {
            isValid = !(name?.isEmpty ?? true) && !(surname?.isEmpty ?? true)

            if let name = name, let surname = surname {
                isValid = isValid && name.count >= 2 && surname.count >= 2
            }

        } else if pageIndex == 1 {
            if let phone = phone {
                let digitsOnly = phone.filter { $0.isNumber }
                isValid = digitsOnly.count == 10
            }
        }

        nextButton.isEnabled = isValid
        nextButton.backgroundColor = isValid ? UIColor.systemBlue : UIColor.systemGray
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: view.frame.height)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let pageIndex = Int(round(scrollView.contentOffset.x / view.frame.width))
        
        if pageControl.currentPage != pageIndex {
            pageControl.currentPage = pageIndex
            nextButton.isEnabled = false
            nextButton.backgroundColor = UIColor.systemGray
        }
    }
}
