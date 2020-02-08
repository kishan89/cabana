//
//  MatchmakerView.swift
//  cabana
//
//  Created by Kishan on 2/1/20.
//  Copyright © 2020 Kishan. All rights reserved.
//

import SwiftUI
import UIKit
import GameKit

struct MatchmakingView<Page: View>: View {
    @State private var showPopover: Bool = false
    var viewControllers: [UIHostingController<Page>]

    init(_ views: [Page]) {
        self.viewControllers = views.map { UIHostingController(rootView: $0) }
    }

    var body: some View {
        Button("new 2") {
            self.showPopover = true
        }.sheet(isPresented: self.$showPopover) {
            MatchmakingViewController(controllers: self.viewControllers)
//            Text("HELLO")
        }
    }
}

struct MatchmakingViewController: UIViewControllerRepresentable {
    var controllers: [UIViewController]

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    func makeUIViewController(context: Context) -> GKMatchmakerViewController {
        print("YOOOO")
        print(UIApplication.shared.windows.first?.rootViewController)
//        appDelegate.window?.rootViewController = self as! UIViewController

        let matchRequest = GKMatchRequest()
        matchRequest.maxPlayers = 8
        matchRequest.minPlayers = 4
        let gKMatchmakerViewController = GKMatchmakerViewController(matchRequest: matchRequest)
        gKMatchmakerViewController!.modalPresentationStyle = .automatic
        print("presenting view controller: \(gKMatchmakerViewController!.presentingViewController)")
        return gKMatchmakerViewController!
    }

    func updateUIViewController(_ gKMatchmakerViewController: GKMatchmakerViewController, context: Context) {
        gKMatchmakerViewController.modalPresentationStyle = .automatic
        gKMatchmakerViewController.setViewControllers([controllers[0]], animated: true)
    }

    class Coordinator: NSObject, GKMatchmakerViewControllerDelegate {
        func matchmakerViewControllerWasCancelled(_ viewController: GKMatchmakerViewController) {
            return
        }
        
        func matchmakerViewController(_ viewController: GKMatchmakerViewController, didFailWithError error: Error) {
            return
        }
        
        var parent: MatchmakingViewController
    
        init(_ pageViewController: MatchmakingViewController) {
            self.parent = pageViewController
        }

//        func pageViewController(
//            _ pageViewController: UIPageViewController,
//            viewControllerBefore viewController: UIViewController) -> UIViewController?
//        {
//            guard let index = parent.controllers.firstIndex(of: viewController) else {
//                return nil
//            }
//            if index == 0 {
//                return parent.controllers.last
//            }
//            return parent.controllers[index - 1]
//        }

//        func pageViewController(
//            _ pageViewController: UIPageViewController,
//            viewControllerAfter viewController: UIViewController) -> UIViewController?
//        {
//            guard let index = parent.controllers.firstIndex(of: viewController) else {
//                return nil
//            }
//            if index + 1 == parent.controllers.count {
//                return parent.controllers.first
//            }
//            return parent.controllers[index + 1]
//        }
    }
}
