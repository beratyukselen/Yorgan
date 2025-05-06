//
//  SummaryViewController.swift
//  Yorgan
//
//  Created by Berat Yükselen on 1.05.2025.
//

import UIKit
import DGCharts

class SummaryViewController: UIViewController {

    private let scrollView = UIScrollView()
    private let stackView = UIStackView()

    private let expensesChartView = PieChartView()
    private let incomeChartView = PieChartView()
    private let totalChartView = PieChartView()

    private let expensesViewModel = ExpensesViewModel()
    private let incomeViewModel = IncomeViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "Özet"
        navigationController?.setNavigationBarHidden(true, animated: false)

        setupLayout()

        expensesViewModel.fetchExpenses()
        incomeViewModel.fetchIncomes()

        updateExpensesChart()
        updateIncomeChart()
        updateTotalChart()
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

        addChartSection(title: "Gider Dağılımı", chart: expensesChartView)
        addChartSection(title: "Gelir Dağılımı", chart: incomeChartView)
        addChartSection(title: "Gelir vs Gider", chart: totalChartView)

        [expensesChartView, incomeChartView, totalChartView].forEach { chart in
            chart.legend.enabled = true
            chart.holeRadiusPercent = 0.4
            chart.transparentCircleColor = .clear
            chart.entryLabelColor = .black
        }
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
        let data = expensesViewModel.categoryTotals().map {
            PieChartDataEntry(value: $0.value, label: $0.key)
        }
        let dataSet = PieChartDataSet(entries: data, label: "")
        dataSet.colors = ChartColorTemplates.material()
        expensesChartView.data = PieChartData(dataSet: dataSet)

        
        let expenseTotal = expensesViewModel.categoryTotals().values.reduce(0, +)
        expensesChartView.holeColor = .clear
        expensesChartView.data = PieChartData(dataSet: dataSet)
        expensesChartView.centerText = "\(expenseTotal) ₺"
        
    }

    private func updateIncomeChart() {
        let data = incomeViewModel.categoryTotals().map {
            PieChartDataEntry(value: $0.value, label: $0.key)
        }
        let dataSet = PieChartDataSet(entries: data, label: "")
        dataSet.colors = ChartColorTemplates.pastel()
        incomeChartView.data = PieChartData(dataSet: dataSet)
        
        let incomeTotal = incomeViewModel.categoryTotals().values.reduce(0, +)
        incomeChartView.holeColor = .clear
        incomeChartView.data = PieChartData(dataSet: dataSet)
        incomeChartView.centerText = "\(incomeTotal) ₺"
        
    }

    private func updateTotalChart() {
        let incomeTotal = incomeViewModel.categoryTotals().values.reduce(0, +)
        let expenseTotal = expensesViewModel.categoryTotals().values.reduce(0, +)
        let difference = incomeTotal - expenseTotal
        let emoji = difference >= 0 ? "🟢" : "🔴"

        let entries = [
            PieChartDataEntry(value: incomeTotal, label: "Gelir"),
            PieChartDataEntry(value: expenseTotal, label: "Gider")
        ]
        let dataSet = PieChartDataSet(entries: entries, label: "")
        dataSet.colors = [UIColor.systemGreen, UIColor.systemRed]
        
        totalChartView.holeColor = .clear
        totalChartView.data = PieChartData(dataSet: dataSet)
        totalChartView.centerText = "\(emoji) \(difference) ₺"
        
        
    }
}

