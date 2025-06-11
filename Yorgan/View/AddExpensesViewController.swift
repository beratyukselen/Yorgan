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
    
    private let recurrenceOptions = ["Günlük", "Haftalık", "Aylık"]
    private var selectedRecurrence: String?
    private let recurrencePicker = UIPickerView()
    
    private let isRecurringSwitch: UISwitch = {
        let sw = UISwitch()
        sw.isOn = false
        return sw
    }()
    
    private let isRecurringLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "Tekrarlayan Gider"
        return lbl
    }()
    
    private let recurrenceTypeTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Tekrar Sıklığı"
        tf.borderStyle = .roundedRect
        tf.isHidden = true
        return tf
    }()
    
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
        
        recurrencePicker.delegate = self
        recurrencePicker.dataSource = self
        recurrenceTypeTextField.inputView = recurrencePicker
        
        isRecurringSwitch.addTarget(self, action: #selector(recurringSwitchChanged), for: .valueChanged)
        
        setupLayout()
        saveButton.addTarget(self, action: #selector(saveTapped), for: .touchUpInside)
    }
    
    private func setupLayout() {
        let recurringStack = UIStackView(arrangedSubviews: [isRecurringLabel, isRecurringSwitch])
        recurringStack.axis = .horizontal
        recurringStack.spacing = 12
        
        let stack = UIStackView(arrangedSubviews: [
            amountTextField,
            titleTextField,
            categoryTextField,
            datePicker,
            recurringStack,
            recurrenceTypeTextField,
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
    
    @objc private func recurringSwitchChanged() {
        recurrenceTypeTextField.isHidden = !isRecurringSwitch.isOn
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
        
        let userEmail = UserDefaults.standard.string(forKey: "currentUserEmail") ?? ""
        let isRecurring = isRecurringSwitch.isOn
        let recurrenceType = isRecurring ? selectedRecurrence ?? "Aylık" : nil
        let nextDueDate = isRecurring ? calculateNextDate(from: datePicker.date, recurrenceType: recurrenceType!) : nil

        CoreDataManager.shared.saveExpense(
            title: title,
            amount: amount,
            date: datePicker.date,
            category: category,
            userEmail: userEmail,
            isRecurring: isRecurring,
            recurrenceType: recurrenceType,
            nextDueDate: nextDueDate
        )

        NotificationCenter.default.post(name: NSNotification.Name("ExpenseAdded"), object: nil)
        dismiss(animated: true)
    }
    
    private func calculateNextDate(from date: Date, recurrenceType: String) -> Date {
        var component = DateComponents()
        switch recurrenceType {
        case "Günlük": component.day = 1
        case "Haftalık": component.day = 7
        case "Aylık": component.month = 1
        default: break
        }
        return Calendar.current.date(byAdding: component, to: date) ?? date
    }
}

extension AddExpensesViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int { return 1 }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == categoryPicker {
            return categories.count
        } else {
            return recurrenceOptions.count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == categoryPicker {
            return categories[row]
        } else {
            return recurrenceOptions[row]
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == categoryPicker {
            selectedCategory = categories[row]
            categoryTextField.text = categories[row]
            categoryTextField.resignFirstResponder()
        } else {
            selectedRecurrence = recurrenceOptions[row]
            recurrenceTypeTextField.text = recurrenceOptions[row]
            recurrenceTypeTextField.resignFirstResponder()
        }
    }
}
