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
        
        // 🔁 Tekrarlayan giderleri kontrol et
        processRecurringExpenses(for: userEmail)

        expenses = allExpenses
        onDataUpdated?()
        completion?()
    }

    func fetchExpenses(for date: Date) {
        let userEmail = UserDefaults.standard.string(forKey: "currentUserEmail") ?? ""
        allExpenses = CoreDataManager.shared.fetchExpenses(for: userEmail)

        processRecurringExpenses(for: userEmail)

        let calendar = Calendar.current
        expenses = allExpenses.filter { expense in
            guard let expenseDate = expense.date else { return false }
            return calendar.isDate(expenseDate, equalTo: date, toGranularity: .month) &&
                   calendar.isDate(expenseDate, equalTo: date, toGranularity: .year)
        }

        onDataUpdated?()
    }

    private func processRecurringExpenses(for userEmail: String) {
        let calendar = Calendar.current
        var updated = false

        for expense in allExpenses {
            guard
                expense.isRecurring,
                var nextDate = expense.nextDueDate,
                let recurrenceType = expense.recurrenceType
            else { continue }

            var component = DateComponents()
            switch recurrenceType {
            case "Günlük": component.day = 1
            case "Haftalık": component.day = 7
            case "Aylık": component.month = 1
            default: continue
            }

            while nextDate <= Date() {
                let alreadyExists = CoreDataManager.shared.isRecurringExpenseAlreadyAdded(
                    title: expense.title ?? "",
                    amount: expense.amount,
                    date: nextDate,
                    userEmail: userEmail
                )

                if !alreadyExists {
                    CoreDataManager.shared.saveExpense(
                        title: expense.title ?? "",
                        amount: expense.amount,
                        date: nextDate,
                        category: expense.category ?? "",
                        userEmail: userEmail,
                        isRecurring: true,
                        recurrenceType: recurrenceType,
                        nextDueDate: nil
                    )
                    updated = true
                }

                nextDate = calendar.date(byAdding: component, to: nextDate) ?? nextDate
            }

            expense.nextDueDate = nextDate
        }

        if updated {
            CoreDataManager.shared.saveContext()
            allExpenses = CoreDataManager.shared.fetchExpenses(for: userEmail)
        }
    }

    func numberOfItems() -> Int {
        return expenses.count
    }

    func expense(at index: Int) -> Expense {
        return expenses[index]
    }

    func addExpense(title: String, amount: Double, date: Date, category: String) {
        let userEmail = UserDefaults.standard.string(forKey: "currentUserEmail") ?? ""
        CoreDataManager.shared.saveExpense(
            title: title,
            amount: amount,
            date: date,
            category: category,
            userEmail: userEmail,
            isRecurring: false,
            recurrenceType: nil,
            nextDueDate: nil
        )
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
