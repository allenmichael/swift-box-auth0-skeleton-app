//
//  ProfileController.swift
//  BoxPlatformSample
//
//  Created by Allen-Michael Grobelny on 1/9/17.
//  Copyright © 2017 Allen-Michael Grobelny. All rights reserved.
//

import UIKit
import Lock
import BoxContentSDK

class ProfileViewController : UIViewController {
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var welcomeLabel: UILabel!
    @IBOutlet weak var boxIdLabel: UILabel!
    @IBOutlet weak var boxAccessToken: UILabel!
    @IBOutlet weak var folderName: UILabel!
    
    var profile: A0UserProfile!
    var token: A0Token!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("Token")
        print(self.token.idToken)
        let boxClient = BOXContentClient.forNewSession()
        boxClient?.accessTokenDelegate = self
        boxClient?.authenticate { (user, error) in
            if(error != nil) {
                print(error!)
                return
            }
            print("App User:")
            print(user!.name)
        }
        
        let folderRequest = boxClient?.folderInfoRequest(withID: "0")
        folderRequest?.perform(completion: { (folder, error) in
            self.folderName.text = self.folderName.text! + " \(folder!.name!)"
        })
        
        self.welcomeLabel.text = "Welcome, \(self.profile.name)"
        let boxId = (self.profile.extraInfo["box_appuser_id"] != nil) ? self.profile.extraInfo["box_appuser_id"]! : "None"
        self.boxIdLabel.text = self.boxIdLabel.text! + " \(boxId)"
        
        URLSession.shared.dataTask(with: self.profile.picture, completionHandler: { data, response, error in
            DispatchQueue.main.async {
                guard let data = data , error == nil else { return }
                self.avatarImageView.image = UIImage(data: data)
            }
        }).resume()
        
    }
}

extension ProfileViewController : BOXAPIAccessTokenDelegate {
    func fetchAccessToken(completion: ((String?, Date?, Error?) -> Void)!) {
        BoxAccessTokenDelegate.retrieveBoxAccessToken(auth0IdentityToken: self.token.idToken) { (token, expire, error) in
            completion(token, expire, nil)
        }
    }
}
