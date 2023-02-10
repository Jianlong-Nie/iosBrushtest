//
//  ViewController.swift
//  brush
//
//  Created by Jianlong Nie on 2023/2/9.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let hollowBrushView = HollowBrushView()
//        hollowBrushView.backgroundColor=UIColor.red;
        hollowBrushView.frame=view.frame;
        view.addSubview(hollowBrushView)
    }


}

