//
//  CoreDataManager.swift
//  Yorgan
//
//  Created by Berat Yükselen on 1.05.2025.
//

import UIKit
import CoreData

class CoreDataManager {
    
    static let shared = CoreDataManager()
    
    let context: NSManagedObjectContext
    
    private init() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            fatalError("AppDelegate erişilemedi.")
        }
        self.context = appDelegate.persistentContainer.viewContext
    }

    func saveIncome(title: String, amount: Double, date: Date, category: String) {
        let income = Income(context: context)
        income.title = title
        income.amount = amount
        income.date = date
        income.category = category
        
        do {
            try context.save()
            print("✅ Gelir başarıyla kaydedildi.")
        } catch {
            print("❌ Gelir kaydedilemedi: \(error.localizedDescription)")
        }
    }

    func fetchIncomes() -> [Income] {
        let request: NSFetchRequest<Income> = Income.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "date", ascending: false)]
        
        do {
            return try context.fetch(request)
        } catch {
            print("❌ Gelirler çekilemedi: \(error.localizedDescription)")
            return []
        }
    }
    
    func saveExpense(title: String, amount: Double, date: Date,category: String ) {
        let expense = Expense(context: context)
        expense.title = title
        expense.amount = amount
        expense.date = date
        expense.category = category
        
        do {
            try context.save()
            print("✅ Gider başarıyla kaydedildi.")
        } catch {
            print("❌ Gider kaydedilemedi: \(error.localizedDescription)")
        }
    }
    
    func fetchExpenses() -> [Expense] {
        let request: NSFetchRequest<Expense> = Expense.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "date", ascending: false)]
        
        do {
            return try context.fetch(request)
        } catch {
            print(" Giderler çekilemedi: \(error.localizedDescription)")
            return []
        }
    }
    
    
}
