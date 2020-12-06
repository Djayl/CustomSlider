//
//  ViewController.swift
//  CustomSlider
//
//  Created by MacBook DS on 06/12/2020.
//

import UIKit

class ViewController: UIViewController {
    
    private lazy var customSlider: CustomSlider = {
        let slider = CustomSlider(sliderRange: 100)
        slider.clipsToBounds = true
        slider.translatesAutoresizingMaskIntoConstraints = false
        return slider
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubview(customSlider)
        
        NSLayoutConstraint.activate([
            customSlider.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 100),
            customSlider.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            customSlider.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            customSlider.heightAnchor.constraint(equalToConstant: 100)
        ])
    }
}

