//
//  ExpensesViewModel.swift
//  Yorgan
//
//  Created by Berat Yükselen on 5.05.2025.
//

import Foundation
import CoreData

class ExpensesViewModel {
    
    private(set) var expenses: [Expense] = []
    
    var onDataUpdated: (() -> Void)?
    
    func fetchExpenses() {
        expenses = CoreDataManager.shared.fetchExpenses()
        onDataUpdated?()
    }
    
    func numberOfItems() -> Int {
        return expenses.count
    }
    
    func expense(at index: Int) -> Expense {
        return expenses[index]
    }
    
    func addExpense(title: String, amount: Double, date: Date, category: String) {
        CoreDataManager.shared.saveExpense(title: title, amount: amount, date: date, category: category)
        fetchExpenses()
    }
    
    func categoryTotals() -> [String: Double] {
        var totals: [String: Double] = [:]
        for expense in expenses {
            let key = expense.category ?? "Bilinmiyor"
            totals[key, default: 0.0] += expense.amount
        }
        return totals
    }
    
    func totalAmount() -> Double {
        return expenses.reduce(0) { $0 + $1.amount }
    }

}
