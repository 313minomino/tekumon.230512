//
//  LobbyViewController.swift
//  tekumon.230512
//
//  Created by 酒井実 on 2023/05/12.
//

import UIKit

class LobbyViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        TechMonManager.stopBGM()
    }

}
