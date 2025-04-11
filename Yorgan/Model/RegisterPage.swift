//
//  RegisterPage.swift
//  Yorgan
//
//  Created by Berat Yükselen on 14.03.2025.
//

import Foundation

struct RegisterPage {
    let title: String?
    let name: String?
    let namePlaceholder: String?
    let surname: String?
    let surnamePlaceholder: String?
    let email: String?
    let emailPlaceholder: String?
    let info: String?
    
    init(title: String? = nil,
         name: String? = nil, namePlaceholder: String? = nil,
         surname: String? = nil, surnamePlaceholder: String? = nil,
         email: String? = nil, emailPlaceholder: String? = nil,
         info: String? = nil){
    
        self.title = title
        self.name = name
        self.namePlaceholder = namePlaceholder
        self.surname = surname
        self.surnamePlaceholder = surnamePlaceholder
        self.email = email
        self.emailPlaceholder = emailPlaceholder
        self.info = info
    }
}





