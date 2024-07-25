//
//  RandomCVCell.swift
//  Polaroid
//
//  Created by gnksbm on 7/25/24.
//

import UIKit

import Neat
import SnapKit

final class RandomCVCell: BaseCollectionViewCell, RegistrableCellType {
    static func makeRegistration() -> Registration<RandomImage> {
        Registration { cell, indexPath, item in
            if let url = item.imageURL {
                DispatchQueue.global().async { [weak cell] in
                    let imageSourceOptions =
                    [kCGImageSourceShouldCache: false] as CFDictionary
                    let imageSource = CGImageSourceCreateWithURL(
                        url as CFURL,
                        imageSourceOptions
                    )
                    if let imageSource {
                        let cgImage = CGImageSourceCreateThumbnailAtIndex(
                            imageSource,
                            0,
                            imageSourceOptions
                        )
                        if let cgImage {
                            DispatchQueue.main.async {
                                cell?.imageView.image =
                                UIImage(cgImage: cgImage)
                            }
                        }
                    }
                }
            }
        }
    }
    
    private let imageView = UIImageView().nt.configure {
        $0.contentMode(.scaleAspectFill)
    }
    
//
//    private let capsuleView = CapsuleView()
//    
    override func configureLayout() {
        [imageView].forEach {
            contentView.addSubview($0)
        }
        
        let padding = 20.f
        
        imageView.snp.makeConstraints { make in
            make.edges.equalTo(contentView)
        }
    }
}
