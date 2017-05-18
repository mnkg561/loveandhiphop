//
//  MembershipQuizTableViewController2.swift
//  LoveAndHiphop
//
//  Created by Pari, Nithya on 5/16/17.
//  Copyright © 2017 Mogulla, Naveen. All rights reserved.
//

import UIKit
import Parse

class MembershipQuizTableViewController2: UIViewController {
    
    @IBOutlet weak var QuizQuestionLabel: UILabel!
    @IBOutlet weak var trueButton: UIButton!
    @IBOutlet weak var falseButton: UIButton!
    
    var quizDict: Dictionary<String, String> = Dictionary()
    var questions: Dictionary<Int, String> = Dictionary()
    var answers: Dictionary<Int, String> = Dictionary()
    var question: String = ""
    var selectedAnswer: String = ""
    var correctAnswer: String = ""
    let maxQuestions = 3
    var maxPossibleQuestions = 3
    var numberOfQuestionsAnsweredCorrect: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        loadQuiz()
        
        
        self.QuizQuestionLabel.text = question
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func startQuiz() {
        nextQuestion()
    }
    
    func nextQuestion(transitionText: String = "") {
        updateQuestionLabel(withText: transitionText, onCompletion: getNextQuestion())
    }
    
    func getNextQuestion() -> (() -> ()) {
        return {
            let randomNumber: Int = Int(arc4random()) % self.quizDict.values.count
            UIView.animate(withDuration: 1, animations: {
                self.question = [String] (self.quizDict.keys) [randomNumber]
                self.correctAnswer = self.quizDict.removeValue(forKey: self.question)!
                self.QuizQuestionLabel.text = self.question
            })
        }
    }
    
    func reloadQuiz() -> (() -> ()) {
        return {
            self.setInputsHidden()
            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1), execute: {
                self.loadQuiz()
            })
        }
    }
    
    func setInputsHidden() {
        self.trueButton.isHidden = true
        self.falseButton.isHidden = true
    }
    
    func updateQuestionLabel(withText: String, onCompletion: @escaping () -> ()) {
        UIView.animate(withDuration: 1, animations: {
            self.QuizQuestionLabel.text = withText
            }, completion: { (success: Bool) in
                onCompletion()
        })
    }
    
    func loadQuiz() {
        
        //var i = 0

        let query = PFQuery(className: "Quiz2")
        query.findObjectsInBackground { (quizzes: [PFObject]?, error: Error?) in
            if error != nil {
                print("Error retrieving quizes")
            } else {
                var i = 0
                for quiz in quizzes! {
                    let question = quiz["question"] as! String
                    let answer = quiz["answer"] as! String
                    self.quizDict[question] = answer
                    self.questions[i] = question
                    self.answers[i] = answer
                    i += 1
                }
                //self.maxPossibleQuestions = self.questions.count < self.maxQuestions ? self.questions.count : self.maxQuestions
                self.numberOfQuestionsAnsweredCorrect = 0
                self.startQuiz()
                self.trueButton.isHidden = false
                self.falseButton.isHidden = false
                
            }
        }
    }
    
    func validateChoice() {
        if selectedAnswer.caseInsensitiveCompare(correctAnswer) == .orderedSame {
            numberOfQuestionsAnsweredCorrect += 1
            if numberOfQuestionsAnsweredCorrect < maxQuestions {
                nextQuestion(transitionText: "Correct!")
            } else {
                updateQuestionLabel(withText: "Hooray! You have passed the quiz", onCompletion: showLogin())
            }
        } else {
            updateQuestionLabel(withText: "Sorry, you failed the quiz. Quiz will now reload", onCompletion: reloadQuiz())
        }
    }
    
    
    func showLogin() -> (() -> ()) {
        return {
            self.setInputsHidden()
            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1), execute: {
                let resultsVC = self.storyboard?.instantiateViewController(withIdentifier: "QuizResultsViewController") as! QuizResultsViewController
            
                let passQuizViewNib = UINib(nibName: "PassQuizView", bundle: nil)
                let passQuizView = passQuizViewNib.instantiate(withOwner: resultsVC, options: nil)[0] as! UIView
                resultsVC.view.addSubview(passQuizView)
            
                let failQuizViewNib = UINib(nibName: "FailQuizView", bundle: nil)
                let failQuizView = failQuizViewNib.instantiate(withOwner: "QuizResultsViewController", options: nil)[0] as! UIView
                resultsVC.view.addSubview(failQuizView)
            
                // Passing grade users sent to login with Facebook, else
                // quiz is reloaded.
                resultsVC.view.bringSubview(toFront: passQuizView)
                self.show(resultsVC, sender: nil)
            })

        }
    }
    

    @IBAction func trueButtonAction(_ sender: AnyObject) {
        print("User selected true")
        selectedAnswer = "true"
        validateChoice()
    }
    
    @IBAction func falseButtonAction(_ sender: AnyObject) {
        print("User selected false")
        selectedAnswer = "false"
        validateChoice()
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
