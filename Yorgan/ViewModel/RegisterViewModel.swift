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
        RegisterPage(title: "KAYIT", email: "E-MAIL", emailPlaceholder: "E-Mail adresinizi giriniz...", info: "E-Mail adresinizi sadece güvenlik ve doğrulama amaçlı istiyoruz.")
        
    ]
    
    var pageCount: Int{
        return pages.count
    }
    
    func getPage(at index: Int) -> RegisterPage {
        return pages[index]
    }
    
}



