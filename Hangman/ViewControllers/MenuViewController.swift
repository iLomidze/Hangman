//
//  MenuViewController.swift
//  Hangman
//
//  Created by ilomidze on 26.04.21.
//

import UIKit

class MenuViewController: UIViewController {

    @IBOutlet weak var onePlayerButton: UIButton!
    @IBOutlet weak var twoPlayerButton: UIButton!
    @IBOutlet weak var settingButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        onePlayerButton.layer.borderWidth = 2
        onePlayerButton.layer.borderColor = UIColor.gray.cgColor
        
        twoPlayerButton.layer.borderWidth = 2
        twoPlayerButton.layer.borderColor = UIColor.gray.cgColor
        
        settingButton.layer.borderWidth = 2
        settingButton.layer.borderColor = UIColor.gray.cgColor
    }
    
    
    @IBAction func onePlayer(_ sender: Any) {
//        let vc = storyboard?.instantiateViewController(identifier: "OnePlayer")
        guard let vc = storyboard?.instantiateViewController(identifier: "OnePlayer") else { return }
        navigationController?.pushViewController(vc, animated: true)
//        self.present(vc, animated: true, completion: nil)
    }
    
    @IBAction func twoPlayers(_ sender: Any) {
        guard let vc = storyboard?.instantiateViewController(identifier: "TwoPlayersInitViewController") else { return }
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func settingsAction(_ sender: Any) {
        print("Settings button is pressed")
    }
}
