//  HomeViewController.swift
//  Yorgan
//
//  Created by Berat Yükselen on 10.04.2025.

import UIKit
import FirebaseFirestore

class HomeViewController: UIViewController {

    private let profileImageView = UIImageView()
    private let greetingTitleLabel = UILabel()
    private let greetingSubtitleLabel = UILabel()
    private let balanceCard = UIView()
    private let balanceTitleLabel = UILabel()
    private let balanceValueLabel = UILabel()
    private let lastTransactionsTitleLabel = UILabel()
    private let transactionsTableView = UITableView()
    private let seeAllButton = UIButton(type: .system)

    private let incomeViewModel = IncomeViewModel()
    private let expenseViewModel = ExpensesViewModel()

    private var allTransactions: [(title: String, amount: Double, isIncome: Bool, date: Date)] = []
    private var showingAllTransactions = false

    private var selectedMonth = Date()
    private let monthLabel = UILabel()
    private let previousMonthButton = UIButton(type: .system)
    private let nextMonthButton = UIButton(type: .system)

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        navigationController?.setNavigationBarHidden(true, animated: false)
        setupUI()
        setupBindings()
        fetchUserAndData()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateFilteredContent()
    }

    private func setupUI() {
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        profileImageView.image = UIImage(systemName: "person.circle.fill")
        profileImageView.tintColor = .gray
        profileImageView.contentMode = .scaleAspectFill
        profileImageView.clipsToBounds = true

        greetingTitleLabel.font = .boldSystemFont(ofSize: 24)
        greetingTitleLabel.textColor = .label

        greetingSubtitleLabel.font = .systemFont(ofSize: 14)
        greetingSubtitleLabel.textColor = .secondaryLabel

        let greetingStack = UIStackView(arrangedSubviews: [greetingTitleLabel, greetingSubtitleLabel])
        greetingStack.axis = .vertical
        greetingStack.spacing = 4

        let headerStack = UIStackView(arrangedSubviews: [profileImageView, greetingStack])
        headerStack.axis = .horizontal
        headerStack.spacing = 12
        headerStack.alignment = .center
        headerStack.translatesAutoresizingMaskIntoConstraints = false

        previousMonthButton.setTitle("◀", for: .normal)
        nextMonthButton.setTitle("▶", for: .normal)
        previousMonthButton.addTarget(self, action: #selector(didTapPreviousMonth), for: .touchUpInside)
        nextMonthButton.addTarget(self, action: #selector(didTapNextMonth), for: .touchUpInside)

        monthLabel.textAlignment = .center
        monthLabel.font = .boldSystemFont(ofSize: 16)
        updateMonthLabel()

        let monthStack = UIStackView(arrangedSubviews: [previousMonthButton, monthLabel, nextMonthButton])
        monthStack.axis = .horizontal
        monthStack.spacing = 12
        monthStack.alignment = .center
        monthStack.distribution = .equalCentering

        balanceCard.backgroundColor = UIColor.systemBlue
        balanceCard.layer.cornerRadius = 20
        balanceCard.translatesAutoresizingMaskIntoConstraints = false

        balanceTitleLabel.text = "Toplam Bakiye"
        balanceTitleLabel.textColor = .white
        balanceTitleLabel.font = .systemFont(ofSize: 16, weight: .medium)

        balanceValueLabel.text = "0 ₺"
        balanceValueLabel.textColor = .white
        balanceValueLabel.font = .boldSystemFont(ofSize: 32)

        let balanceStack = UIStackView(arrangedSubviews: [balanceTitleLabel, balanceValueLabel])
        balanceStack.axis = .vertical
        balanceStack.spacing = 8
        balanceStack.translatesAutoresizingMaskIntoConstraints = false

        balanceCard.addSubview(balanceStack)

        NSLayoutConstraint.activate([
            balanceStack.topAnchor.constraint(equalTo: balanceCard.topAnchor, constant: 20),
            balanceStack.leadingAnchor.constraint(equalTo: balanceCard.leadingAnchor, constant: 20),
            balanceStack.trailingAnchor.constraint(equalTo: balanceCard.trailingAnchor, constant: -20),
            balanceStack.bottomAnchor.constraint(equalTo: balanceCard.bottomAnchor, constant: -20)
        ])

        lastTransactionsTitleLabel.text = "📋  Son İşlemler"
        lastTransactionsTitleLabel.font = .systemFont(ofSize: 16, weight: .medium)
        lastTransactionsTitleLabel.textColor = .label

        transactionsTableView.register(TransactionCell.self, forCellReuseIdentifier: "TransactionCell")
        transactionsTableView.dataSource = self
        transactionsTableView.translatesAutoresizingMaskIntoConstraints = false
        transactionsTableView.isScrollEnabled = false
        transactionsTableView.rowHeight = 60

        seeAllButton.setTitle("Tüm İşlemleri Gör", for: .normal)
        seeAllButton.titleLabel?.font = .systemFont(ofSize: 14, weight: .medium)
        seeAllButton.setTitleColor(.systemBlue, for: .normal)
        seeAllButton.addTarget(self, action: #selector(toggleTransactions), for: .touchUpInside)

        let stack = UIStackView(arrangedSubviews: [headerStack, monthStack, balanceCard, lastTransactionsTitleLabel, transactionsTableView, seeAllButton])
        stack.axis = .vertical
        stack.spacing = 24
        stack.alignment = .fill
        stack.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(stack)

        NSLayoutConstraint.activate([
            profileImageView.widthAnchor.constraint(equalToConstant: 48),
            profileImageView.heightAnchor.constraint(equalToConstant: 48),

            stack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 24),
            stack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            stack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            transactionsTableView.heightAnchor.constraint(equalToConstant: 300)
        ])
    }

    @objc private func toggleTransactions() {
        showingAllTransactions.toggle()
        updateTransactions()
    }

    @objc private func didTapPreviousMonth() {
        selectedMonth = Calendar.current.date(byAdding: .month, value: -1, to: selectedMonth) ?? Date()
        updateMonthLabel()
        updateFilteredContent()
    }

    @objc private func didTapNextMonth() {
        selectedMonth = Calendar.current.date(byAdding: .month, value: 1, to: selectedMonth) ?? Date()
        updateMonthLabel()
        updateFilteredContent()
    }

    private func updateMonthLabel() {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM yyyy"
        monthLabel.text = formatter.string(from: selectedMonth)
    }

    private func setupBindings() {
        incomeViewModel.onDataUpdated = { [weak self] in
            self?.updateBalance()
            self?.updateTransactions()
        }

        expenseViewModel.onDataUpdated = { [weak self] in
            self?.updateBalance()
            self?.updateTransactions()
        }
    }

    private func fetchUserAndData() {
        guard let email = UserDefaults.standard.string(forKey: "currentUserEmail") else { return }

        let db = Firestore.firestore()
        db.collection("users").document(email).getDocument { snapshot, error in
            if let data = snapshot?.data(), let name = data["name"] as? String {
                DispatchQueue.main.async {
                    self.greetingTitleLabel.text = name
                    self.greetingSubtitleLabel.text = "Hoş Geldiniz"
                }
            }
        }

        updateFilteredContent()
    }

    private func updateFilteredContent() {
        incomeViewModel.fetchIncomes(for: selectedMonth)
        expenseViewModel.fetchExpenses(for: selectedMonth)
    }

    private func updateBalance() {
        let incomeTotal = incomeViewModel.totalAmount()
        let expenseTotal = expenseViewModel.totalAmount()
        let balance = incomeTotal - expenseTotal

        DispatchQueue.main.async {
            let formatted = String(format: "%.2f", balance)
            self.balanceValueLabel.text = "\(balance < 0 ? "" : "")\(formatted) ₺"
        }
    }

    private func updateTransactions() {
        let incomes = incomeViewModel.incomes.map { ($0.title ?? "Gelir", $0.amount, true, $0.date ?? Date()) }
        let expenses = expenseViewModel.expenses.map { ($0.title ?? "Gider", $0.amount, false, $0.date ?? Date()) }
        let merged = (incomes + expenses).sorted { $0.3 > $1.3 }

        allTransactions = merged

        DispatchQueue.main.async {
            self.transactionsTableView.reloadData()
            self.seeAllButton.isHidden = self.showingAllTransactions || self.allTransactions.count <= 5
        }
    }
}

extension HomeViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return showingAllTransactions ? allTransactions.count : min(5, allTransactions.count)
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TransactionCell", for: indexPath) as! TransactionCell
        let item = allTransactions[indexPath.row]
        cell.configure(title: item.title, amount: item.amount, isIncome: item.isIncome, date: item.date)
        return cell
    }
}

