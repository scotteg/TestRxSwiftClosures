//
//  DetailViewController.swift
//  TestRxSwiftClosures
//
//  Created by Scott Gardner on 3/6/16.
//  Copyright © 2016 Scott Gardner. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import Async

class DetailViewController: UIViewController {
  
  @IBOutlet weak var textField: UITextField!
  @IBOutlet weak var textFieldLabel: UILabel!
  
  var someValue = "" {
    didSet {
      print(someValue)
    }
  }
  
  let disposeBag = DisposeBag()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // Do any additional setup after loading the view.
    
    // Results in unhandled strong reference cycle
//    textField.rx_text.asDriver().driveNext { text in
//      Async.main(after: 5.0) {
//        print("text = \(text)")
//        self.someValue = text
//        self.textFieldLabel.text = text
//      }
//      
//      }.addDisposableTo(disposeBag)
    
    // Results in exception if view is dismissed before closure attempts to access self
//    textField.rx_text.asDriver().driveNext { [unowned self] text in
//      Async.main(after: 5.0) {
//        print("text = \(text)")
//        self.someValue = text
//        self.textFieldLabel.text = text
//      }
//      
//      }.addDisposableTo(disposeBag)
    
    // weak capture of self allows it to be deinit'd (no strong reference), but closure still fires
    textField.rx_text.asDriver().driveNext { [weak self] text in
      Async.main(after: 5.0) {
        print("text = \(text)")
        
        guard let strongSelf = self else { return }
        
        strongSelf.someValue = text
        strongSelf.textFieldLabel.text = text
      }
      
      }.addDisposableTo(disposeBag)
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  deinit {
    print(__FILE__, __FUNCTION__)
  }
  
}
