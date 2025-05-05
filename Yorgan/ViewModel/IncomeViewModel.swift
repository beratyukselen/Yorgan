//
//  IncomeViewModel.swift
//  Yorgan
//
//  Created by Berat Yükselen on 5.05.2025.
//

import Foundation
import CoreData

class IncomeViewModel {
    
    // MARK: - Properties
    private(set) var incomes: [Income] = []
    
    /// ViewController'a haber vermek için
    var onDataUpdated: (() -> Void)?
    
    // MARK: - Methods
    
    /// CoreData'dan gelirleri çeker
    func fetchIncomes() {
        incomes = CoreDataManager.shared.fetchIncomes()
        onDataUpdated?()
    }
    
    /// Liste eleman sayısı
    func numberOfItems() -> Int {
        return incomes.count
    }
    
    /// Belirli index'teki gelir
    func income(at index: Int) -> Income {
        return incomes[index]
    }
    
    /// Yeni gelir ekler ve veriyi yeniler
    func addIncome(title: String, amount: Double, date: Date, category: String) {
        CoreDataManager.shared.saveIncome(title: title, amount: amount, date: date, category: category)
        fetchIncomes()
    }
    
    func categoryTotals() -> [String: Double] {
            var totals: [String: Double] = [:]
            for income in incomes {
                let category = income.category ?? "Diğer"
                totals[category, default: 0.0] += income.amount
            }
            return totals
        }
    
    func totalAmount() -> Double {
        return incomes.reduce(0) { $0 + $1.amount }
    }

    
}
