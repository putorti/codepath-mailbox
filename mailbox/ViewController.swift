//
//  ViewController.swift
//  mailbox
//
//  Created by Jason Putorti on 2/20/16.
//  Copyright © 2016 Jason Putorti. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIScrollViewDelegate {

    @IBOutlet weak var feedScroller: UIScrollView!
    @IBOutlet weak var feedImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        feedScroller.delegate = self
        feedScroller.contentSize = feedImage.image!.size
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

