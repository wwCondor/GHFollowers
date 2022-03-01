//
//  UIViewController+Ext.swift
//  GHFollowers
//
//  Created by Wouter Willebrands on 12/02/2020.
//  Copyright © 2020 CodingCondor. All rights reserved.
//

import UIKit
import SafariServices

extension UIViewController {
    func presentAlert(title: String, message: String, buttonTitle: String) {
        DispatchQueue.main.async {
            let alertViewController = AlertViewController(title: title, message: message, buttonTitle: buttonTitle)
            alertViewController.modalPresentationStyle = .overFullScreen
            alertViewController.modalTransitionStyle = .crossDissolve
            self.present(alertViewController, animated: true)
        }
    }
    
    func presentAddedUserToFavouritesAlert(title: String, message: String, buttonTitle: String, user: String) {
        DispatchQueue.main.async {
            let alertViewController = AlertViewController(title: title, message: message, buttonTitle: buttonTitle)
            alertViewController.modalPresentationStyle = .overFullScreen
            alertViewController.modalTransitionStyle = .crossDissolve
            self.present(alertViewController, animated: true)
        }
    }
    
    func presentSafariViewController(with url: URL) {
        let safariViewController = SFSafariViewController(url: url)
        safariViewController.preferredControlTintColor = .systemPink
        present(safariViewController, animated: true)
    }
    
    /// Adds swipe down and tap gesture recognizer to view.
    func addDismissKeyboardGestureRecognizers() {
        let swipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        swipeGestureRecognizer.direction = .down
        view.addGestureRecognizer(swipeGestureRecognizer)
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tapGestureRecognizer.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGestureRecognizer)
    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
    
    /// Show activity indicator on the main queue with a viewTag.
    func showActivityIndicator() {
        DispatchQueue.main.async {
            let containerView = UIView()
            containerView.frame = self.view.frame
            containerView.backgroundColor = .clear
            containerView.alpha = 0
            containerView.tag = Tag.activityIndicator.rawValue
            self.view.addSubview(containerView)

            UIView.animate(withDuration: 0.5) { containerView.alpha = 1.0 }

            let activityIndicator = UIActivityIndicatorView()
            activityIndicator.translatesAutoresizingMaskIntoConstraints = false
            activityIndicator.hidesWhenStopped = true
            activityIndicator.style = .large
            activityIndicator.color = UIColor.systemPink

            containerView.addSubview(activityIndicator)

            NSLayoutConstraint.activate([
                activityIndicator.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),
                activityIndicator.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            ])

            activityIndicator.startAnimating()
        }
    }

    /// Dismiss activity indicator on main thread using viewTag.
    func dismissActivityIndicator() {
        DispatchQueue.main.async {
            if let containerView = self.view.viewWithTag(Tag.activityIndicator.rawValue) {
                containerView.removeFromSuperview()
            }
        }
    }
    
    /// Show empty state view on main thread.
    func showEmptyStateView(with message: String) {
        DispatchQueue.main.async {
            let emptyStateView = GFEmptyStateView(message: message)
            emptyStateView.tag = Tag.emptyStateView.rawValue
            emptyStateView.frame = self.view.bounds
            self.view.addSubview(emptyStateView)
        }
    }
    
    /// Dismiss empty state view on main thread using view tag.
    func dismissEmptyStatView() {
        DispatchQueue.main.async {
            if let containerView = self.view.viewWithTag(Tag.emptyStateView.rawValue) {
                containerView.removeFromSuperview()
            }
        }
    }
}
