//
//  SwiftPager.swift
//
//  Created by K S J on 8/3/20.
//  Copyright © 2020 K S J P. All rights reserved.
//

import SwiftUI

public struct Pager<Content: View>: View {
    let numPages: Int
    let content: Content
    
    @State private var index: Int = 0
    @State private var dragAmount: CGFloat = 0
    
    public init(numPages: Int, @ViewBuilder content: () -> Content) {
        self.content = content()
        self.numPages = numPages
    }
    
    public var body: some View {
        ZStack(alignment: .bottom) {
            GeometryReader { geometry in
                HStack(spacing: 0) {
                    self.content
                        .frame(width: geometry.size.width, height: geometry.size.height)
                }
                .contentShape(Rectangle())
                .frame(width: geometry.size.width, alignment: .leading)
                .offset(x: (-CGFloat(index) * geometry.size.width) + self.dragAmount)
                .gesture(
                    DragGesture()
                    .onChanged { value in
                        // detect if you are on the last or first page, and add a log function.
                        let isMovingLeft = value.translation.width > 0
                        let isLeftmost = index == 0
                        let isRightMost = index == numPages - 1
                                                
                        if isMovingLeft && isLeftmost {
                            dragAmount = rubberBandedValue(
                                offset: value.translation.width, dimension: geometry.size.width)
                        } else if !isMovingLeft && isRightMost {
                            // we have to multiply by -1 to make this work
                            dragAmount = -rubberBandedValue(
                                offset: -value.translation.width, dimension: geometry.size.width)
                        } else {
                            dragAmount = value.translation.width
                        }
                    }
                    .onEnded { value in
                        let fractionOfScreen = value.predictedEndTranslation.width / geometry.size.width
                        
                        let newIndex =
                            // moving right
                            fractionOfScreen < -0.5 ?
                            min(index + 1, numPages - 1) :
                            // moving left
                            fractionOfScreen > 0.5 ?
                            max(index - 1, 0) :
                            // do nothing
                            index
                            
                        if (newIndex == index) {
                            // animate back to zero
                            withAnimation(.easeOut(duration: 0.2)){
                                dragAmount = 0
                            }
                        } else {
                            // set to zero and animate the new index
                            withAnimation(spring) {
                                index = newIndex
                                dragAmount = 0
                            }
                        }
                    }
                )
            }
            
            PageIndicator(pages: numPages, currentPage: index)
                .padding(.bottom)
        }
    }
    
    let spring: Animation = .spring(response: 0.3, dampingFraction: 1, blendDuration: 0)

    func rubberBandedValue(offset: CGFloat, dimension: CGFloat) -> CGFloat {
        let inner = (offset * rubberConst / dimension) + 1.0
        return (1.0 - (1.0 / inner)) * dimension
    }
    
    let rubberConst: CGFloat = 0.55
}


struct Pager_Previews: PreviewProvider {
    
    static var previews: some View {
        
        Pager(numPages: 3) {
            Color.blue
            Color.red
            Color.green
        }
    }
}
