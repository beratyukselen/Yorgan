//
//  IncomeViewModel.swift
//  Yorgan
//
//  Created by Berat Yükselen on 5.05.2025.
//

import Foundation
import CoreData

class IncomeViewModel {

    private var allIncomes: [Income] = []
    private(set) var incomes: [Income] = []

    var onDataUpdated: (() -> Void)?

    func fetchIncomes() {
        let userEmail = UserDefaults.standard.string(forKey: "currentUserEmail") ?? ""
        allIncomes = CoreDataManager.shared.fetchIncomes(for: userEmail)
        incomes = allIncomes
        onDataUpdated?()
    }

    func fetchIncomes(for date: Date) {
        let userEmail = UserDefaults.standard.string(forKey: "currentUserEmail") ?? ""
        allIncomes = CoreDataManager.shared.fetchIncomes(for: userEmail)

        let calendar = Calendar.current
        incomes = allIncomes.filter { income in
            guard let incomeDate = income.date else { return false }
            return calendar.isDate(incomeDate, equalTo: date, toGranularity: .month) &&
                   calendar.isDate(incomeDate, equalTo: date, toGranularity: .year)
        }

        onDataUpdated?()
    }

    func filter(searchText: String, for month: Date) {
        incomes = allIncomes.filter { income in
            let titleMatches = searchText.isEmpty || (income.title?.lowercased().contains(searchText.lowercased()) ?? false)
            let calendar = Calendar.current
            let dateMatches = calendar.isDate(income.date ?? Date(), equalTo: month, toGranularity: .month)
            return titleMatches && dateMatches
        }
        onDataUpdated?()
    }

    func numberOfItems() -> Int {
        return incomes.count
    }

    func income(at index: Int) -> Income {
        return incomes[index]
    }

    func addIncome(title: String, amount: Double, date: Date, category: String) {
        let userEmail = UserDefaults.standard.string(forKey: "currentUserEmail") ?? ""
        CoreDataManager.shared.saveIncome(title: title, amount: amount, date: date, category: category, userEmail: userEmail)
        fetchIncomes()
    }
    
    func removeIncome(at index: Int) {
        let income = incomes[index]
        CoreDataManager.shared.deleteIncome(income)
        incomes.remove(at: index)
        allIncomes.removeAll { $0.objectID == income.objectID }
        onDataUpdated?()
    }

    func categoryTotals() -> [String: Double] {
        var totals: [String: Double] = [:]
        for income in incomes {
            let category = income.category ?? "Diğer"
            totals[category, default: 0.0] += income.amount
        }
        return totals
    }

    func categoryTotals(for date: Date) -> [String: Double] {
        let calendar = Calendar.current
        let filtered = allIncomes.filter { income in
            guard let incomeDate = income.date else { return false }
            return calendar.isDate(incomeDate, equalTo: date, toGranularity: .month) &&
                   calendar.isDate(incomeDate, equalTo: date, toGranularity: .year)
        }

        var totals: [String: Double] = [:]
        for income in filtered {
            let category = income.category ?? "Diğer"
            totals[category, default: 0.0] += income.amount
        }

        return totals
    }

    func totalAmount() -> Double {
        return incomes.reduce(0) { $0 + $1.amount }
    }
}
