//
//  AddExpensesViewController.swift
//  Yorgan
//
//  Created by Berat Yükselen on 5.05.2025.
//

import UIKit

class AddExpensesViewController: UIViewController {
    
    private let categories = ["Fatura", "Kira", "Borç", "Gıda", "Ulaşım", "Eğlence", "Diğer"]
    private var selectedCategory: String?
    private let categoryPicker = UIPickerView()

    private let amountTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Tutar (₺)"
        tf.borderStyle = .roundedRect
        tf.keyboardType = .decimalPad
        return tf
    }()
    
    private let titleTextField: UITextField = {
       let tf = UITextField()
        tf.placeholder = "Açıklama"
        tf.borderStyle = .roundedRect
        return tf
    }()
    
    private let categoryTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Kategori Seç"
        tf.borderStyle = .roundedRect
        return tf
    }()
    
    private let datePicker: UIDatePicker = {
        let dp = UIDatePicker()
        dp.datePickerMode = .date
        dp.preferredDatePickerStyle = .compact
        return dp
    }()
    
    private let saveButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("Kaydet", for: .normal)
        btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        btn.backgroundColor = .systemGreen
        btn.tintColor = .white
        btn.layer.cornerRadius = 10
        btn.heightAnchor.constraint(equalToConstant: 44).isActive = true
        return btn
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "Gider Ekle"

        categoryPicker.delegate = self
        categoryPicker.dataSource = self
        categoryTextField.inputView = categoryPicker
        
        setupLayout()
        saveButton.addTarget(self, action: #selector(saveTapped), for: .touchUpInside)
    }
    
    private func setupLayout() {
        let stack = UIStackView(arrangedSubviews: [
            amountTextField,
            titleTextField,
            categoryTextField,
            datePicker,
            saveButton
        ])
        stack.axis = .vertical
        stack.spacing = 16
        stack.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stack)
        
        NSLayoutConstraint.activate([
            stack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            stack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            stack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 40)
        ])
    }
    
    @objc private func saveTapped() {
        guard let amountText = amountTextField.text,
              let amount = Double(amountText),
              let title = titleTextField.text,
              let category = selectedCategory,
              !title.isEmpty else {
            let alert = UIAlertController(title: "Hata", message: "Tüm alanları doldurun", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Tamam", style: .default))
            present(alert, animated: true)
            return
        }
        
        CoreDataManager.shared.saveExpense(title: title, amount: amount, date: datePicker.date, category: category)
        
        NotificationCenter.default.post(name: NSNotification.Name("ExpenseAdded"), object: nil)
        
        dismiss(animated: true)
    }
}

extension AddExpensesViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int { return 1 }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return categories.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return categories[row]
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedCategory = categories[row]
        categoryTextField.text = categories[row]
        categoryTextField.resignFirstResponder()
    }
}
