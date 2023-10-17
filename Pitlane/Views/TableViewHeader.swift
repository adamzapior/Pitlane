//
//  TableViewHeader.swift
//  Pitlane
//
//  Created by Adam Zapiór on 17/10/2023.
//

import SnapKit
import UIKit

class TableViewHeader: UIView {
    let segmentedControl: UISegmentedControl = {
        let standingType = ["Drivers", "Constructors"]
        let sc = UISegmentedControl(items: standingType)
        return sc
    }()
    

    var standingTypeChanged: ((UISegmentedControl) -> Void)?

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

//    override func layoutSubviews() {
//        super.layoutSubviews()
//
//        let height = systemLayoutSizeFitting(UIView.layoutFittingCompressedSize).height
//        if frame.size.height != height {
//            var newFrame = frame
//            newFrame.size.height = height
//            frame = newFrame
//        }
//    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        addSubview(segmentedControl)
        segmentedControl.snp.makeConstraints { make in
                make.top.equalToSuperview().offset(10)
                make.centerX.equalToSuperview()
                make.width.equalTo(300)
            }

        segmentedControl.addTarget(self, action: #selector(standingTypeDidChange(_:)), for: .valueChanged)
        segmentedControl.selectedSegmentIndex = 0

    }

    @objc private func standingTypeDidChange(_ sender: UISegmentedControl) {
        standingTypeChanged?(sender)
    }
}
