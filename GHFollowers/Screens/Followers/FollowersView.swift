//
//  FollowersView.swift
//  GHFollowers
//
//  Created by Wouter Willebrands on 01/03/2022.
//  Copyright © 2022 CodingCondor. All rights reserved.
//

import UIKit

protocol FollowersViewDelegate: AnyObject {
    func didScrollToEnd()
    func didTapFollower(at indexPath: IndexPath)
    func hideSearchBar(_ hidesSearchBarWhenScrolling: Bool)
}

final class FollowersView: UIView {
    weak var delegate: FollowersViewDelegate?
    
    lazy var followersCollectionView = UICollectionView(frame: .zero, collectionViewLayout: createCollectionViewFlowLayout())
    
    private let padding: CGFloat = 16
    private let cellsPerSection: CGFloat = 4
    private let cellSpacing: CGFloat = 8
    private var lastScrollPosition: CGFloat = 0

    override init(frame: CGRect) {
        super.init(frame: frame)
        configureView()
        configureViewContent()
        layoutViewContent()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func configureView() {
        backgroundColor = UIColor.systemBackground
    }
    
    private func configureViewContent() {
        followersCollectionView.backgroundColor = UIColor.systemYellow
        followersCollectionView.register(FollowerCell.self, forCellWithReuseIdentifier: FollowerCell.identifier)
        followersCollectionView.delegate = self
        followersCollectionView.showsHorizontalScrollIndicator = false
        followersCollectionView.showsVerticalScrollIndicator = false
    }
    
    private func layoutViewContent() {
        addSubviews(followersCollectionView)
        
        NSLayoutConstraint.activate([
            followersCollectionView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            followersCollectionView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: padding),
            followersCollectionView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -padding),
            followersCollectionView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),
        ])
    }
    
    private func createCollectionViewFlowLayout() -> UICollectionViewFlowLayout {
        let availableWidth = bounds.width - ((cellsPerSection - 1) * cellSpacing)
        let cellWidth = availableWidth / (cellsPerSection)
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.minimumInteritemSpacing = 0
        flowLayout.minimumLineSpacing = 0
        flowLayout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        flowLayout.itemSize = CGSize(width: cellWidth, height: cellWidth)
        return flowLayout
    }
    
//    let width                        = view.bounds.width
//    let padding: CGFloat             = 12
//    let minimumItemSpacing: CGFloat  = 10
//    let availableWidth               = width - (padding * 2) - (minimumItemSpacing * 2)
//    let itemWidth                    = availableWidth / 3
//    let flowLayout                   = UICollectionViewFlowLayout()
//    flowLayout.sectionInset          = UIEdgeInsets(top: padding, left: padding, bottom: padding, right: padding)
//    flowLayout.itemSize              = CGSize(width: itemWidth, height: itemWidth + 40)
}

extension FollowersView: UICollectionViewDelegate {
    /// When user scrolls all the way towards the bottom of the scrollView a request will be made for the next followers-l
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let screenHeight = scrollView.frame.size.height
        
        if offsetY > contentHeight - screenHeight {
            delegate?.didScrollToEnd()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.didTapFollower(at: indexPath)
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        lastScrollPosition = scrollView.contentOffset.y
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if lastScrollPosition < scrollView.contentOffset.y {
            delegate?.hideSearchBar(true)
        } else if lastScrollPosition > scrollView.contentOffset.y {
            delegate?.hideSearchBar(false)
        }
    }
}
