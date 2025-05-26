//
//  ExpensesViewModel.swift
//  Yorgan
//
//  Created by Berat Yükselen on 5.05.2025.
//

import Foundation
import CoreData

class ExpensesViewModel {

    private var allExpenses: [Expense] = []
    private(set) var expenses: [Expense] = []
    var onDataUpdated: (() -> Void)?

    func fetchExpenses(completion: (() -> Void)? = nil) {
        let userEmail = UserDefaults.standard.string(forKey: "currentUserEmail") ?? ""
        allExpenses = CoreDataManager.shared.fetchExpenses(for: userEmail)
        expenses = allExpenses
        onDataUpdated?()
        completion?()
    }

    func fetchExpenses(for date: Date) {
        let userEmail = UserDefaults.standard.string(forKey: "currentUserEmail") ?? ""
        allExpenses = CoreDataManager.shared.fetchExpenses(for: userEmail)

        let calendar = Calendar.current
        expenses = allExpenses.filter { expense in
            guard let expenseDate = expense.date else { return false }
            return calendar.isDate(expenseDate, equalTo: date, toGranularity: .month) &&
                   calendar.isDate(expenseDate, equalTo: date, toGranularity: .year)
        }

        onDataUpdated?()
    }

    func numberOfItems() -> Int {
        return expenses.count
    }

    func expense(at index: Int) -> Expense {
        return expenses[index]
    }

    func addExpense(title: String, amount: Double, date: Date, category: String) {
        let userEmail = UserDefaults.standard.string(forKey: "currentUserEmail") ?? ""
        CoreDataManager.shared.saveExpense(title: title, amount: amount, date: date, category: category, userEmail: userEmail)
        fetchExpenses()
    }
    
    func removeExpense(at index: Int) {
        let expense = expenses[index]
        CoreDataManager.shared.deleteExpense(expense)
        expenses.remove(at: index)
        allExpenses.removeAll { $0.objectID == expense.objectID }
        onDataUpdated?()
    }

    func categoryTotals() -> [String: Double] {
        var totals: [String: Double] = [:]
        for expense in expenses {
            let key = expense.category ?? "Bilinmiyor"
            totals[key, default: 0.0] += expense.amount
        }
        return totals
    }

    func categoryTotals(for date: Date) -> [String: Double] {
        let calendar = Calendar.current
        let filtered = allExpenses.filter { expense in
            guard let expenseDate = expense.date else { return false }
            return calendar.isDate(expenseDate, equalTo: date, toGranularity: .month) &&
                   calendar.isDate(expenseDate, equalTo: date, toGranularity: .year)
        }

        var totals: [String: Double] = [:]
        for expense in filtered {
            let key = expense.category ?? "Bilinmiyor"
            totals[key, default: 0.0] += expense.amount
        }

        return totals
    }

    func totalAmount() -> Double {
        return expenses.reduce(0) { $0 + $1.amount }
    }

    func filter(searchText: String, for month: Date) {
        let calendar = Calendar.current

        expenses = allExpenses.filter { expense in
            guard let title = expense.title?.lowercased(), let date = expense.date else { return false }
            let matchesText = searchText.isEmpty || title.contains(searchText.lowercased())
            let sameMonth = calendar.isDate(date, equalTo: month, toGranularity: .month)
            let sameYear = calendar.isDate(date, equalTo: month, toGranularity: .year)
            return matchesText && sameMonth && sameYear
        }

        onDataUpdated?()
    }
}
