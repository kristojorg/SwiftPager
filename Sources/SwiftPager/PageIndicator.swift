//
//  PageIndicator.swift
//  Spin
//
//  Created by K S J on 8/9/20.
//  Copyright © 2020 K S J P. All rights reserved.
//

import SwiftUI

struct PageIndicator: View {
    let pages: Int
    let currentPage: Int
    
    var body: some View {
        HStack {
            ForEach(0..<pages){ index in
                Circle()
                    .foregroundColor(currentPage == index ? activeColor : inactiveColor)
                    .animation(.easeInOut)
                    .frame(width: radius, height: radius)
            }
        }
        .padding(.all, padding)
        .background(backgroundColor)
        .cornerRadius(paddingRadius)
    }
    
    let activeColor = Color(UIColor.white)
    let inactiveColor: Color = Color(UIColor.systemGray4)
    let radius: CGFloat = 8

    let backgroundColor = Color(UIColor.systemGray2)
    let padding: CGFloat = 6.0
    let paddingRadius: CGFloat = 16.0
}

struct PageIndicator_Previews: PreviewProvider {
    static var previews: some View {
        PageIndicator(pages: 3, currentPage: 2)
    }
}