class TransactionCell: UITableViewCell {
    private let titleLabel = UILabel()
    private let amountLabel = UILabel()
    private let dateLabel = UILabel()
    private let stack = UIStackView()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        titleLabel.font = .systemFont(ofSize: 15, weight: .regular)
        dateLabel.font = .systemFont(ofSize: 12, weight: .light)
        dateLabel.textColor = .secondaryLabel
        amountLabel.font = .systemFont(ofSize: 16, weight: .semibold)
        amountLabel.setContentHuggingPriority(.required, for: .horizontal)
        amountLabel.setContentCompressionResistancePriority(.required, for: .horizontal)
        amountLabel.translatesAutoresizingMaskIntoConstraints = false

        stack.axis = .vertical
        stack.spacing = 4
        stack.translatesAutoresizingMaskIntoConstraints = false

        stack.addArrangedSubview(titleLabel)
        stack.addArrangedSubview(dateLabel)

        contentView.addSubview(stack)
        contentView.addSubview(amountLabel)

        NSLayoutConstraint.activate([
            stack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            stack.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            amountLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            amountLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }

    func configure(title: String, amount: Double, isIncome: Bool, date: Date) {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy"
        titleLabel.text = title
        dateLabel.text = formatter.string(from: date)
        amountLabel.text = String(format: "%.2f ₺", amount)
        amountLabel.textColor = isIncome ? .systemGreen : .systemRed
    }
}
