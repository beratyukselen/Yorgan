//
//  RegisterViewModel.swift
//  Yorgan
//
//  Created by Berat Yükselen on 14.03.2025.
//

import Foundation

class RegisterViewModel {
    
    private let pages: [RegisterPage] = [
        RegisterPage(title: "KAYIT", name: "AD", namePlaceholder: "Adınızı giriniz...", surname: "SOYAD", surnamePlaceholder: "Soyadınızı giriniz..."),
        RegisterPage(title: "KAYIT", phone: "TELEFON NUMARASI", phonePlaceholder: "Telefon numaranızı giriniz...", country: "+90", info: "Telefon numaranızı sadece güvenlik ve doğrulama amaçlı istiyoruz.")
        
    ]
    
    var pageCount: Int{
        return pages.count
    }
    
    func getPage(at index: Int) -> RegisterPage {
        return pages[index]
    }
    
}
