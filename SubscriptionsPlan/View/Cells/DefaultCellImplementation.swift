//
//  DefaultCellImplementation.swift
//  SubscriptionsPlan
//
//  Created by Admin on 02.07.2021.
//

import UIKit

class STCell: UITableViewCell {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        addBottomLine()
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addBottomLine()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Bottom Line
    
    private var bottomLineView: UIView?
    
    var isSetBottomLine: Bool = false {
        didSet {
            if isSetBottomLine {
                removeBottomLine()
                addBottomLine()
            } else {
                removeBottomLine()
            }
        }
    }
    
    private func addBottomLine() {
        let bottomLineView = UIView(frame:
                                    CGRect(
                                        x: 18,
                                        y: contentView.frame.size.height-20.0,
                                        width: UIScreen.main.bounds.size.width,
                                        height: 1))
        bottomLineView.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        contentView.addSubview(bottomLineView)
    }
    
    private func removeBottomLine() {
        bottomLineView?.removeFromSuperview()
    }
}
