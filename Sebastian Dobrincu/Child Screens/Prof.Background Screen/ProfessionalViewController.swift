//
//  ProfessionalViewController.swift
//  Sebastian Dobrincu
//
//  Created by Sebastian Dobrincu on 19/04/15.
//  Copyright (c) 2015 Sebastian Dobrincu. All rights reserved.
//

import UIKit

class ProfessionalViewController: SDTransitionViewController, ZLSwipeableViewDataSource, ZLSwipeableViewDelegate {

    var cardsCount = 6
    var cardsIndex = 0
    var colors = [UIColor]()
    var swipeableView = ZLSwipeableView()
    var quoteLabel = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Initial setup
        controllerSetup()
        
        colors = [UIColor.orangeColor(),
                  UIColor(red:0.95, green:0.25, blue:0.54, alpha:1),
                  UIColor(red:0.21, green:0.27, blue:0.31, alpha:1),
                  UIColor(red:0.31, green:0.72, blue:0.76, alpha:1),
                  UIColor(red:0.95, green:0.25, blue:0.54, alpha:1),
                  UIColor(red:0.41, green:0.47, blue:0.85, alpha:1),
                  UIColor(red:0.13, green:0.71, blue:0.45, alpha:1)]
        
        var swipeableView = ZLSwipeableView(frame: CGRect(x: 0, y: 170, width: self.view.frame.size.width, height: self.view.frame.height-170))
        swipeableView.tag = 98
        swipeableView.alpha = 0
        swipeableView.delegate = self
        swipeableView.dataSource = self
        self.view.addSubview(swipeableView)
        
        UIView.animateWithDuration (0.25, delay: 0.35, options: UIViewAnimationOptions.CurveLinear ,animations: {
            swipeableView.alpha = 1
        }, completion:nil)
        
