//
//  ViewController.swift
//  Debouncer&Throttler
//
//  Created by zhanx630 on 2021/12/7.
//

import UIKit

class ViewController: UIViewController {
    
    lazy var throttler = Throttler(.milliseconds(2000), { [weak self] in self?.hhhhh() })

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        let button = UIButton(frame: CGRect(x: 100, y: 100, width: 100, height: 100))
        button.backgroundColor = .black
        button.addTarget(self, action: #selector(test), for: .touchUpInside)
        view.addSubview(button)
    }
    
    @objc func test() {
        throttler.call()
    }
    
    func hhhhh() {
        print(CFAbsoluteTimeGetCurrent(), "hhhhhh");
    }
}

