//
//  DetallVC.swift
//  MyTravel
//
//  Created by 江宗益 on 2017/9/28.
//  Copyright © 2017年 江宗益. All rights reserved.
//

import UIKit

class DetallVC: UIViewController {
    
    let app = UIApplication.shared.delegate as! AppDelegate

    override func viewDidLoad() {
        super.viewDidLoad()

        print("Detail:\(app.nowId)")
    }

    
}
