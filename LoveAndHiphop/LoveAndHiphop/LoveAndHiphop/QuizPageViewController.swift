//
//  QuizPageViewController.swift
//  LoveAndHiphop
//
//  Created by hollywoodno on 4/27/17.
//  Copyright © 2017 Mogulla, Naveen. All rights reserved.
//

import UIKit

class QuizPageViewController: UIPageViewController, UIPageViewControllerDelegate, UIPageViewControllerDataSource {
  
  // MARK: Properties
  
  // Set up the list of view controllers.
  // Each instance represents a question of the quiz.
  lazy var quizViewControllers: [UIViewController] = {
    
    let storyboard = UIStoryboard(name: "Main", bundle: nil)
    
    return [storyboard.instantiateViewController(withIdentifier: "QuizTableViewController") as! QuizTableViewController, storyboard.instantiateViewController(withIdentifier: "QuizTableViewController") as! QuizTableViewController, storyboard.instantiateViewController(withIdentifier: "QuizTableViewController") as! QuizTableViewController, storyboard.instantiateViewController(withIdentifier: "SubmitQuizViewController") as! SubmitQuizViewController]
  }()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // Required for using gestures for paging through quiz questions
    self.dataSource = self
    self.delegate = self
    
    // Set the first page as the first question
    if let firstVC = quizViewControllers.first {
      setViewControllers([firstVC], direction: .forward, animated: true, completion: nil)
    }
  }
  
  // Get the previous question
  public func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
    
    guard let viewControllerIndex = quizViewControllers.index(of: viewController) else {
      return nil
    }
    
    let previousIndex = viewControllerIndex - 1
    
    // If there is no view previous view controller,
    // current controller is the first, so we want to remain there,
    // or possibly display something to allow user to cancel the quiz.
    guard previousIndex >= 0 else {
      return nil
    }
    
    guard quizViewControllers.count > previousIndex else {
      return nil
    }
    
    return quizViewControllers[previousIndex]
  }
  
  // Get the next question
  public func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
    
    guard let viewControllerIndex = quizViewControllers.index(of: viewController) else {
      return nil
    }
    
    let nextIndex = viewControllerIndex + 1
    
    // If there is no view next view controller,
    // current controller is the last, so user has finished the test.
    // At this point they are only allowed to submit or return back to previous page.
    guard nextIndex < quizViewControllers.count else {
      return nil
    }
    
    guard quizViewControllers.count > nextIndex else {
      return nil
    }
    return quizViewControllers[nextIndex]
  }
  
  // The next 2 methods allows a page control to be automatically generated
  // and updated during paging.
  func presentationCount(for pageViewController: UIPageViewController) -> Int {
    return quizViewControllers.count
  }
  
  func presentationIndex(for pageViewController: UIPageViewController) -> Int {
    
    guard let firstViewController = viewControllers?.first, let firstViewControllerIndex = quizViewControllers.index(of: firstViewController) else {
      return 0
    }
    
    return firstViewControllerIndex
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
