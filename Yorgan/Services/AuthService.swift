//  AuthService.swift
//  Yorgan
//
//  Created by Berat Yükselsen on 8.04.2025.

import Foundation
import FirebaseFunctions
import FirebaseFirestore

class AuthService {

    static let shared = AuthService()
    private init() {}

    private lazy var functions = Functions.functions()
    private let db = Firestore.firestore()

    func sendEmailVerificationCode(email: String, completion: @escaping (Result<Void, Error>) -> Void) {
        let data = ["email": email]
        print("Kod gönderme çağrıldı! ->", data)

        functions.httpsCallable("sendVerificationCode").call(data) { result, error in
            if let error = error {
                print("HATA:", error.localizedDescription)
                completion(.failure(error))
                return
            }
            print("Kod başarıyla gönderildi!")
            completion(.success(()))
        }
    }

    func verifyCode(email: String, code: String, completion: @escaping (Result<Void, Error>) -> Void) {
        let data = ["email": email, "code": code]
        functions.httpsCallable("verifyCode").call(data) { result, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            completion(.success(()))
        }
    }

    func registerNewUser(name: String, surname: String, email: String, completion: @escaping (Bool) -> Void) {
        let userData: [String: Any] = [
            "name": name,
            "surname": surname,
            "email": email
        ]

        db.collection("users").document(email).setData(userData) { error in
            if let error = error {
                print("Firestore'a kayıt hatası: \(error.localizedDescription)")
                completion(false)
            } else {
                print("Firestore'a başarıyla kaydedildi")
                completion(true)
            }
        }
    }
}

