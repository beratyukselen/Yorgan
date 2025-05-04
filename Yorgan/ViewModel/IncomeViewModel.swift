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
}
