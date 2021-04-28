//
//  ViewController.swift
//  Hangman
//
//  Created by ilomidze on 25.04.21.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var correctWordLabel: UILabel!
    @IBOutlet weak var inputLetterTextField: UITextField!
    @IBOutlet weak var usedLettersLabel: UILabel!
    
    var scoreLabel: UILabel!
    
    var usedletters = [String]()
    var possibleWords = [String]()
    var correctWord = ""
    
    var mistakes = 0 {
        didSet {
            if mistakes == maxMistake {
                if onePlayer {
                    gameLost()
                } else {
                    nextPlayer()
                }
                
            }
            imageView.image = UIImage(named: "\(mistakes).png")
        }
    }
    var maxMistake = 7
    
    var onePlayer = true
    var dataTwoPlayers: DataTwoPlayers?
    var playerNumb = 1
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        inputLetterTextField.delegate = self
        inputLetterTextField.returnKeyType = .done
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        view.addGestureRecognizer(tapGesture)
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .stop, target: self, action: #selector(goHome))
        
        if onePlayer {
            initGame()
        }
        
        twoPlayersInit()
    }
    

    func initGame() {
        title = "1 Player"
        getWords(fileName: "words", fileExtension: "txt")
        generateCorrectWord()
        initCorrectWordLabel()
        usedLettersLabel.text = "Used Letters:\n"
    }
    
    func newGame(action: UIAlertAction) {
        mistakes = 0
        generateCorrectWord()
        initCorrectWordLabel()
        usedLettersLabel.text = "Used Letters:\n"
        usedletters = []
    }
    
    func initCorrectWordLabel() {
        correctWordLabel.text? = ""
        for _ in correctWord.enumerated() {
            correctWordLabel.text?.append("?")
        }
    }
    
    func generateCorrectWord() {
        correctWord = possibleWords.randomElement() ?? "SPOON"
        print("correct word - \(correctWord)")
    }
    
    func getWords(fileName: String, fileExtension: String) {
        if let url = Bundle.main.url(forResource: fileName, withExtension: fileExtension) {
            let fileDataOpt = try? String(contentsOf: url)
            guard let fileData = fileDataOpt else { return }
            
            possibleWords += fileData.components(separatedBy: "\n")
        }
    }
    
    func stringChangeCharAt(on str: String, replace oldtxt: String, with txt: String) -> String? {
        var finalStr: String?
        
        if let range = str.range(of: oldtxt) {
            finalStr = str.replacingCharacters(in: range, with: txt)
        }

        return finalStr
    }
    
    func twoPlayersInit() {
        if !onePlayer {
            navigationItem.hidesBackButton = true
            addScoreLabel()
            scoreLabel.text = "Score: \(dataTwoPlayers?.player1Point ?? 0) - \(dataTwoPlayers?.player2Point ?? 0)"
            if playerNumb == 1 {
                title = dataTwoPlayers?.player1Name
                correctWord = dataTwoPlayers?.player1Word ?? "Spoon"
            } else {
                title = dataTwoPlayers?.player2Name
                correctWord = dataTwoPlayers?.player2Word ?? "Spoon"
            }
            initCorrectWordLabel()
            usedLettersLabel.text = "Used Letters:\n"
        }
    }
    
    func addScoreLabel() {
        scoreLabel = UILabel()
        scoreLabel.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(scoreLabel)
        
        scoreLabel.widthAnchor.constraint(equalToConstant: 100).isActive = true
        scoreLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        scoreLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20).isActive = true
        scoreLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10).isActive = true
        
        scoreLabel.text = "Score: \(dataTwoPlayers?.player1Point ?? 0) - \(dataTwoPlayers?.player2Point ?? 0)"
    }
    
    @objc func goHome() {
        guard let vc = storyboard?.instantiateViewController(identifier: "MenuViewController") as? MenuViewController else { return }
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension ViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        var enteredWord = inputLetterTextField.text ?? ""
        enteredWord = enteredWord.lowercased()
        
        if enteredWord.count != 1 || !Character(enteredWord).isLetter {
            wrongInputHandler()
            
            return true
        }
        
        if !usedletters.contains(enteredWord){
            usedletters.append(enteredWord)
            usedLettersLabel.text = "\(usedLettersLabel.text ?? "") \(enteredWord);"
        } else {
            wrongInputHandler()
            return true
        }
        
        if correctWord.contains(enteredWord){

            let correctWordChArr = Array(correctWord)
            var corWordLabelChArr = Array( (correctWordLabel.text) ?? "" )
            
            for (ind, ch) in correctWordChArr.enumerated() {
                if ch == Character(enteredWord) {
                    corWordLabelChArr[ind] = ch
                }
            }
            
            correctWordLabel.text = String(corWordLabelChArr)
            
            inputLetterTextField.text = ""
            textField.resignFirstResponder()
            
            if correctWordLabel.text == correctWord {
                if onePlayer {
                    gameWon()
                } else {
                    nextPlayer()
                    if playerNumb == 1 {
                        dataTwoPlayers?.player1Point += 1
                    } else {
                        dataTwoPlayers?.player2Point += 1
                    }

                }
                
            }
        } else {
            textField.resignFirstResponder()
            mistakes += 1
            incorrectInputHandler()
        }
        
        return true
    }
    
    // Used From TapGestureRecognizer
    @objc func hideKeyboard() {
        view.endEditing(true)
    }
    
    func gameWon() {
        let ac = UIAlertController(title: "You Won", message: "Try Another word?", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Yes", style: .cancel, handler: newGame))
        ac.addAction(UIAlertAction(title: "No", style: .default, handler: nil))
        present(ac, animated: true, completion: nil)
    }
    
    func gameLost() {
        let ac = UIAlertController(title: "You Lost", message: "Try Another word?", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Yes", style: .default, handler: newGame))
        ac.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))
        present(ac, animated: true, completion: nil)
    }
    
    func wrongInputHandler() {
        inputLetterTextField.backgroundColor = .red
        inputLetterTextField.isUserInteractionEnabled = false
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
            self?.inputLetterTextField.backgroundColor = .white
            self?.inputLetterTextField.isUserInteractionEnabled = true
            self?.inputLetterTextField.text = ""
        }
    }
    
    func incorrectInputHandler() {
        inputLetterTextField.textColor = .red
        inputLetterTextField.isUserInteractionEnabled = false
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
            self?.inputLetterTextField.textColor = .black
            self?.inputLetterTextField.isUserInteractionEnabled = true
            self?.inputLetterTextField.text = ""
        }
    }
    
    func nextPlayer() {
        navigationItem.hidesBackButton = false
        if playerNumb == 1 {
            guard let vc  = storyboard?.instantiateViewController(identifier: "OnePlayer") as? ViewController else { return }
            vc.onePlayer = false
            vc.dataTwoPlayers = dataTwoPlayers
            vc.playerNumb = 2
            navigationController?.pushViewController(vc, animated: true)
        } else {
            guard let vc  = storyboard?.instantiateViewController(identifier: "TwoPlayersWordsViewController") as? TwoPlayersWordsViewController else { return }
            
            vc.playerNumber = 1
            vc.dataTwoPlayers = dataTwoPlayers
            vc.title = dataTwoPlayers?.player1Name
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
}

