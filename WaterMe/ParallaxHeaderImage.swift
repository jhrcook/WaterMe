//
//  ParallaxHeaderImage.swift
//  WaterMe
//
//  Created by Joshua on 7/13/20.
//  Copyright © 2020 Joshua Cook. All rights reserved.
//

import SwiftUI


struct ParallaxHeaderImage: View {
    
    @Binding var image: Image
    
    var outerGeoSize: CGSize
    var outerGeoFrame: CGRect
    
    var innerGeoSize: CGSize
    var innerGeoFrame: CGRect
    
    let distanceBeforeStartingBlur: CGFloat = 50
    let rateOfBlurOnset: CGFloat = 0.1
    let heightOfImageWithRespectToOuterGeoHeight: CGFloat = 0.5
    
    var body: some View {
        ZStack {
            if topOfImageOffset <= 0 {
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: outerGeoSize.width, height: outerGeoSize.height * heightOfImageWithRespectToOuterGeoHeight)
                    .offset(y: -topOfImageOffset)
            } else {
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: outerGeoSize.width, height: outerGeoSize.height * heightOfImageWithRespectToOuterGeoHeight + (topOfImageOffset))
                    .clipped()
                    .blur(radius: topOfImageOffset < distanceBeforeStartingBlur ? 0 : (topOfImageOffset - distanceBeforeStartingBlur) * rateOfBlurOnset, opaque: true)
                    .offset(y: -topOfImageOffset)
            }
        }
    }
    
    var topOfImageOffset: CGFloat {
        innerGeoFrame.minY - outerGeoFrame.minY
    }
}
