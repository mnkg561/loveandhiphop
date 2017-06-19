//
//  AppDelegate.swift
//  LoveAndHiphop
//
//  Created by Mogulla, Naveen on 4/25/17.
//  Copyright © 2017 Mogulla, Naveen. All rights reserved.
//

import UIKit
import Parse
import FBSDKCoreKit
import ParseFacebookUtilsV4
import GooglePlaces

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
  
  var window: UIWindow?
  
  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
    
    // self.window?.backgroundColor = UIColor.black
    //self.window?.backgroundColor = UIColor(patternImage: UIImage(named: "background_color")!)
    
    //UIView.appearance().backgroundColor = UIColor.cyan
    // Set up shared navigation bar settings
    let navigationBarAppearance = UINavigationBar.appearance()
    navigationBarAppearance.backgroundColor = UIColor.purple
    
    let tabBarAppearance = UITabBar.appearance()
    tabBarAppearance.backgroundColor = UIColor.purple
    //    navigationBarAppearace.tintColor = UIColor.white // Text buttons
    //    navigationBarAppearace.barTintColor = UIColor(red: 127/255, green: 167/255, blue: 255/255, alpha: 1) // Nav bar
    //    navigationBarAppearace.titleTextAttributes = [NSForegroundColorAttributeName:UIColor.white]  // Title's text color etc.
    
    // MARK: Parse Initialization
    Parse.initialize(with: ParseClientConfiguration(block: { (configuration: ParseMutableClientConfiguration) in
      configuration.applicationId = "group3projectcodepathloveandhiphop"
      configuration.server = "https://loveandhiphop.herokuapp.com/parse"
    }))
    
    // MARK: Facebook Initialization
    FBSDKSettings.setAppID("1491026230961299")
    PFFacebookUtils.initializeFacebook(applicationLaunchOptions: launchOptions)
    PFUser.enableRevocableSessionInBackground()
    
    // MARK: Google Places Initialization
    GMSPlacesClient.provideAPIKey("AIzaSyBz_NJSzflKV2HyTMRaCXf8UZXZDuTz38A")
    
    // First time users (or users who've logged out)
    // must pass HipHop membership quiz.
    if PFUser.current() == nil {
      let storyboard = UIStoryboard(name: "Quiz", bundle: nil)
      let initialViewController = storyboard.instantiateViewController(withIdentifier: "QuizViewController")
      
      self.window?.rootViewController = initialViewController
      self.window?.makeKeyAndVisible()
      
    }
    
    //    UITextField.appearance(whenContainedInInstancesOf: [ViewController.self, TableViewController.self])
    //    UITextField.appearance(whenContainedInInstancesOf: [ViewController.self, TableViewController.self]).

    
    return FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
  }
  
  func applicationWillResignActive(_ application: UIApplication) {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
  }
  
  func applicationDidEnterBackground(_ application: UIApplication) {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
  }
  
  func applicationWillEnterForeground(_ application: UIApplication) {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
  }
  
  func applicationDidBecomeActive(_ application: UIApplication) {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    FBSDKAppEvents.activateApp()
  }
  
  func applicationWillTerminate(_ application: UIApplication) {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
  }
  
  func application(_ application: UIApplication,
                   open url: URL,
                   sourceApplication: String?,
                   annotation: Any) -> Bool {
    return FBSDKApplicationDelegate.sharedInstance().application(application,
                                                                 open: url as URL!,
                                                                 sourceApplication: sourceApplication,
                                                                 annotation: annotation)
  }
  
}

