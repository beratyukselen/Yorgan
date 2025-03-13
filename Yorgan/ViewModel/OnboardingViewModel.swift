//
//  OnboardingViewModel.swift
//  Yorgan
//
//  Created by Berat Yükselen on 12.03.2025.
//

import Foundation

class OnboardingViewModel {
    
    private let pages: [OnboardingPage] = [
        OnboardingPage(onboarding: "Bütçe Takibi",image: "onboarding1", title: "Hoş Geldiniz!", description: "Uygulamamıza hoş geldiniz, özelliklerimizi keşfedin."),
        OnboardingPage(onboarding: "Kolay Kullanım",image: "onboarding2", title: "Kolay Kullanım", description: "Arayüzümüz basit ve sezgiseldir."),
        OnboardingPage(onboarding: "Güvenlik",image: "onboarding3", title: "Başlayalım!", description: "Uygulamayı hemen kullanmaya başlayın.")
    ]
    
    var pageCount: Int {
        return pages.count
    }
    
    func getPage(at index: Int) -> OnboardingPage {
        return pages[index]
    }
}


