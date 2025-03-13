//
//  IntroViewModel.swift
//  Yorgan
//
//  Created by Berat Yükselen on 12.03.2025.
//

import Foundation

class IntroViewModel {
    private(set) var pages: [IntroPage] = [
        IntroPage(image: "onboarding1", title: "Hoş Geldiniz!", description: "Uygulamamıza hoş geldiniz, özelliklerimizi keşfedin."),
        IntroPage(image: "onboarding2", title: "Kolay Kullanım", description: "Arayüzümüz basit ve sezgiseldir."),
        IntroPage(image: "onboarding3", title: "Başlayalım!", description: "Uygulamayı hemen kullanmaya başlayın.")
    ]
    
    var currentPage = 0
    
    func nextPage() {
        if currentPage < pages.count - 1 {
            currentPage += 1
        }
    }
    
    func skipOnboarding() {
        UserDefaults.standard.set(true, forKey: "hasSeenOnboarding")
    }
}
