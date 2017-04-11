//
//  HomeController.swift
//  BoxPlatformSample
//
//  Created by Allen-Michael Grobelny on 1/9/17.
//  Copyright © 2017 Allen-Michael Grobelny. All rights reserved.
//


import UIKit
import Lock
import BoxContentSDK

class HomeViewController: UIViewController {
    
    @IBAction func showLoginController(_ sender: UIButton) {
        let controller = A0Lock.shared().newLockViewController()
        controller?.closable = true
        controller?.onAuthenticationBlock = { profile, token in
            guard let userProfile = profile else {
                self.showMissingProfileAlert()
                return
            }
            self.retrievedProfile = userProfile
            self.token = token
            controller?.dismiss(animated: true, completion: {
                self.performSegue(withIdentifier: "ShowProfile", sender: nil)
            })
        }
        controller?.onUserDismissBlock = {
            //The user dismisses the Login screen
        }
        A0Lock.shared().present(controller, from: self)
    }
    
    // MARK: - Segue
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let profileController = segue.destination as? ProfileViewController else {
            return
        }
        profileController.profile = self.retrievedProfile
        profileController.token = self.token
    }
    
    // MARK: - Private
    
    fileprivate var retrievedProfile: A0UserProfile!
    fileprivate var token: A0Token!
    
    fileprivate func showMissingProfileAlert() {
        let alert = UIAlertController(title: "Error", message: "Could not retrieve profile", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    
}
