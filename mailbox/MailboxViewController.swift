//
//  MailboxViewController.swift
//  mailbox
//
//  Created by Jason Putorti on 2/20/16.
//  Copyright © 2016 Jason Putorti. All rights reserved.
//

import UIKit

class MailboxViewController: UIViewController, UIScrollViewDelegate {
    
    @IBOutlet weak var feedScroller: UIScrollView!
    @IBOutlet weak var feedImage: UIImageView!
    @IBOutlet weak var messageView: UIView!
    @IBOutlet var messagePan: UIPanGestureRecognizer!
    @IBOutlet var edgePan: UIScreenEdgePanGestureRecognizer!
    @IBOutlet weak var mainUI: UIView!
    var messageOriginalCenter: CGPoint!
    var messageCenter: CGPoint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        feedScroller.delegate = self
        feedScroller.contentSize = feedImage.image!.size
        messageOriginalCenter = messageView.center
        // Do any additional setup after loading the view, typically from a nib.
        
        // The onCustomPan: method will be defined in Step 3 below.
        var panGestureRecognizer = UIPanGestureRecognizer(target: self, action: "onMessagePan:")
        
        // Attach it to a view of your choice. If it's a UIImageView, remember to enable user interaction
        messageView.addGestureRecognizer(messagePan)
        
        var edgeGestureRecognizer = UIScreenEdgePanGestureRecognizer(target: self, action: "onEdgePan:")
        
        view.addGestureRecognizer(edgePan)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
            
        } else if panGestureRecognizer.state == UIGestureRecognizerState.Ended {
            print("Gesture ended at: \(point)")
            
            messageView.center = messageOriginalCenter // snap back to origin
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
            
        } else if edgeGestureRecognizer.state == UIGestureRecognizerState.Ended {
            print("Edge gesture ended at: \(point)")
        }
        
    }
    
}