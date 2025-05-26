//  IncomesViewController.swift
//  Yorgan
//
//  Created by Berat Yükselen on 1.05.2025.

import UIKit

class IncomesViewController: UIViewController {

    private let tableView = UITableView()
    private let searchBar: UISearchBar = {
        let sb = UISearchBar()
        sb.placeholder = "Gelir ara"
        sb.translatesAutoresizingMaskIntoConstraints = false
        return sb
    }()

    private let monthLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 16)
        label.textAlignment = .center
        return label
    }()

    private let prevMonthButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("◀", for: .normal)
        return button
    }()

    private let nextMonthButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("▶", for: .normal)
        return button
    }()

    private let addButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(systemName: "plus"), for: .normal)
        button.tintColor = .white
        button.backgroundColor = .systemBlue
        button.layer.cornerRadius = 28
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOpacity = 0.3
        button.layer.shadowOffset = CGSize(width: 2, height: 2)
        button.layer.shadowRadius = 4
        return button
    }()

    private let topContainer = UIView()
    private let topStack = UIStackView()

    private let viewModel = IncomeViewModel()
    private var selectedMonth = Date()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "Gelirler"
        navigationController?.setNavigationBarHidden(true, animated: false)

        setupTopBar()
        setupTableView()
        setupAddButton()
        setupBindings()
        setupNotifications()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.fetchIncomes()
        viewModel.filter(searchText: searchBar.text ?? "", for: selectedMonth)
    }

    private func setupTopBar() {
        view.addSubview(topContainer)
        topContainer.translatesAutoresizingMaskIntoConstraints = false

        topStack.axis = .vertical
        topStack.spacing = 8
        topStack.alignment = .fill
        topStack.distribution = .fill
        topStack.translatesAutoresizingMaskIntoConstraints = false

        topContainer.addSubview(topStack)

        searchBar.delegate = self
        searchBar.heightAnchor.constraint(equalToConstant: 44).isActive = true
        topStack.addArrangedSubview(searchBar)

        let monthStack = UIStackView(arrangedSubviews: [prevMonthButton, monthLabel, nextMonthButton])
        monthStack.axis = .horizontal
        monthStack.spacing = 12
        monthStack.alignment = .center
        monthStack.distribution = .equalSpacing
        topStack.addArrangedSubview(monthStack)

        NSLayoutConstraint.activate([
            topContainer.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            topContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            topContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor),

            topStack.topAnchor.constraint(equalTo: topContainer.topAnchor, constant: 12),
            topStack.leadingAnchor.constraint(equalTo: topContainer.leadingAnchor, constant: 16),
            topStack.trailingAnchor.constraint(equalTo: topContainer.trailingAnchor, constant: -16),
            topStack.bottomAnchor.constraint(equalTo: topContainer.bottomAnchor, constant: -12)
        ])

        updateMonthLabel()

        prevMonthButton.addTarget(self, action: #selector(prevMonthTapped), for: .touchUpInside)
        nextMonthButton.addTarget(self, action: #selector(nextMonthTapped), for: .touchUpInside)
    }

    private func setupTableView() {
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: topContainer.bottomAnchor, constant: 8),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])

        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(TransactionCell.self, forCellReuseIdentifier: "TransactionCell")
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 60
    }

    private func setupAddButton() {
        view.addSubview(addButton)
        addButton.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            addButton.widthAnchor.constraint(equalToConstant: 56),
            addButton.heightAnchor.constraint(equalToConstant: 56),
            addButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            addButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -24)
        ])

        addButton.addTarget(self, action: #selector(addIncomeTapped), for: .touchUpInside)
    }

    private func setupBindings() {
        viewModel.onDataUpdated = { [weak self] in
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }
    }

    private func setupNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleIncomeAdded), name: NSNotification.Name("IncomeAdded"), object: nil)
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    @objc private func prevMonthTapped() {
        selectedMonth = Calendar.current.date(byAdding: .month, value: -1, to: selectedMonth) ?? Date()
        updateMonthLabel()
        viewModel.filter(searchText: searchBar.text ?? "", for: selectedMonth)
    }

    @objc private func nextMonthTapped() {
        selectedMonth = Calendar.current.date(byAdding: .month, value: 1, to: selectedMonth) ?? Date()
        updateMonthLabel()
        viewModel.filter(searchText: searchBar.text ?? "", for: selectedMonth)
    }

    @objc private func addIncomeTapped() {
        let vc = AddIncomeViewController()
        vc.modalPresentationStyle = .formSheet
        present(vc, animated: true, completion: nil)
    }

    @objc private func handleIncomeAdded() {
        viewModel.fetchIncomes {
            self.viewModel.filter(searchText: self.searchBar.text ?? "", for: self.selectedMonth)
        }
    }

    private func updateMonthLabel() {
        let formatter = DateFormatter()
        formatter.dateFormat = "LLLL yyyy"
        monthLabel.text = formatter.string(from: selectedMonth).capitalized
    }
}

extension IncomesViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel.filter(searchText: searchText, for: selectedMonth)
    }
}

extension IncomesViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfItems()
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TransactionCell", for: indexPath) as! TransactionCell
        let income = viewModel.income(at: indexPath.row)
        cell.configure(title: income.title ?? "Gelir", amount: income.amount, isIncome: true, date: income.date ?? Date())
        return cell
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let incomeToDelete = viewModel.income(at: indexPath.row)
            CoreDataManager.shared.deleteIncome(incomeToDelete)
            viewModel.fetchIncomes(for: selectedMonth)
            tableView.reloadData()
        }
    }
}
