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
        containerView.frame = CGRect(x: 0, y: 0, width: 375, height: 40)
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

class Animator: RefreshViewAnimator {
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

class AwesomePullToRefresh: PullToRefresh {
    convenience init() {
        let refreshView = CustomRefreshView()
        let animator = Animator(refreshView: refreshView)
//        refreshView.translatesAutoresizingMaskIntoConstraints = false
//        refreshView.autoresizingMask = [.flexibleWidth]
        refreshView.frame.size.height = 40
        self.init(refreshView: refreshView, animator: animator, height: 40, position: .top)
    }
}
