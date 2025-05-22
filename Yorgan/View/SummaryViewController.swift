//
//  SummaryViewController.swift
//  Yorgan
//
//  Created by Berat Yükselen on 1.05.2025.
//

import UIKit
import DGCharts
import Charts

class SummaryViewController: UIViewController {

    private let scrollView = UIScrollView()
    private let stackView = UIStackView()

    private let expensesChartView = PieChartView()
    private let incomeChartView = PieChartView()
    private let totalChartView = PieChartView()

    private let expensesViewModel = ExpensesViewModel()
    private let incomeViewModel = IncomeViewModel()

    private var selectedMonth = Date()
    private let monthLabel = UILabel()
    private let previousMonthButton = UIButton(type: .system)
    private let nextMonthButton = UIButton(type: .system)

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "Özet"
        navigationController?.setNavigationBarHidden(true, animated: false)

        setupLayout()
        reloadCharts()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        reloadCharts()
    }

    private func setupLayout() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)

        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])

        stackView.axis = .vertical
        stackView.spacing = 32
        stackView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(stackView)

        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 20),
            stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -20),
            stackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -20),
            stackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor, constant: -40)
        ])

        previousMonthButton.setTitle("◀", for: .normal)
        nextMonthButton.setTitle("▶", for: .normal)
        previousMonthButton.addTarget(self, action: #selector(didTapPreviousMonth), for: .touchUpInside)
        nextMonthButton.addTarget(self, action: #selector(didTapNextMonth), for: .touchUpInside)

        let monthStack = UIStackView(arrangedSubviews: [previousMonthButton, monthLabel, nextMonthButton])
        monthStack.axis = .horizontal
        monthStack.alignment = .center
        monthStack.distribution = .equalCentering
        monthStack.spacing = 12
        stackView.addArrangedSubview(monthStack)
        updateMonthLabel()

        addChartSection(title: "Gelir vs Gider", chart: totalChartView)
        addChartSection(title: "Gider Dağılımı", chart: expensesChartView)
        addChartSection(title: "Gelir Dağılımı", chart: incomeChartView)

        [expensesChartView, incomeChartView, totalChartView].forEach { chart in
            chart.legend.enabled = true
            chart.holeRadiusPercent = 0.4
            chart.transparentCircleColor = .clear
            chart.entryLabelColor = .clear
        }
    }

    private func updateMonthLabel() {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM yyyy"
        monthLabel.text = formatter.string(from: selectedMonth)
        monthLabel.font = .boldSystemFont(ofSize: 16)
    }

    @objc private func didTapPreviousMonth() {
        selectedMonth = Calendar.current.date(byAdding: .month, value: -1, to: selectedMonth) ?? Date()
        updateMonthLabel()
        reloadCharts()
    }

    @objc private func didTapNextMonth() {
        selectedMonth = Calendar.current.date(byAdding: .month, value: 1, to: selectedMonth) ?? Date()
        updateMonthLabel()
        reloadCharts()
    }

    private func reloadCharts() {
        expensesViewModel.fetchExpenses(for: selectedMonth)
        incomeViewModel.fetchIncomes(for: selectedMonth)
        updateExpensesChart()
        updateIncomeChart()
        updateTotalChart()
    }

    private func addChartSection(title: String, chart: PieChartView) {
        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.font = UIFont.boldSystemFont(ofSize: 16)
        titleLabel.textAlignment = .center

        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(chart)

        chart.translatesAutoresizingMaskIntoConstraints = false
        chart.widthAnchor.constraint(equalTo: stackView.widthAnchor).isActive = true
        chart.heightAnchor.constraint(equalTo: chart.widthAnchor).isActive = true
    }

    private func updateExpensesChart() {
        let totals = expensesViewModel.categoryTotals(for: selectedMonth)

        let categoryOrder = ["Fatura", "Kira", "Borç", "Gıda", "Ulaşım", "Eğlence"]
        let categoryColors: [String: UIColor] = [
            "Fatura": .systemBlue,
            "Kira": .systemIndigo,
            "Borç": .systemRed,
            "Gıda": .systemGreen,
            "Ulaşım": .systemOrange,
            "Eğlence": .systemPurple,
            "Diğer": .systemGray
        ]

        var sortedEntries: [PieChartDataEntry] = []
        var sortedColors: [UIColor] = []

        for category in categoryOrder {
            if let amount = totals[category] {
                sortedEntries.append(PieChartDataEntry(value: amount, label: category))
                sortedColors.append(categoryColors[category] ?? .lightGray)
            }
        }

        if let otherAmount = totals["Diğer"] {
            sortedEntries.append(PieChartDataEntry(value: otherAmount, label: "Diğer"))
            sortedColors.append(categoryColors["Diğer"] ?? .lightGray)
        }

        let dataSet = PieChartDataSet(entries: sortedEntries, label: "")
        dataSet.colors = sortedColors
        dataSet.drawValuesEnabled = false
        expensesChartView.drawEntryLabelsEnabled = false

        let expenseTotal = totals.values.reduce(0, +)
        expensesChartView.holeColor = .clear
        expensesChartView.data = PieChartData(dataSet: dataSet)
        expensesChartView.centerText = "\(Int(expenseTotal)) ₺"
    }

    private func updateIncomeChart() {
        let categoryOrder = ["Maaş", "Harçlık", "Yatırım", "Ek Gelir", "Satış"]
        let categoryColors: [String: UIColor] = [
            "Maaş": .systemTeal,
            "Harçlık": .systemYellow,
            "Yatırım": .systemGreen,
            "Ek Gelir": .systemMint,
            "Satış": .systemPink,
            "Diğer": .systemGray
        ]

        let categoryData = incomeViewModel.categoryTotals(for: selectedMonth)

        var entries: [PieChartDataEntry] = []
        var colors: [UIColor] = []

        for category in categoryOrder {
            if let amount = categoryData[category] {
                entries.append(PieChartDataEntry(value: amount, label: category))
                colors.append(categoryColors[category] ?? .lightGray)
            }
        }

        if let otherAmount = categoryData["Diğer"] {
            entries.append(PieChartDataEntry(value: otherAmount, label: "Diğer"))
            colors.append(categoryColors["Diğer"] ?? .lightGray)
        }

        let dataSet = PieChartDataSet(entries: entries, label: "")
        dataSet.colors = colors
        dataSet.drawValuesEnabled = false
        incomeChartView.drawEntryLabelsEnabled = false

        let incomeTotal = categoryData.values.reduce(0, +)
        incomeChartView.holeColor = .clear
        incomeChartView.data = PieChartData(dataSet: dataSet)
        incomeChartView.centerText = "\(Int(incomeTotal)) ₺"
    }

    private func updateTotalChart() {
        let incomeTotal = incomeViewModel.categoryTotals(for: selectedMonth).values.reduce(0, +)
        let expenseTotal = expensesViewModel.categoryTotals(for: selectedMonth).values.reduce(0, +)
        let difference = incomeTotal - expenseTotal
        let emoji = difference >= 0 ? "🟢" : "🔴"

        let entries = [
            PieChartDataEntry(value: incomeTotal, label: "Gelir"),
            PieChartDataEntry(value: expenseTotal, label: "Gider")
        ]
        let dataSet = PieChartDataSet(entries: entries, label: "")
        dataSet.colors = [UIColor.systemGreen, UIColor.systemRed]
        dataSet.drawValuesEnabled = false

        totalChartView.holeColor = .clear
        totalChartView.data = PieChartData(dataSet: dataSet)
        totalChartView.centerText = "\(emoji) \(difference) ₺"
        totalChartView.drawEntryLabelsEnabled = false
    }
}
