//
//  ParalaxViewController.swift
//
//  Copyright (c) 2015 Konstantin Kalbazov
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

import Foundation
import UIKit

protocol ParalaxViewControllerDelegate: NSObjectProtocol {
    
    func didTapHeaderImageView(imageView: UIImageView)
}

class ParalaxViewController: UIViewController, UIScrollViewDelegate {
    
    let INVIS_DELTA = 50.0
    let HEADER_HEIGHT = 44.0
    
    var showStatusBarMargin = false
    var backgroundScrollViewHeight: CGFloat {
        get {
            return view.bounds.size.width * 0.74
        }
    }
    
    var useImageZoomEffect = true
    var mainScrollView: UIScrollView!
    private var backgroundScrollView: UIScrollView!
    var delegate: ParalaxViewControllerDelegate!
    var headerHeight: CGFloat {
        get {
            return CGRectGetHeight(backgroundScrollView.frame)
        }
    }
    var contentView = UIScrollView(frame: CGRectZero)
    var floatingHeaderView: UIView!
    var headerImageView: UIImageView!
    var originalImageView: UIImage!
    var scrollViewContainer: UIView!
    var headerOverlayViews = [UIView]()
    var offsetHeight:CGFloat {
        get {
            return CGFloat(HEADER_HEIGHT) + navBarHeight
        }
    }
    var navBarHeight:CGFloat {
        get {
            if navigationController != nil && navigationController?.navigationBarHidden != true {
                // Include 20 for the status bar
                return CGRectGetHeight(navigationController!.navigationBar.frame) + 20
            }
            return 0.0
        }
    }
    
    func setNeedsScrollViewAppearanceUpdate() {
        mainScrollView.contentSize = CGSizeMake(CGRectGetWidth(view.frame), contentView.contentSize.height + CGRectGetHeight(backgroundScrollView.frame))
    }
    
    func setHeaderImage(headerImage: UIImage) {
        originalImageView = headerImage
        headerImageView.image = headerImage
    }
    
