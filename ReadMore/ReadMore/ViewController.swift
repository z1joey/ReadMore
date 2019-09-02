//
//  ViewController.swift
//  ReadMore
//
//  Created by joey on 8/30/19.
//  Copyright © 2019 TGI Technology. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var someLabel: ReadMoreLabel! {
        didSet {
            someLabel.fullText = fullText
            someLabel.numberOfLinesForSomeText = 2
        }
    }

    fileprivate let fullText = "This style guide is based on Apple’s excellent Swift standard library style and also incorporates feedback from usage across multiple Swift projects within Google. It is a living document and the basis upon which the formatter is implemented."

    override func viewDidLoad() {
        someLabel.isFullTextShown = false
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        someLabel.isFullTextShown = someLabel.isFullTextShown ? false : true
    }
}
