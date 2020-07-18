//
//  WeatherViewController.swift
//  Balluchon
//
//  Created by Ludovic HENRY on 18/07/2020.
//  Copyright © 2020 Ludovic HENRY. All rights reserved.
//

import UIKit

class WeatherViewController: UIViewController {

    @IBOutlet weak var weatherPicture: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let ws = WeatherService.shared
        ws.getWeather(cityID: "5128581") { (success, weather, image) -> (Void) in
            guard success else {
                print("ERROR")
                return
            }
            
            self.weatherPicture.image = UIImage(data: image!)
            print(weather?.name)
            
        }
    }
    
}
