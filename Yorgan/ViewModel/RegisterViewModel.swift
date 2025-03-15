//
//  RegisterViewModel.swift
//  Yorgan
//
//  Created by Berat Yükselen on 14.03.2025.
//

import Foundation

class RegisterViewModel {
    
    private let pages: [RegisterPage] = [
        RegisterPage(register: "KAYIT", name: "AD", surname: "SOYAD")
        
    ]
    
    var pageCount: Int{
        return pages.count
    }
    
    func getPage(at index: Int) -> RegisterPage {
        return pages[index]
    }
    
}
