//
//  TwoPlayersInitViewController.swift
//  Hangman
//
//  Created by ilomidze on 26.04.21.
//

import UIKit

class TwoPlayersInitViewController: UIViewController {

    @IBOutlet weak var player1TextView: UITextField!
    @IBOutlet weak var player2TextField: UITextField!
    
    var dataTwoPlayers: DataTwoPlayers?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        view.addGestureRecognizer(tapGesture)
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .stop, target: self, action: #selector(goHome))
        
        dataTwoPlayers = DataTwoPlayers()
    }
    
    @IBAction func nextButtonAction(_ sender: Any) {

        guard let vc = storyboard?.instantiateViewController(identifier: "TwoPlayersWordsViewController") as? TwoPlayersWordsViewController else { return }
        
        vc.setData(playersData: dataTwoPlayers ?? DataTwoPlayers())
        vc.title = dataTwoPlayers?.player1Name
        vc.playerNumber = 1
        navigationController?.pushViewController(vc, animated: true)
    }
    
}

extension TwoPlayersInitViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == player1TextView {
            dataTwoPlayers?.player1Name = (textField.text ?? "Player 1")
        } else {
            dataTwoPlayers?.player2Name = (textField.text ?? "Player 2")
        }
        textField.resignFirstResponder()
        return true
    }
    
    // Is used to display push view content up when keyboard is displayed
    @objc func keyboardWillShow(notification: NSNotification) {
        if player1TextView.isFirstResponder {
            return
        }
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0 {
                self.view.frame.origin.y -= keyboardSize.height
            }
        }
    }
    
    // Is used to release nad pull down view content when keyboard is hidden
    @objc func keyboardWillHide(notification: NSNotification) {
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
    }
    
    @objc func hideKeyboard() {
        view.endEditing(true)
    }
    
    @objc func goHome() {
        guard let vc = storyboard?.instantiateViewController(identifier: "MenuViewController") as? MenuViewController else { return }
        navigationController?.pushViewController(vc, animated: true)
    }
    
}
