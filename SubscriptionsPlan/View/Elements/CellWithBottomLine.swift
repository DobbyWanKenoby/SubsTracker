//
//  CellWithBottomLine.swift
//  SubscriptionsPlan
//
//  Created by Vasily Usov on 05.01.2021.
//

import UIKit


// Ячейка с линией в самом низу
class CellWithBottomLine: UITableViewCell {
    var isSetBottomLine: Bool = false {
        didSet {
            if isSetBottomLine {
                self.viewWithTag(tagIdentifier)?.removeFromSuperview()
                addBottomLine()
            } else {
                
            }
        }
    }
    
    private var tagIdentifier: Int = 789
    
    private func addBottomLine() {
        let bottomLine = UIView(frame:
                                    CGRect(
                                        x: 19,
                                        y: contentView.frame.size.height-20.0,
                                        width: UIScreen.main.bounds.size.width,
                                        height: 1))
        bottomLine.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        bottomLine.tag = tagIdentifier
        contentView.addSubview(bottomLine)
    }
    
    private func removeBottomLine() {
        contentView.viewWithTag(tagIdentifier)?.removeFromSuperview()
    }
}
