//
//  ReadMoreLabel.swift
//  ReadMore
//
//  Created by joey on 9/2/19.
//  Copyright © 2019 TGI Technology. All rights reserved.
//

import UIKit

// MARK: - Class
class ReadMoreLabel: UILabel {

    fileprivate var _fullText: String?
    fileprivate var _readmoreFont: UIFont?

    var numberOfLinesForSomeText: Int = 3
    var readmoreFontColor = UIColor(red: 246/255, green: 90/255, blue: 92/255, alpha: 1)

    var fullText: String? {
        get {
            return _fullText
        }
        set {
            _fullText = newValue
            text = newValue
        }
    }

    var readmoreFont: UIFont {
        get {
            if let font = _readmoreFont {
                return font
            } else {
                return self.font
            }
        }
        set {
            _readmoreFont = newValue
        }
    }

    var isFullTextShown: Bool = false {
        didSet {
            if isFullTextShown {
                showFullText()
            } else {
                showSomeText()
            }
        }
    }
}

// MARK: - Helpers
fileprivate extension ReadMoreLabel {
    func showSomeText() {
        self.numberOfLines = numberOfLinesForSomeText
        if let text = self.text, text.count > 1 {
            DispatchQueue.main.async {
                self.addTrailing(with: "...", moreText: "Readmore", moreTextFont: self.readmoreFont, moreTextColor: self.readmoreFontColor)
            }
        }
    }

    func showFullText() {
        self.numberOfLines = 0
        self.text = fullText
        self.sizeToFit()
    }
}

// MARK: - UILabel
fileprivate extension UILabel{

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

