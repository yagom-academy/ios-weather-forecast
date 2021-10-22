//
//  CompositionalLayout.swift
//  WeatherForecast
//
//  Created by tae hoon park on 2021/10/18.
//

import UIKit

enum ScrollDirection {
    case horizontal
    case vertical
}

struct CompositionalLayout {
    let scrollDirection: ScrollDirection
    let cellVerticalSize: NSCollectionLayoutDimension
    let headerVerticalSize: NSCollectionLayoutDimension
    
    func create() -> UICollectionViewLayout {
            let layout =
            UICollectionViewCompositionalLayout { (_, _) -> NSCollectionLayoutSection? in
                let section = NSCollectionLayoutSection(
                    group: decidedGroup())
                section.boundarySupplementaryItems = [decidedHeader()]
                
                if  scrollDirection == .horizontal {
                    section.orthogonalScrollingBehavior = .continuous
                }
                
                section.contentInsets =
                NSDirectionalEdgeInsets(top: 0, leading: 5, bottom: 0, trailing: 0)
                return section
            }
            return layout
        }
    
    private func decidedItem() -> NSCollectionLayoutItem {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets =
        NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)
        return item
    }
    
    private func decidedGroup() -> NSCollectionLayoutGroup {
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: cellVerticalSize)
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: groupSize,
            subitem: decidedItem(), count: 1)
        return group
    }
    
    private func decidedHeader() ->
    NSCollectionLayoutBoundarySupplementaryItem {
        let headerSize =
        NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                               heightDimension: headerVerticalSize)
        let header = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: headerSize,
            elementKind: UICollectionView.elementKindSectionHeader,
            alignment: .top)
        return header
    }
}
