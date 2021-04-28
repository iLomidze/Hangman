//
//  TwoPlayersWordsViewController.swift
//  Hangman
//
//  Created by ilomidze on 26.04.21.
//

import UIKit

class TwoPlayersWordsViewController: UIViewController {

    @IBOutlet var button: UIButton!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var scoreLabel: UILabel!
    
    var dataTwoPlayers: DataTwoPlayers?
    
    var playerNumber = 1
    var word = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        view.addGestureRecognizer(tapGesture)
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .stop, target: self, action: #selector(goHome))
        
        if playerNumber == 1 {
            button.setTitle("Next", for: .normal)
        } else {
            button.setTitle("Start", for: .normal)
        }
        
        scoreLabel.text = "Score: \(dataTwoPlayers?.player1Point ?? 0) - \(dataTwoPlayers?.player2Point ?? 0)"
        
    }
    
    
    
    func setData(playersData: DataTwoPlayers) {
        dataTwoPlayers = playersData
    }
    
    func startwoPlayersVC() {
        guard let vc  = storyboard?.instantiateViewController(identifier: "OnePlayer") as? ViewController else { return }
        vc.onePlayer = false
        vc.dataTwoPlayers = dataTwoPlayers
        vc.playerNumb = 1
        
        navigationController?.pushViewController(vc, animated: true)
    }
    
    
    @objc func hideKeyboard() {
        view.endEditing(true)
    }
    
    @objc func goHome() {
        guard let vc = storyboard?.instantiateViewController(identifier: "MenuViewController") as? MenuViewController else { return }
        navigationController?.pushViewController(vc, animated: true)
    }
    
    
    
    @IBAction func buttonAction(_ sender: Any) {
        guard let word = textField.text else { return }
        if word.isEmpty {
            let ac = UIAlertController(title: "No Word", message: "Please add word in the textfield", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(ac, animated: true, completion: nil)
            return
        }
        if playerNumber == 1 {
            dataTwoPlayers?.player2Word = word
            guard let vc = storyboard?.instantiateViewController(identifier: "TwoPlayersWordsViewController") as? TwoPlayersWordsViewController else { return }
            vc.title = dataTwoPlayers?.player2Name
            vc.playerNumber = 2
            vc.dataTwoPlayers = dataTwoPlayers
            navigationController?.pushViewController(vc, animated: true)
        }
        else {
            dataTwoPlayers?.player1Word = word
            
            startwoPlayersVC()
        }
    }
    
}


extension TwoPlayersWordsViewController: UITextFieldDelegate {
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        
        return true
    }
    
}
