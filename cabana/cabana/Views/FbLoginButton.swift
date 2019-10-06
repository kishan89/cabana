//
//  FbLoginButton.swift
//  cabana
//
//  Created by Kishan on 10/2/19.
//  Copyright © 2019 Kishan. All rights reserved.
//

import SwiftUI

struct LoginButton_Preview: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct LoginButton: UIViewRepresentable {
    func updateUIView(_ uiView: FBLoginButton, context: UIViewRepresentableContext<LoginButton>) {}
    func makeUIView(context: Context) -> FBLoginButton {
        let loginButton = FBLoginButton()
        loginButton.delegate = FbLoginViewController().makeCoordinator()
        return loginButton
    }
}

struct FbLoginViewController: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> UIViewController {
        let vc = UIViewController()
        return vc
    }

    func updateUIViewController(_ uiViewController: UIViewController, context: Context) { }
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, LoginButtonDelegate {
        var parent: FbLoginViewController
        init(_ uiViewController: FbLoginViewController) {
            self.parent = uiViewController
        }
        func loginButton(_ loginButton: FBLoginButton, didCompleteWith result: LoginManagerLoginResult?, error: Error?) {
            if let error = error {
              print(error.localizedDescription)
              return
            }
            print("did log in")
        }
        
        func loginButtonDidLogOut(_ loginButton: FBLoginButton) {
            print("did log out")
        }
        func loginButtonWillLogin(_ loginButton: FBLoginButton) -> Bool {
            print("will log in")
            return true
        }
    }
}

/*
struct PageViewController: UIViewControllerRepresentable {
    var controllers: [UIViewController]

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    func makeUIViewController(context: Context) -> UIPageViewController {
        let pageViewController = UIPageViewController(
            transitionStyle: .scroll,
            navigationOrientation: .horizontal)

        return pageViewController
    }

    func updateUIViewController(_ pageViewController: UIPageViewController, context: Context) {
        pageViewController.setViewControllers(
            [controllers[0]], direction: .forward, animated: true)
    }

    class Coordinator: NSObject, UIPageViewControllerDataSource {
        var parent: PageViewController

        init(_ pageViewController: PageViewController) {
            self.parent = pageViewController
        }

        func pageViewController(
            _ pageViewController: UIPageViewController,
            viewControllerBefore viewController: UIViewController) -> UIViewController?
        {
            guard let index = parent.controllers.firstIndex(of: viewController) else {
                return nil
            }
            if index == 0 {
                return parent.controllers.last
            }
            return parent.controllers[index - 1]
        }

        func pageViewController(
            _ pageViewController: UIPageViewController,
            viewControllerAfter viewController: UIViewController) -> UIViewController?
        {
            guard let index = parent.controllers.firstIndex(of: viewController) else {
                return nil
            }
            if index + 1 == parent.controllers.count {
                return parent.controllers.first
            }
            return parent.controllers[index + 1]
        }
    }
}
*/
