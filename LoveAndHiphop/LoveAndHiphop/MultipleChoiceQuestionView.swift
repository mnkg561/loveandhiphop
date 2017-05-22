//
//  FactQuestionView.swift
//  LoveAndHiphop
//
//  Created by hollywoodno on 5/18/17.
//  Copyright © 2017 Mogulla, Naveen. All rights reserved.
//

import UIKit

protocol MultipleChoiceQuestionViewDelegate {
  func MultiplChoiceViewDidSelectAnswer(multipleChoiceQuestionView: MultipleChoiceQuestionView, button: UIButton, selectedAnswer: Int)
}

@IBDesignable
class MultipleChoiceQuestionView: UIView, UIScrollViewDelegate {
  
  // MARK: Properites
  @IBOutlet weak var questionLabel: UILabel!
  @IBOutlet weak var answer1Button: UIButton!
  @IBOutlet weak var answer2Button: UIButton!
  @IBOutlet weak var answer3Button: UIButton!
  @IBOutlet weak var answer4Button: UIButton!
  @IBOutlet var contentView: UIView!
  @IBOutlet weak var scrollView: UIScrollView!
  
  var selectedAnswer: Int?
  var answer: Int?
  var answerButtons: [UIButton]!
  var delegate: MultipleChoiceQuestionViewDelegate?
  
  var question: String? {
    get {
      return questionLabel.text
    }
    
    set {
      questionLabel.text = newValue
    }
  }
  
  var answer1: String? {
    get {
      return answer1Button.titleLabel?.text
    }
    
    set {
      answer1Button.setTitle(newValue, for: .normal)
      answer1Button.layer.cornerRadius = 5
      answer1Button.layer.borderWidth = 1
      answer1Button.layer.borderColor = UIColor.white.cgColor
    }
  }
  
  var answer2: String? {
    get {
      return answer2Button.titleLabel?.text
    }
    
    set {
      answer2Button.setTitle(newValue, for: .normal)
      answer2Button.layer.cornerRadius = 5
      answer2Button.layer.borderWidth = 1
      answer2Button.layer.borderColor = UIColor.white.cgColor
    }
  }
  
  var answer3: String? {
    get {
      return answer1Button.titleLabel?.text
    }
    
    set {
      answer3Button.setTitle(newValue, for: .normal)
      answer3Button.layer.cornerRadius = 5
      answer3Button.layer.borderWidth = 1
      answer3Button.layer.borderColor = UIColor.white.cgColor
    }
  }
  
  var answer4: String? {
    get {
      return answer4Button.titleLabel?.text
    }
    
    set {
      answer4Button.setTitle(newValue, for: .normal)
      answer4Button.layer.cornerRadius = 5
      answer4Button.layer.borderWidth = 1
      answer4Button.layer.borderColor = UIColor.white.cgColor
    }
  }
  
  var answers: [String]? {
    get {
      return [(answer1Button.titleLabel?.text)!,
              (answer2Button.titleLabel?.text)!,
              (answer3Button.titleLabel?.text)!,
              (answer4Button.titleLabel?.text)!
      ]
    }
    
    set {
      answer1 = newValue?[0]
      answer2 = newValue?[1]
      answer3 = newValue?[2]
      answer4 = newValue?[3]
    }
  }
  
  
  // MARK: Methods
  @IBAction func didTapAnswer(_ sender: UIButton) {
    selectedAnswer = sender.tag

    // Deselect all other buttons, except selected
    for button in answerButtons {
      button.backgroundColor = UIColor.clear
    }
//    sender.backgroundColor = UIColor(red: 170/255, green: 56/255, blue: 35/255, alpha: 1.0)
    
    sender.backgroundColor = UIColor(red: 49/255, green: 136/255, blue: 170/255, alpha: 1.0)
    
    
    // Alert delegates
    delegate?.MultiplChoiceViewDidSelectAnswer(multipleChoiceQuestionView: self, button: sender, selectedAnswer: sender.tag)
  }
  
  // WHEN HOVERING IN ANSWER AREA
  
  
  // MARK: Initialization
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    loadNib()
  }
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    UIButton.appearance().layer.cornerRadius = 5
    loadNib()
    
  }
  
  func loadNib() {
    
    // Initialize the nib
    let nib = UINib(nibName: "MultipleChoiceQuestionView", bundle: Bundle(for: type(of: self)))
    nib.instantiate(withOwner: self, options: nil)

    // Set up custom view.
    contentView.frame = bounds // Fill up superview, with constraints applie
    
    scrollView.contentSize = contentView.frame.size
    
    // Add custom view to this view
    addSubview(contentView)
    
    // Allows easier control over manipulating button state appearances
    answerButtons = [answer1Button, answer2Button, answer3Button, answer4Button]
    
    // When this view is instantiated, it will remain
    // grow with it's container with constraints applied
    self.setNeedsLayout()
    self.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    self.translatesAutoresizingMaskIntoConstraints = true
  }
  
}
