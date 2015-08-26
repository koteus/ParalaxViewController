//
//  ViewController.swift
//  ParalaxViewControllerExample
//
//  Copyright (c) 2015 Konstantin Kalbazov. All rights reserved.
//

import UIKit

class ViewController: ParalaxViewController {

    var textView: UITextView!
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.setNavigationBarHidden(true, animated: false)
        showStatusBarMargin = true
        useImageZoomEffect = true
        
        textView = UITextView(frame: view.bounds)
        textView.editable = false
        textView.scrollEnabled = false
        
        textView.text = "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Fusce aliquet mattis ante a varius. Nunc pulvinar nunc tortor, sit amet porta erat tincidunt non. Maecenas sed pulvinar tortor. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Etiam magna ante, pulvinar at augue eu, placerat dignissim magna. Nunc fringilla pulvinar libero, nec vehicula ante interdum vel. Cras cursus mollis semper. Class aptent taciti sociosqu ad litora torquent per conubia nostra, per inceptos himenaeos. Interdum et malesuada fames ac ante ipsum primis in faucibus. In a neque ac ipsum accumsan blandit.\n Praesent eleifend varius ligula, id feugiat nulla ultrices vitae. Proin quis odio vitae neque tristique ultrices. Vestibulum facilisis diam vitae sapien posuere, vel ullamcorper odio ornare. Mauris quis euismod nisl, a fermentum dui. Nunc et ultrices sem. Cras tristique dignissim massa, ac facilisis nulla scelerisque et. In hac habitasse platea dictumst. Quisque sed lacinia purus, eget sagittis turpis. Curabitur bibendum nisi vel libero ultricies, lobortis gravida diam lobortis. Nulla a nisl vel nunc iaculis tempor at vestibulum ipsum. Proin et tincidunt erat. Nullam finibus bibendum tincidunt. Donec eleifend efficitur enim, lacinia molestie nisl eleifend vitae. Fusce augue leo, mattis bibendum est eu, accumsan tempus erat.\n Mauris auctor at massa non molestie. Donec eleifend cursus leo, sed lobortis justo aliquam vel. Maecenas quam nunc, scelerisque dapibus posuere nec, elementum eu tortor. Ut eget scelerisque urna. In in pellentesque dui, eget imperdiet nunc. Integer sed risus dolor. Donec volutpat, dolor vitae fringilla efficitur, metus nulla pretium orci, vel lacinia magna lorem non massa. Aenean efficitur finibus eros, ut fermentum leo tempor ac. Pellentesque sed odio nisi. Sed efficitur metus lorem, vitae lacinia turpis interdum ac. Maecenas a lorem facilisis, tincidunt ligula et, pellentesque purus. Etiam sollicitudin vulputate sollicitudin. Curabitur suscipit ante ut tempus feugiat. \n Cras cursus mollis semper. Class aptent taciti sociosqu ad litora torquent per conubia nostra, per inceptos himenaeos. Interdum et malesuada fames ac ante ipsum primis in faucibus. In a neque ac ipsum accumsan blandit.\n Praesent eleifend varius ligula, id feugiat nulla ultrices vitae. Proin quis odio vitae neque tristique ultrices. Vestibulum facilisis diam vitae sapien posuere, vel ullamcorper odio ornare. Mauris quis euismod nisl, a fermentum dui. Nunc et ultrices sem. Cras tristique dignissim massa, ac facilisis nulla scelerisque et. In hac habitasse platea dictumst. Quisque sed lacinia purus, eget sagittis turpis. Curabitur bibendum nisi vel libero ultricies, lobortis gravida diam lobortis. Nulla a nisl vel nunc iaculis tempor at vestibulum ipsum. Proin et tincidunt erat. Nullam finibus bibendum tincidunt. Donec eleifend efficitur enim, lacinia molestie nisl eleifend vitae. Fusce augue leo, mattis bibendum est eu, accumsan tempus erat.\n Mauris auctor at massa non molestie. Donec eleifend cursus leo, sed lobortis justo aliquam vel. Maecenas quam nunc, scelerisque dapibus posuere nec, elementum eu tortor. Ut eget scelerisque urna. In in pellentesque dui, eget imperdiet nunc. Integer sed risus dolor. Donec volutpat, dolor vitae fringilla efficitur, metus nulla pretium orci, vel lacinia magna lorem non massa. Aenean efficitur finibus eros, ut fermentum leo tempor ac. Pellentesque sed odio nisi. Sed efficitur metus lorem, vitae lacinia turpis interdum ac. Maecenas a lorem facilisis, tincidunt ligula et, pellentesque purus. Etiam sollicitudin vulputate sollicitudin. Curabitur suscipit ante ut tempus feugiat."

        contentView.backgroundColor = UIColor.whiteColor()
        contentView.addSubview(textView)
        contentView.scrollEnabled = false
        
        super.viewDidLoad()
        
        setHeaderImage(UIImage(named: "bg.jpg")!)
        
        let bar = UIView(frame: CGRectMake(0, headerHeight - 44, view.bounds.size.width, 44))
        bar.backgroundColor = UIColor(
            red: 114.0/255.0, green: 47.0/255.0, blue: 139.0/255.0, alpha: 1.0)
        
        let label = UILabel(frame: CGRectMake(15, 14, 0, 14))
        label.text = "Hello Kitty"
        label.font = label.font.fontWithSize(13.0)
        label.textColor = UIColor.whiteColor()
        label.sizeToFit()
        bar.addSubview(label)
        
        addHeaderOverlayView(bar)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        textView.sizeToFit()
        
        contentView.contentSize = CGSizeMake(
            textView.frame.size.width,
            textView.frame.size.height
        )
    }

}