        let delayTime = dispatch_time(DISPATCH_TIME_NOW,
            Int64(0.6 * Double(NSEC_PER_SEC)))
        dispatch_after(delayTime, dispatch_get_main_queue()) {
            
            
            var labelInset:CGFloat = 80
            if SDiPhoneVersion.deviceSize() == DeviceSize.iPhone55inch{
                labelInset = 115
            }
            self.quoteLabel.alpha = 0
            self.quoteLabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width-labelInset, height: 200))
            self.quoteLabel.center = swipeableView.center
            self.quoteLabel.tag = 98
            
            var paragraphStyle = NSMutableParagraphStyle.new()
            paragraphStyle.alignment = NSTextAlignment.Right
            var attributedString = NSMutableAttributedString(string: "Your time is limited, so don't waste it living someone else's life. \n")
            attributedString.appendAttributedString(NSAttributedString(string: "— Steve Jobs", attributes:
                [
                    NSParagraphStyleAttributeName:paragraphStyle,
                    NSFontAttributeName:UIFont(name: "SourceSansPro-Regular", size: 20)!
                ]))
            
            self.quoteLabel.font = UIFont(name: "SourceSansPro-Bold", size: 20)
            self.quoteLabel.numberOfLines = 0
            self.quoteLabel.textColor = UIColor.whiteColor()
            self.quoteLabel.attributedText = attributedString
            self.view.insertSubview(self.quoteLabel, belowSubview: swipeableView)
            

        }

    }
    
    func nextViewForSwipeableView(swipeableView: ZLSwipeableView!) -> UIView! {
        
        if cardsIndex < cardsCount{
            
            cardsIndex++
            
            var v = UIImageView(frame: CGRect(x: 100, y: 200, width: 300, height: 420))
            v.clipsToBounds = true
            v.layer.cornerRadius = 10
            v.layer.shouldRasterize = true
            v.layer.rasterizationScale = UIScreen.mainScreen().scale
            
            if cardsIndex == 1{
                var visualEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .Dark)) as UIVisualEffectView
                visualEffectView.frame = v.bounds
                v.addSubview(visualEffectView)
            }
            

            var titleLabel = UILabel(frame: CGRect(x: 0, y: 60, width: v.frame.size.width, height: 50))
            titleLabel.font = UIFont (name: "SourceSansPro-Regular", size: 40)
            titleLabel.textAlignment = NSTextAlignment.Center
            titleLabel.textColor = UIColor.whiteColor()
            v.addSubview(titleLabel)
            
            var widthInset:CGFloat = 50
            var descriptionTextView = UITextView(frame: CGRect(x: widthInset/2, y: titleLabel.frame.origin.y+titleLabel.frame.size.height+15, width: v.frame.size.width-widthInset, height: v.frame.size.height-titleLabel.frame.size.height-titleLabel.frame.origin.y-40))
            descriptionTextView.editable = false
            descriptionTextView.selectable = false
            descriptionTextView.textColor = UIColor.whiteColor()
            descriptionTextView.backgroundColor = UIColor.clearColor()
            descriptionTextView.font = UIFont(name: "SourceSansPro-Regular", size: 16)
            descriptionTextView.textAlignment = NSTextAlignment.Center
            v.addSubview(descriptionTextView)
            
            switch cardsIndex {
                case 1:
                    v.contentMode = UIViewContentMode.ScaleAspectFill
                    v.image = UIImage(named: "swift_logo")
                    titleLabel.text = "Swift"
                    descriptionTextView.text = "I have started learning Swift, right after the launch at WWDC 14. I was so excited and in love with it, that I even created a short tutorial covering the basics in the first day after launch. In fact, this screen is made entirely using Swift. How can you not love the way it's so simple, yet so powerful?!"
                    break
                
                case 2:
                    titleLabel.text = "Objective-C"
                    descriptionTextView.text = "I've started learning Objective-C about 4 years ago. I was amazed by the things I was able to create then and that really motivated me to contiune learning it. Till today, it's still my preffered programming language, especially because I feel very confident using it."
                    break

                case 3:
                   titleLabel.text = "Ruby"
                    descriptionTextView.text = "When I was creating iOS apps, I really wanted to be able to manage the server side. That's why I got into Ruby and absolutely love it. I'm able to create such awesome things, as APIs, with such a ease and in no time. That helps me boost the scalability of my apps as I can manage my own backend."
                    break

                case 4:
                    titleLabel.text = "C++"
                    descriptionTextView.text = "I mainly got into C++ cause of my school's curriculum. I found it very easy, especially because I was coming from an Objective-C background. But, after all, it really helped improve my C foundation and it even helped me create some iOS libraries that I still use in my apps, thanks to their flexibility."
                    break
                
                case 5:
                    titleLabel.text = "Front-end"
                    descriptionTextView.text = "When I was just 9-10 years old, I was fascinated by how I was able to create web pages in simple text editing softwares. In fact, I was so fascinated that I spend the next 2 years learning more about front end development. Especially, HTML, CSS as well as Javascript. In the end I was able to create sleek & interesting web sites for my clients."
                    break

                case 6:
                    titleLabel.text = "Other Tools"
                    descriptionTextView.text = "Of course that being a programmer isn't all about learning programming languages, but more about combining them and getting the most out of each. It the past I've also worked with tons of 3rd party libraries, frameworks and usefull tools, such as Git, FTP, SSH and more."
                    break
                
                default:
                    break
            }
            
            v.backgroundColor = colors[cardsIndex]
            v.tag = cardsIndex
            
            return v
        }else{
            return nil
        }
        
    }
    
    func swipeableView(swipeableView: ZLSwipeableView!, didSwipeView view: UIView!, inDirection direction: ZLSwipeableViewDirection) {
        if view.tag == 7{
            
            UIView.animateWithDuration (0.25, delay: 0.45, options: UIViewAnimationOptions.CurveLinear ,animations: {
                self.quoteLabel.alpha = 1
            }, completion:nil)
            
        }
    }
    
    func controllerSetup(){
        var swipeDown:UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action:"closeVC")
        swipeDown.direction = UISwipeGestureRecognizerDirection.Down
        var dismissingView:UIView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 150))
        self.view.addSubview(dismissingView)
        dismissingView.addGestureRecognizer(swipeDown)
        
        for view in self.view.subviews as! [UIView] {
            if view.tag == 99 {
                view.alpha = 0
                var fr:CGRect = view.frame
                fr.origin.x -= self.view.frame.size.width
                view.frame = fr
                
            }else if view.tag == 98{
                view.alpha = 0
            }
        }
        
        UIView.animateWithDuration(0.3,
            delay: 0.2,
            options: .CurveEaseInOut,
            animations: {
              
                for view in self.view.subviews as! [UIView] {
                    if view.tag == 99 {
                        view.alpha = 1
                        var fr:CGRect = view.frame
                        fr.origin.x += self.view.frame.size.width
                        view.frame = fr
                     
                    }
                }
                
            },
            completion: { finished in
              
                UIView.animateWithDuration(0.2, delay: 0, options: .CurveEaseInOut, animations: {
                    
                }, completion: { finished2  in
                    for view in self.view.subviews as! [UIView] {
                        if view.tag == 98{
                            view.alpha = 1
                        }
                    }
                })
                
        })
    
       
        
    }

    func closeVC(){
            self.close(nil)
    }

}
