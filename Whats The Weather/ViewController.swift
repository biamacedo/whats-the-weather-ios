//
//  ViewController.swift
//  Whats The Weather
//
//  Created by BEATRIZ MACEDO on 9/27/15.
//  Copyright © 2015 Beatriz Macedo. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var cityTextField: UITextField!
    @IBOutlet weak var resultLabel: UILabel!
    
    @IBAction func findWeather() {
        
        var wasSuccessiful = false
        
        let city = cityTextField.text!.stringByReplacingOccurrencesOfString(" ", withString: "-")
        
        let attemptedUrl = NSURL(string: "http://www.weather-forecast.com/locations/\(city)/forecasts/latest")
        
        if let url = attemptedUrl {
            
            let task = NSURLSession.sharedSession().dataTaskWithURL(url) { (data, response, error) -> Void in
                
                if let urlContent = data {
                    let webContent = NSString(data: urlContent, encoding: NSUTF8StringEncoding)
                    
                    let websiteArray = webContent!.componentsSeparatedByString("3 Day Weather Forecast Summary:</b><span class=\"read-more-small\"><span class=\"read-more-content\"> <span class=\"phrase\">")
                    
                    if websiteArray.count > 1 {
                        print(websiteArray[1])
                        
                        let weatherArray = websiteArray[1].componentsSeparatedByString("</span>")
                        
                        if weatherArray.count > 1 {
                            
                            wasSuccessiful = true
                            
                            let weatherSummary = weatherArray[0].stringByReplacingOccurrencesOfString("&deg;", withString: "º")
                            
                            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                                
                                self.resultLabel.textColor = UIColor.blackColor()
                                self.resultLabel.text = weatherSummary
                            })
                        }
                    }
                }
                
                if !wasSuccessiful {
                    self.resultLabel.textColor = UIColor.redColor()
                    self.resultLabel.text = "Could't find the weather for that city - please try again!"
                }
            }
            
            task.resume()
            
        } else {
            self.resultLabel.textColor = UIColor.redColor()
            self.resultLabel.text = "Could't find the weather for that city - please try again!"
        }
        
    }

override func viewDidLoad() {
    super.viewDidLoad()
}

override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
}


}

