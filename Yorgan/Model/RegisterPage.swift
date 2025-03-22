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
    let phone: String?
    let phonePlaceholder: String?
    let country: String?
    let info: String?
    
    init(title: String? = nil,
         name: String? = nil, namePlaceholder: String? = nil,
         surname: String? = nil, surnamePlaceholder: String? = nil,
         phone: String? = nil, phonePlaceholder: String? = nil,
         country: String? = nil, info: String? = nil){
    
        self.title = title
        self.name = name
        self.namePlaceholder = namePlaceholder
        self.surname = surname
        self.surnamePlaceholder = surnamePlaceholder
        self.phone = phone
        self.phonePlaceholder = phonePlaceholder
        self.country = country
        self.info = info
    }
}