    func addHeaderOverlayView(overlay: UIView) {
        headerOverlayViews += [overlay]
        floatingHeaderView.addSubview(overlay)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        automaticallyAdjustsScrollViewInsets = false
        
        mainScrollView = UIScrollView(frame: view.frame)
        view = mainScrollView
        
        mainScrollView.delegate = self
        mainScrollView.bounces = useImageZoomEffect
        mainScrollView.alwaysBounceVertical = mainScrollView.bounces
        mainScrollView.contentSize = CGSizeMake(view.frame.size.width, 1000)
        mainScrollView.showsVerticalScrollIndicator = false
        mainScrollView.autoresizingMask = UIViewAutoresizing.FlexibleWidth | UIViewAutoresizing.FlexibleHeight
        mainScrollView.autoresizesSubviews = true
        
        backgroundScrollView = UIScrollView(frame: CGRectMake(0, 0, CGRectGetWidth(view.frame), backgroundScrollViewHeight))
        
        backgroundScrollView.scrollEnabled = false
        backgroundScrollView.autoresizingMask = UIViewAutoresizing.FlexibleWidth
        backgroundScrollView.autoresizesSubviews = true
        backgroundScrollView.contentSize = CGSizeMake(view.frame.size.width, 1000)
        mainScrollView.addSubview(backgroundScrollView)
        
        headerImageView = UIImageView(frame: CGRectMake(
            0, 0, CGRectGetWidth(backgroundScrollView.frame), CGRectGetHeight(backgroundScrollView.frame)))
        headerImageView.autoresizingMask = UIViewAutoresizing.FlexibleWidth
        headerImageView.contentMode = .ScaleAspectFill
        headerImageView.autoresizingMask = UIViewAutoresizing.FlexibleWidth | UIViewAutoresizing.FlexibleHeight;
        headerImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "headerImageTapped:"))
        headerImageView.userInteractionEnabled = true
        
        backgroundScrollView.addSubview(headerImageView)
        
        floatingHeaderView = UIView(frame: backgroundScrollView.frame)
        floatingHeaderView.backgroundColor = UIColor.clearColor()
        floatingHeaderView.userInteractionEnabled = true
        
        scrollViewContainer = UIView(frame: CGRectMake(0, CGRectGetHeight(backgroundScrollView.frame), CGRectGetWidth(view.frame), CGRectGetHeight(view.frame) - offsetHeight))
        scrollViewContainer.autoresizingMask = UIViewAutoresizing.FlexibleWidth
        
        contentView.autoresizingMask = UIViewAutoresizing.FlexibleWidth;
        scrollViewContainer.addSubview(contentView)
        mainScrollView.addSubview(floatingHeaderView)
        mainScrollView.addSubview(scrollViewContainer)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        setNeedsScrollViewAppearanceUpdate()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        contentView.frame = CGRectMake(0, 0, CGRectGetWidth(scrollViewContainer.frame),
            CGRectGetHeight(self.view.frame) - offsetHeight)
    }
    
    func headerImageTapped(tapGesture: UITapGestureRecognizer) {
        if delegate.respondsToSelector("didTapHeaderImageView:") {
            delegate.didTapHeaderImageView(headerImageView)
        }
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        var delta = CGFloat(0.0)
        let rect = CGRectMake(0.0, 0.0, CGRectGetWidth(scrollViewContainer.frame), backgroundScrollViewHeight)
        let backgroundScrollViewLimit = backgroundScrollView.frame.size.height - offsetHeight - (showStatusBarMargin ? 20.0 : 0.0)
        
        // Here is where I do the "Zooming" image and the quick fade out the text and toolbar
        if (scrollView.contentOffset.y < 0.0) {
            if useImageZoomEffect {
                // calculate delta
                delta = fabs(min(0.0, mainScrollView.contentOffset.y + navBarHeight))
                backgroundScrollView.frame = CGRectMake(CGRectGetMinX(rect) - delta / 2.0, CGRectGetMinY(rect) - delta, CGRectGetWidth(scrollViewContainer.frame) + delta, CGRectGetHeight(rect) + delta)
                // floatingHeaderView.alpha = (CGFloat(INVIS_DELTA) - delta) / CGFloat(INVIS_DELTA)
            }
            else {
                backgroundScrollView.frame = CGRect(x: 0, y: 0, width: rect.size.width, height: rect.size.height)
            }
        }
        else {
            delta = mainScrollView.contentOffset.y
            
            // set alfas
            floatingHeaderView.alpha = 1.0
            
            // Here I check whether or not the user has scrolled passed the limit where I want to stick the header,
            // if they have then I move the frame with the scroll view
            // to give it the sticky header look
            if (delta > backgroundScrollViewLimit) {
                backgroundScrollView.frame = CGRectMake(0.0, delta - backgroundScrollView.frame.size.height + offsetHeight + (showStatusBarMargin ? 20.0 : 0.0),
                    CGRectGetWidth(scrollViewContainer.frame), backgroundScrollViewHeight)
                
                floatingHeaderView.frame = CGRectMake(0.0, delta - floatingHeaderView.frame.size.height + offsetHeight + (showStatusBarMargin ? 20.0 : 0.0),
                    CGRectGetWidth(scrollViewContainer.frame), backgroundScrollViewHeight)
                
                scrollViewContainer.frame = CGRectMake(0.0, CGRectGetMinY(backgroundScrollView.frame) + CGRectGetHeight(backgroundScrollView.frame),
                    scrollViewContainer.frame.size.width, scrollViewContainer.frame.size.height)
                
                contentView.contentOffset = CGPointMake(0, delta - backgroundScrollViewLimit)
                let contentOffsetY = -backgroundScrollViewLimit * 0.5
                backgroundScrollView.setContentOffset(CGPointMake(0, contentOffsetY), animated: false)
            }
            else {
                backgroundScrollView.frame = rect
                floatingHeaderView.frame = rect
                scrollViewContainer.frame = CGRectMake(0, CGRectGetMinY(rect) + CGRectGetHeight(rect),
                    scrollViewContainer.frame.size.width, scrollViewContainer.frame.size.height)
                contentView.setContentOffset(CGPointMake(0, 0), animated: false)
                backgroundScrollView.setContentOffset(CGPointMake(0, -delta * 0.5), animated: false)
            }
        }
    }
}
