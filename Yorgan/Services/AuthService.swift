//
//  AuthService.swift
//  Yorgan
//
//  Created by Berat Yükselsen on 8.04.2025.
//

import Foundation
import FirebaseFunctions
import FirebaseFirestore

class AuthService {

    static let shared = AuthService()
    private init() {}

    private lazy var functions = Functions.functions()
    private let db = Firestore.firestore()

    func sendEmailVerificationCode(email: String, isLogin: Bool = false, completion: @escaping (Result<Void, Error>) -> Void) {
        let cleanEmail = email.lowercased()

        if isLogin {
            let docRef = db.collection("users").document(cleanEmail)
            docRef.getDocument { snapshot, error in
                if let error = error {
                    print("Firestore kullanıcı kontrol hatası:", error.localizedDescription)
                    completion(.failure(error))
                    return
                }

                guard let document = snapshot, document.exists else {
                    let err = NSError(domain: "", code: 404, userInfo: [NSLocalizedDescriptionKey: "Bu e-mail adresiyle kayıtlı bir kullanıcı bulunamadı."])
                    completion(.failure(err))
                    return
                }

                self.sendCodeWithCloudFunction(email: cleanEmail, completion: completion)
            }
        } else {
            self.sendCodeWithCloudFunction(email: cleanEmail, completion: completion)
        }
    }

    private func sendCodeWithCloudFunction(email: String, completion: @escaping (Result<Void, Error>) -> Void) {
        let data = ["email": email.lowercased()]
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
        let cleanEmail = email.lowercased()
        let data = ["email": cleanEmail, "code": code]

        functions.httpsCallable("verifyCode").call(data) { result, error in
            if let error = error {
                print("Doğrulama kodu hatası:", error.localizedDescription)
                completion(.failure(error))
                return
            }
            print("Kod doğrulandı!")
            completion(.success(()))
        }
    }

    func registerNewUser(name: String, surname: String, email: String, completion: @escaping (Bool) -> Void) {
        let cleanEmail = email.lowercased()
        let userData: [String: Any] = [
            "name": name,
            "surname": surname,
            "email": cleanEmail
        ]

        db.collection("users").document(cleanEmail).setData(userData) { error in
            if let error = error {
                print("Firestore'a kayıt hatası:", error.localizedDescription)
                completion(false)
            } else {
                print("Firestore'a başarıyla kaydedildi")
                completion(true)
            }
        }
    }
}
