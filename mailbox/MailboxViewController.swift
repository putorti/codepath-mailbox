//
//  MailboxViewController.swift
//  mailbox
//
//  Created by Jason Putorti on 2/20/16.
//  Copyright © 2016 Jason Putorti. All rights reserved.
//

import UIKit

class MailboxViewController: UIViewController, UIScrollViewDelegate {
    
    @IBOutlet var menuTap: UITapGestureRecognizer!
    @IBOutlet weak var menuImage: UIImageView!
    @IBOutlet weak var rescheduleImage: UIImageView!
    @IBOutlet weak var feedScroller: UIScrollView!
    @IBOutlet weak var feedImage: UIImageView!
    @IBOutlet weak var messageView: UIView!
    @IBOutlet var messagePan: UIPanGestureRecognizer!
    @IBOutlet var edgePan: UIScreenEdgePanGestureRecognizer!
    @IBOutlet weak var mainUI: UIView!
    @IBOutlet weak var leftIcon: UIImageView!
    @IBOutlet weak var rightIcon: UIImageView!
    @IBOutlet var scheduleTap: UITapGestureRecognizer!
    
    var messageOriginalColor: UIColor!
    var messageOriginalCenter: CGPoint!
    var messageCenter: CGPoint!
    var mainUIOriginalCenter: CGPoint!
    var mainUICenter: CGPoint!
    var defaultGray: UIColor!
    
    override func canBecomeFirstResponder() -> Bool {
        return true
    }
    
    override func motionEnded(motion: UIEventSubtype, withEvent event: UIEvent?)
    {
        if motion == .MotionShake
        {
            undoDelete()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        feedScroller.delegate = self
        feedScroller.contentSize = feedImage.image!.size
        messageOriginalCenter = messageView.center
        mainUIOriginalCenter = mainUI.center
        messageOriginalColor = messageView.backgroundColor!
        defaultGray = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25)
        messageView.backgroundColor = defaultGray
        
        // message pan gestures
        messagePan = UIPanGestureRecognizer(target: self, action: "onMessagePan:")
        messageView.addGestureRecognizer(messagePan)
        
        // edge swipe
        edgePan = UIScreenEdgePanGestureRecognizer(target: self, action: "onEdgePan:")
        edgePan.edges = UIRectEdge.Left
        mainUI.addGestureRecognizer(edgePan)
        
        // schedule tap gesture
        scheduleTap = UITapGestureRecognizer(target: self, action: "onImageTap:")
        rescheduleImage.addGestureRecognizer(scheduleTap)
        
        // menu tap gesture
        menuTap = UITapGestureRecognizer(target: self, action: "onImageTap:")
        menuImage.addGestureRecognizer(menuTap)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func onImageTap(tapGestureRecognizer: UITapGestureRecognizer) {
        UIView.animateWithDuration(0.25, animations: {
            self.rescheduleImage.alpha = 0
            self.menuImage.alpha = 0
        },
        completion: { finished in
            self.deleteMessage()
        })
    }
    
    func deleteMessage() {
        UIView.animateWithDuration(0.25, animations: {
            self.feedImage.frame.origin.y = 0;
        })
    }
    
    func undoDelete() {
        self.messageView.center = self.messageOriginalCenter // snap back to origin
        self.messageView.backgroundColor = self.messageOriginalColor
        
        UIView.animateWithDuration(0.25, animations: {
            self.feedImage.frame.origin.y = 86
        })
    }
    
    func onMessagePan(panGestureRecognizer: UIPanGestureRecognizer) {
        
        // Absolute (x,y) coordinates in parent view
        var point = panGestureRecognizer.locationInView(view)
        
        // Relative change in (x,y) coordinates from where gesture began.
        var translation = panGestureRecognizer.translationInView(view)
        var velocity = panGestureRecognizer.velocityInView(view)
        
        if panGestureRecognizer.state == UIGestureRecognizerState.Began {
            print("Gesture began at: \(point)")
        } else if panGestureRecognizer.state == UIGestureRecognizerState.Changed {
            print("Gesture changed at: \(point)")
            messageView.center = CGPoint(x: messageOriginalCenter.x + translation.x, y: messageOriginalCenter.y) // allow drag on x-axis only
            print("frame X: \(messageView.frame.origin.x)")
            
            switch messageView.frame.origin.x {
                
            case -260 ... -120: // archive
                messageView.backgroundColor = UIColor(red: 112/255, green: 216/255, blue: 98/255, alpha: 1)
                leftIcon.image = UIImage(named: "archive_icon")
                print("archive")
            case -600 ... -480: // list
                messageView.backgroundColor = UIColor(red: 216/255, green: 166/255, blue: 117/255, alpha: 1)
                rightIcon.image = UIImage(named: "list_icon")
                print("menu")
            case -480 ... -380: // later
                messageView.backgroundColor = UIColor(red: 250/255, green: 211/255, blue: 51/255, alpha: 1)
                rightIcon.image = UIImage(named: "later_icon")
                print("later")
            case -120 ... 0: // delete
                messageView.backgroundColor = UIColor(red: 235/255, green: 84/255, blue: 51/255, alpha: 1)
                leftIcon.image = UIImage(named: "delete_icon")
                print("delete")
            default: // no action
                messageView.backgroundColor = defaultGray
                leftIcon.image = UIImage(named: "archive_icon")
                rightIcon.image = UIImage(named: "later_icon")
            }
            
        } else if panGestureRecognizer.state == UIGestureRecognizerState.Ended {
            print("Gesture ended at: \(point)")
            
            switch messageView.frame.origin.x {
                
            case -260 ... -120: // archive
                UIView.animateWithDuration(0.25, animations: {
                    self.messageView.frame.origin.x = 0;
                }, completion: { finished in
                    self.deleteMessage()
                })
            case -600 ... -480: // list
                UIView.animateWithDuration(0.25, animations: {
                    self.messageView.frame.origin.x = -640;
                    self.menuImage.alpha = 1;
                })
            case -480 ... -380: // later
                UIView.animateWithDuration(0.25, animations: {
                    self.messageView.frame.origin.x = -640;
                    self.rescheduleImage.alpha = 1;
                })
            case -120 ... 0: // delete
                UIView.animateWithDuration(0.25, animations: {
                    self.messageView.frame.origin.x = 0;
                }, completion: { finished in
                    self.deleteMessage()
                })
            default: // no action
                UIView.animateWithDuration(0.25, animations: {
                    self.messageView.center = self.messageOriginalCenter // snap back to origin
                    self.messageView.backgroundColor = self.messageOriginalColor
                })
            }
        }
    }
    
    func onEdgePan(edgeGestureRecognizer: UIScreenEdgePanGestureRecognizer) {
        
        // Absolute (x,y) coordinates in parent view
        var point = edgeGestureRecognizer.locationInView(view)
        
        // Relative change in (x,y) coordinates from where gesture began.
        var translation = edgeGestureRecognizer.translationInView(view)
        var velocity = edgeGestureRecognizer.velocityInView(view)
        
        if edgeGestureRecognizer.state == UIGestureRecognizerState.Began {
            print("Edge gesture began at: \(point)")
        } else if edgeGestureRecognizer.state == UIGestureRecognizerState.Changed {
            print("Edge gesture changed at: \(point)")
            mainUI.center = CGPoint(x: mainUIOriginalCenter.x + translation.x, y: mainUIOriginalCenter.y) // allow drag on x-axis only
            
        } else if edgeGestureRecognizer.state == UIGestureRecognizerState.Ended {
            print("Edge gesture ended at: \(point)")
            mainUI.center = mainUIOriginalCenter // snap back to origin
        }
        
    }
    
}