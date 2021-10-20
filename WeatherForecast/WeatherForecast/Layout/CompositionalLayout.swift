//
//  CompositionalLayout.swift
//  WeatherForecast
//
//  Created by tae hoon park on 2021/10/18.
//

import UIKit

struct CompositionalLayout {
    func create(
        contents: CompositionalLayoutProtocol) -> UICollectionViewLayout {
            var horizontalNumber: Int {
                UIDevice.current.orientation.isLandscape ?
                contents.landscapeHorizontalNumber.value :
                contents.portraitHorizontalNumber.value
            }
            
            let layout =
            UICollectionViewCompositionalLayout { (_, _) -> NSCollectionLayoutSection? in
                let section = NSCollectionLayoutSection(
                    group: decidedGroup(contents: contents, horizontalNumber: horizontalNumber))
                section.boundarySupplementaryItems = [decidedHeader(contents: contents)]
                
                if contents.scrollDirection == .horizontal {
                    section.orthogonalScrollingBehavior = .continuous
                }
                
                section.contentInsets = contents.viewMargin?.value
                ?? NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)
                return section
            }
            return layout
        }
    
    private func decidedItem(contents: CompositionalLayoutProtocol) -> NSCollectionLayoutItem {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = contents.cellMargin?.value
        ?? NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)
        return item
    }
    
    private func decidedGroup(contents: CompositionalLayoutProtocol,
                              horizontalNumber: Int) -> NSCollectionLayoutGroup {
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: contents.cellVerticalSize.value)
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: groupSize,
            subitem: decidedItem(contents: contents), count: horizontalNumber)
        return group
    }
    
    private func decidedHeader(contents: CompositionalLayoutProtocol) ->
    NSCollectionLayoutBoundarySupplementaryItem {
        let headerSize =
        NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                               heightDimension: contents.headerVerticalSize.value)
        let header = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: headerSize,
            elementKind: UICollectionView.elementKindSectionHeader,
            alignment: .top)
        return header
    }
}
