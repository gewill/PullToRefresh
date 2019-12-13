//
//  CustomRefreshView.swift
//  PullToRefreshDemo
//
//  Created by Will on 02/12/2019.
//  Copyright © 2019 Yalantis. All rights reserved.
//

import PullToRefresh
import SnapKit
import UIKit

class CustomRefreshView: UIView {
    // MARK: - properties

    @IBOutlet private var containerView: UIView!
    @IBOutlet var titleLabel: UILabel!

    // MARK: - life cycle

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupViews()
    }

    private func setupViews() {
        Bundle.main.loadNibNamed("CustomRefreshView", owner: self, options: nil)
        addSubview(containerView)
        containerView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        setupFrame(in: superview)
    }

    override func willMove(toSuperview newSuperview: UIView?) {
        super.willMove(toSuperview: newSuperview)

        setupFrame(in: superview)
    }

    func setupFrame(in newSuperview: UIView?) {
        guard let superview = newSuperview else { return }

        frame = CGRect(x: frame.origin.x, y: frame.origin.y, width: superview.frame.width, height: frame.height)
    }
}

class CustomAnimator: RefreshViewAnimator {
    private let refreshView: CustomRefreshView

    init(refreshView: CustomRefreshView) {
        self.refreshView = refreshView
    }

    func animate(_ state: State) {
        // animate refreshView according to state
        switch state {
        case .initial: // do inital layout for elements
            refreshView.titleLabel.text = "initial"
        case let .releasing(progress): // animate elements according to progress
            refreshView.titleLabel.text = "releasing\(progress)"
        case .loading: // start loading animations
            refreshView.titleLabel.text = "loading"
        case .finished: // show some finished state if needed
            refreshView.titleLabel.text = "finished"
        }
    }
}

class CustomPullToRefresh: PullToRefresh {
    convenience init(height: CGFloat = 40, thePosition: Position) {
        let refreshView = CustomRefreshView()
        let animator = CustomAnimator(refreshView: refreshView)
        refreshView.autoresizingMask = [.flexibleWidth]
        refreshView.frame.size.height = height
        self.init(refreshView: refreshView, animator: animator, height: height, position: thePosition)
    }
}
