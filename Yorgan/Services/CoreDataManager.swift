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

    func saveIncome(title: String, amount: Double, date: Date, category: String, userEmail: String) {
        let income = Income(context: context)
        income.title = title
        income.amount = amount
        income.date = date
        income.category = category
        income.userEmail = userEmail

        do {
            try context.save()
            print("✅ Gelir başarıyla kaydedildi.")
        } catch {
            print("❌ Gelir kaydedilemedi: \(error.localizedDescription)")
        }
    }

    func fetchIncomes(for userEmail: String) -> [Income] {
        let request: NSFetchRequest<Income> = Income.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "date", ascending: false)]
        request.predicate = NSPredicate(format: "userEmail == %@", userEmail)

        do {
            return try context.fetch(request)
        } catch {
            print("❌ Gelirler çekilemedi: \(error.localizedDescription)")
            return []
        }
    }
    
    func deleteIncome(_ income: Income) {
        context.delete(income)
        do {
            try context.save()
            print("🗑️ Gelir silindi.")
        } catch {
            print("❌ Gelir silinemedi: \(error.localizedDescription)")
        }
    }
    
    func saveExpense(title: String, amount: Double, date: Date, category: String, userEmail: String, isRecurring: Bool, recurrenceType: String?, nextDueDate: Date?) {
        let expense = Expense(context: context)
        expense.title = title
        expense.amount = amount
        expense.date = date
        expense.category = category
        expense.userEmail = userEmail
        expense.isRecurring = isRecurring
        expense.recurrenceType = recurrenceType
        expense.nextDueDate = nextDueDate

        do {
            try context.save()
            print("✅ Gider başarıyla kaydedildi.")
        } catch {
            print("❌ Gider kaydedilemedi: \(error.localizedDescription)")
        }
    }
    
    func isRecurringExpenseAlreadyAdded(title: String, amount: Double, date: Date, userEmail: String) -> Bool {
        let request: NSFetchRequest<Expense> = Expense.fetchRequest()
        let calendar = Calendar.current
        let startOfDay = calendar.startOfDay(for: date)
        let endOfDay = calendar.date(byAdding: .day, value: 1, to: startOfDay)!

        request.predicate = NSPredicate(format: "title == %@ AND amount == %f AND userEmail == %@ AND date >= %@ AND date < %@", title, amount, userEmail, startOfDay as NSDate, endOfDay as NSDate)

        do {
            let result = try context.fetch(request)
            return !result.isEmpty
        } catch {
            print("❌ Kontrol fetch hatası: \(error)")
            return false
        }
    }
    
    func fetchExpenses(for userEmail: String) -> [Expense] {
        let request: NSFetchRequest<Expense> = Expense.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "date", ascending: false)]
        request.predicate = NSPredicate(format: "userEmail == %@", userEmail)

        do {
            return try context.fetch(request)
        } catch {
            print("❌ Giderler çekilemedi: \(error.localizedDescription)")
            return []
        }
    }
    
    func deleteExpense(_ expense: Expense) {
        context.delete(expense)
        do {
            try context.save()
            print("🗑️ Gider silindi.")
        } catch {
            print("❌ Gider silinemedi: \(error.localizedDescription)")
        }
    }
    
    func saveContext() {
        if context.hasChanges {
            do {
                try context.save()
                print("💾 Değişiklikler kaydedildi.")
            } catch {
                print("❌ Context kaydedilemedi: \(error.localizedDescription)")
            }
        }
    }
}

