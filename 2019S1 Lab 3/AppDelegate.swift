//
//  AppDelegate.swift
//  2019S1 Lab 3
//
//  Created by Michael Wybrow on 15/3/19.
//  Copyright © 2019 Michael Wybrow. All rights reserved.
//


//Tab bar icons references
//Icon made by Freepik from www.flaticon.com




import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, CAAnimationDelegate {

    var window: UIWindow?
    var databaseController: DatabaseProtocol?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        databaseController = FirebaseController()
        
        
        
        //REFERENCE FROM https://github.com/vpetrenko90/launch-screen-animation
        //Splash screen with raspberry logo
        self.window = UIWindow(frame: UIScreen.main.bounds)
        self.window!.backgroundColor = UIColor(red: 197/255, green: 26/255, blue: 74/255, alpha: 1)
        self.window!.makeKeyAndVisible()
        
        // rootViewController from StoryBoard
        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let navigationController = mainStoryboard.instantiateViewController(withIdentifier: "tabController")
        self.window!.rootViewController = navigationController
        
        // logo mask
        navigationController.view.layer.mask = CALayer()
        navigationController.view.layer.mask?.contents = UIImage(named: "pi.jpg")!.cgImage
        navigationController.view.layer.mask?.bounds = CGRect(x: 0, y: 0, width: 100, height: 100)
        navigationController.view.layer.mask?.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        navigationController.view.layer.mask?.position = CGPoint(x: navigationController.view.frame.width / 2, y: navigationController.view.frame.height / 2)
        
        // logo mask background view
        let maskBgView = UIView(frame: navigationController.view.frame)
        maskBgView.backgroundColor = UIColor.white
        navigationController.view.addSubview(maskBgView)
        navigationController.view.bringSubviewToFront(maskBgView)
        
        // logo mask animation
        let transformAnimation = CAKeyframeAnimation(keyPath: "bounds")
        transformAnimation.delegate = self
        transformAnimation.duration = 1
        transformAnimation.beginTime = CACurrentMediaTime() + 1 //add delay of 1 second
        let initalBounds = NSValue(cgRect: (navigationController.view.layer.mask?.bounds)!)
        let secondBounds = NSValue(cgRect: CGRect(x: 0, y: 0, width: 50, height: 50))
        let finalBounds = NSValue(cgRect: CGRect(x: 0, y: 0, width: 2000, height: 2000))
        transformAnimation.values = [initalBounds, secondBounds, finalBounds]
        transformAnimation.keyTimes = [0, 0.5, 1]
        transformAnimation.timingFunctions = [CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut), CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeOut)]
        transformAnimation.isRemovedOnCompletion = false
        transformAnimation.fillMode = CAMediaTimingFillMode.forwards
        navigationController.view.layer.mask?.add(transformAnimation, forKey: "maskAnimation")
        
        // logo mask background view animation
        UIView.animate(withDuration: 0.1,
                       delay: 1.35,
                       options: UIView.AnimationOptions.curveEaseIn,
                       animations: {
                        maskBgView.alpha = 0.0
        },
                       completion: { finished in
                        maskBgView.removeFromSuperview()
        })
        
        // root view animation
        UIView.animate(withDuration: 0.25,
                       delay: 1.3,
                       options: [],
                       animations: {
                        self.window!.rootViewController!.view.transform = CGAffineTransform(scaleX: 1.05, y: 1.05)
        },
                       completion: { finished in
                        UIView.animate(withDuration: 0.3,
                                       delay: 0.0,
                                       options: UIView.AnimationOptions.curveEaseInOut,
                                       animations: {
                                        self.window!.rootViewController!.view.transform = .identity
                        },
                                       completion: nil)
        })
        return true
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
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

