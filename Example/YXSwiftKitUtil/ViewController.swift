//
//  ViewController.swift
//  YXSwiftKitUtil
//
//  Created by Mr-Jesson on 02/23/2022.
//  Copyright (c) 2022 Mr-Jesson. All rights reserved.
//

import UIKit
import YXSwiftKitUtil

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        YXKitLogger.show()
//        YXNetworkManager.share
//        YXNetworkManager.initAppNetwork(config: YXNetworkConfig.init(dataKey: "data", messageKey: "msg", codeKey: "code", successCode: "200"));
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

