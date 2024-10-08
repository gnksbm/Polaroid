//
//  UIViewController+.swift
//  Polaroid
//
//  Created by gnksbm on 7/22/24.
//

import UIKit

extension UIViewController {
    var safeArea: UILayoutGuide {
        view.safeAreaLayoutGuide
    }
    
    static func getCurrentRootVC() -> UIViewController {
        @UserDefaultsWrapper(key: .user, defaultValue: nil)
        var user: User?
        return user != nil ?
        MainTabBarController() : UINavigationController(
            rootViewController: OnboardingViewController()
        )
    }
    
    func showAlert(
        title: String,
        actionTitle: String,
        _ handler: @escaping (UIAlertAction) -> Void
    ) {
        let alertController = UIAlertController(
            title: title,
            message: nil,
            preferredStyle: .alert
        )
        let okAction = UIAlertAction(
            title: actionTitle,
            style: .destructive,
            handler: handler
        )
        let cancelAction = UIAlertAction(title: "취소", style: .cancel)
        alertController.addAction(okAction)
        alertController.addAction(cancelAction)
        present(alertController, animated: true)
    }
    
    
    func hideKeaboardOnTap() {
        let tapGesture = UITapGestureRecognizer(
            target: self,
            action: #selector(hideKeyboard)
        )
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc private func hideKeyboard() {
        view.endEditing(true)
    }
    
}

extension UIViewController {
    private enum OverlayHelper {
        static var isToastShowing = false
        static var activityView: UIActivityIndicatorView?
        static var progressView: UIProgressView?
    }
    
    func showToast(message: String, duration: Double = 2) {
        guard !OverlayHelper.isToastShowing else { return }
        OverlayHelper.isToastShowing = true
        
        let toastView = ToastView().nt.configure {
            $0.perform { $0.updateMessage(message) }
        }
        
        view.addSubview(toastView)
        toastView.translatesAutoresizingMaskIntoConstraints = false
        
        let toastTopConstraint =
        toastView.bottomAnchor.constraint(equalTo: safeArea.topAnchor)
        
        NSLayoutConstraint.activate([
            toastView.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor),
            toastTopConstraint
        ])
        view.layoutIfNeeded()
        
        UIView.animate(
            withDuration: 0.3,
            delay: 0,
            options: [.curveEaseOut],
            animations: {
                toastTopConstraint.constant = toastView.bounds.height + 10
                toastView.alpha = 1
                self.view.layoutIfNeeded()
            },
            completion: { _ in
                UIView.animate(
                    withDuration: 0.3,
                    delay: duration,
                    options: [.curveEaseIn],
                    animations: {
                        toastTopConstraint.constant = 0
                        toastView.alpha = 0
                        self.view.layoutIfNeeded()
                    },
                    completion: { _ in
                        toastView.removeFromSuperview()
                        OverlayHelper.isToastShowing = false
                    }
                )
            }
        )
    }
    
    func showActivityIndicator() {
        guard OverlayHelper.activityView == nil else { return }
        let activityView = UIActivityIndicatorView().nt.configure {
            $0.color(.tintColor)
                .translatesAutoresizingMaskIntoConstraints(false)
                .startAnimating()
        }
        OverlayHelper.activityView = activityView
        view.addSubview(activityView)
        
        NSLayoutConstraint.activate([
            activityView.centerXAnchor.constraint(
                equalTo: safeArea.centerXAnchor
            ),
            activityView.centerYAnchor.constraint(
                equalTo: safeArea.centerYAnchor
            ),
        ])
        view.layoutIfNeeded()
    }
    
    func hideActivityIndicator() {
        OverlayHelper.activityView?.removeFromSuperview()
    }
    
    func showProgressView() {
        guard OverlayHelper.progressView == nil else { return }
        let progressView = UIProgressView().nt.configure {
            $0.trackTintColor(.separator)
                .progressTintColor(.red)
        }
        
        OverlayHelper.progressView = progressView
        view.addSubview(progressView)
        progressView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            progressView.topAnchor.constraint(equalTo: safeArea.topAnchor),
            progressView.leadingAnchor.constraint(
                equalTo: safeArea.leadingAnchor
            ),
            progressView.trailingAnchor.constraint(
                equalTo: safeArea.trailingAnchor
            ),
            progressView.heightAnchor.constraint(
                equalToConstant: 5
            ),
        ])
        
        view.layoutIfNeeded()
    }
    
    func updateProgress(progress: Double) {
        OverlayHelper.progressView?.progress = Float(progress)
        view.layoutIfNeeded()
    }
    
    func appendProgress(progress: Double) {
        OverlayHelper.progressView?.progress =
        (OverlayHelper.progressView?.progress ?? 0) + Float(progress)
        view.layoutIfNeeded()
    }
    
    func hideProgressView() {
        UIView.animate(
            withDuration: 1,
            delay: 0,
            options: [.curveEaseIn],
            animations: {
                OverlayHelper.progressView?.progress = 1
                self.view.layoutIfNeeded()
            },
            completion: { _ in
                OverlayHelper.progressView?.removeFromSuperview()
                OverlayHelper.progressView = nil
            }
        )
    }
}
