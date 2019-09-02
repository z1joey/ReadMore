//
//  ViewController.swift
//  ReadMore
//
//  Created by joey on 8/30/19.
//  Copyright © 2019 TGI Technology. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var someLabel: UILabel! {
        didSet {
            someLabel.text = fullText
        }
    }

    fileprivate let fullText = "This style guide is based on Apple’s excellent Swift standard library style and also incorporates feedback from usage across multiple Swift projects within Google. It is a living document and the basis upon which the formatter is implemented."

    fileprivate var isFullTextShown: Bool = false {
        didSet {
            if isFullTextShown {
                showFullText()
            } else {
                showSomeText()
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        showSomeText()
    }

    fileprivate func showSomeText() {
        someLabel.numberOfLines = 3
        if let text = someLabel.text, text.count > 1 {
            let readmoreFont = UIFont.systemFont(ofSize: 12)
            let readmoreFontColor = UIColor.blue
            DispatchQueue.main.async {
                self.someLabel.addTrailing(with: "...", moreText: "Readmore", moreTextFont: readmoreFont, moreTextColor: readmoreFontColor)
            }
            let readMoreGesture = UITapGestureRecognizer(target: self, action: #selector(labelAction))
            readMoreGesture.numberOfTapsRequired = 1
            someLabel.addGestureRecognizer(readMoreGesture)
        }
    }

    fileprivate func showFullText() {
        self.someLabel.numberOfLines = 0
        self.someLabel.text = fullText
        self.someLabel.sizeToFit()
    }

    @objc func labelAction() {
        isFullTextShown = isFullTextShown ? false : true
    }

}

extension UILabel{

    func addTrailing(with trailingText: String, moreText: String, moreTextFont: UIFont, moreTextColor: UIColor) {

        let readMoreText: String = trailingText + moreText

        if let myText = self.text, self.visibleTextLength > 0 {
            let lengthForVisibleString: Int = self.visibleTextLength
            let mutableString: String = myText
            let trimmedString: String? = (mutableString as NSString).replacingCharacters(in: NSRange(location: lengthForVisibleString, length: myText.count - lengthForVisibleString), with: "")
            let readMoreLength: Int = (readMoreText.count)

            if let safeTrimmedString = trimmedString, safeTrimmedString.count > readMoreLength {
                let trimmedForReadMore: String = (safeTrimmedString as NSString).replacingCharacters(in: NSRange(location: safeTrimmedString.count - readMoreLength, length: readMoreLength), with: "") + trailingText
                let answerAttributed = NSMutableAttributedString(string: trimmedForReadMore, attributes: [NSAttributedString.Key.font: self.font])
                let readMoreAttributed = NSMutableAttributedString(string: moreText, attributes: [NSAttributedString.Key.font: moreTextFont, NSAttributedString.Key.foregroundColor: moreTextColor])
                answerAttributed.append(readMoreAttributed)
                self.attributedText = answerAttributed
            }
        }
    }

    var visibleTextLength: Int {

        let font: UIFont = self.font
        let mode: NSLineBreakMode = self.lineBreakMode
        let labelWidth: CGFloat = self.frame.size.width
        let labelHeight: CGFloat = self.frame.size.height
        let sizeConstraint = CGSize(width: labelWidth, height: CGFloat.greatestFiniteMagnitude)

        if let myText = self.text {

            let attributes: [AnyHashable: Any] = [NSAttributedString.Key.font: font]
            let attributedText = NSAttributedString(string: myText, attributes: attributes as? [NSAttributedString.Key : Any])
            let boundingRect: CGRect = attributedText.boundingRect(with: sizeConstraint, options: .usesLineFragmentOrigin, context: nil)

            if boundingRect.size.height > labelHeight {
                var index: Int = 0
                var prev: Int = 0
                let characterSet = CharacterSet.whitespacesAndNewlines
                repeat {
                    prev = index
                    if mode == NSLineBreakMode.byCharWrapping {
                        index += 1
                    } else {
                        index = (myText as NSString).rangeOfCharacter(from: characterSet, options: [], range: NSRange(location: index + 1, length: myText.count - index - 1)).location
                    }
                } while index != NSNotFound && index < myText.count && (myText as NSString).substring(to: index).boundingRect(with: sizeConstraint, options: .usesLineFragmentOrigin, attributes: attributes as? [NSAttributedString.Key : Any], context: nil).size.height <= labelHeight
                return prev
            }
        }

        if self.text == nil {
            return 0
        } else {
            return self.text!.count
        }
    }
}