//
//  SceneDelegate.swift
//  Yorgan
//
//  Created by Berat Yükselen on 10.03.2025.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Bu satır, Scene'i uygun şekilde başlatmak için gereklidir
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        // Yeni bir UIWindow nesnesi oluşturuyoruz ve windowScene ile ilişkilendiriyoruz
        window = UIWindow(windowScene: windowScene)
        
        // IntroViewController'ı başlatıyoruz
        let onboardingVC = OnboardingViewController()
        //let mainVC = MainTabBarController()
        
        
        // IntroViewController'ı bir navigation controller ile sarmalıyoruz
        let navigationController = UINavigationController(rootViewController: onboardingVC)
        //let navigationController = UINavigationController(rootViewController: mainVC)
        
        // rootViewController olarak navigation controller'ı belirliyoruz
        window?.rootViewController = navigationController
        
        // Pencereyi görünür yapıyoruz
        window?.makeKeyAndVisible()
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Scene bağlantısı kesildiğinde yapılacak işlemler
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Uygulama aktif olduğunda yapılacak işlemler
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Uygulama pasif hale geldiğinde yapılacak işlemler
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Uygulama arka plandan ön plana geçerken yapılacak işlemler
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Uygulama arka planda olduğunda yapılacak işlemler
    }
}



