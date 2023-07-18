//
//  ButtonEqualHStack.swift
//  RobotController
//
//  Created by Bill Snook on 7/15/23.
//

import SwiftUI

struct ButtonEqualHStack: Layout {
    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        let maxSize = maxSize(subviews: subviews)
        let spacing = spacing(subviews: subviews)
        let totalSpacing = spacing.reduce(0, +)
        return CGSize(width: maxSize.width * CGFloat(subviews.count) + totalSpacing,
                      height: maxSize.height)
    }

    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        let maxSize = maxSize(subviews: subviews)
        let spacing = spacing(subviews: subviews)
        let sizeProposal = ProposedViewSize(width: maxSize.width, height: maxSize.height)
        var x = bounds.minX + maxSize.width / 2
        for index in subviews.indices {
            subviews[index].place(
                at: CGPoint(x: x, y: bounds.midY),
                anchor: .center,
                proposal: sizeProposal)
            x += maxSize.width + spacing[index]
        }
    }

    func maxSize(subviews: Subviews) -> CGSize {
        let subviewSizes = subviews.map{ $0.sizeThatFits(.unspecified) }
        return subviewSizes.reduce(.zero) { currentMax, subviewSize in
            CGSize(
                width: max(currentMax.width, subviewSize.width),
                height: max(currentMax.height, subviewSize.height)
            )
        }
    }

    func spacing(subviews: Subviews) -> [Double] {
        return subviews.indices.map { index in
            guard index < subviews.count - 1 else { return 0.0 }
            return subviews[index].spacing.distance(
                to: subviews[index + 1].spacing,
                along: .horizontal)
        }
    }
}
