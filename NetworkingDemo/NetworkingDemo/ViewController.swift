//
//  ViewController.swift
//  NetworkingDemo
//
//  Created by Mladen Despotovic on 09.07.18.
//  Copyright © 2018 Mladen Despotovic. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let interactor = TimezonesInteractor()
        interactor.getTimezones { (timezones, error) in
            
            // Timezones are here
        }
    }


}

