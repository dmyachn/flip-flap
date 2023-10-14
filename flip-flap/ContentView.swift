//
//  ContentView.swift
//  flip-flap
//
//  Created by Dmitiy Myachin on 14.10.2023.
//

import SwiftUI

struct ContentView: View {
    var ResizableRect: some View {
        return Rectangle()
            .clipShape(.rect(cornerRadius: 7, style: .continuous))
            .scaledToFit()
            .foregroundColor(.cyan)
    }
    
    
    var count = 6
    @State var isVertical = false
    
    var body: some View {
        let layout = isVertical ? AnyLayout(SlashStack(spacing: 20)) : AnyLayout(HStackLayout(spacing: 20))
        
        layout{
            ForEach(0..<count, id: \.self) { index in
                ResizableRect
                    .onTapGesture {
                        withAnimation(.easeInOut) {
                            isVertical.toggle()
                        }
                    }
            }
        }
    }
}

struct SlashStack: Layout {
    var spacing: CGFloat = 10
    
    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        proposal.replacingUnspecifiedDimensions()
    }
    
    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        var x = bounds.minX
        var y = bounds.maxY
        
        for index in subviews.indices {
            
            let rectSize =  (max(proposal.replacingUnspecifiedDimensions().height, proposal.replacingUnspecifiedDimensions().width) - spacing * CGFloat(subviews.count - 1)) / CGFloat(subviews.count)
            
            let sizeProposal = ProposedViewSize(
                width: rectSize,
                height: rectSize)
            
            subviews[index]
                .place(
                    at: CGPoint(x: x, y: y),
                    anchor: .bottomLeading,
                    proposal: sizeProposal
                )
            if proposal.replacingUnspecifiedDimensions().height > proposal.replacingUnspecifiedDimensions().width {
                x += rectSize - (proposal.replacingUnspecifiedDimensions().height - proposal.replacingUnspecifiedDimensions().width) / CGFloat(subviews.count - 1) + spacing
                y -= rectSize + spacing
            } else {
                x += rectSize + spacing
                y -= rectSize - (proposal.replacingUnspecifiedDimensions().width - proposal.replacingUnspecifiedDimensions().height) / CGFloat(subviews.count - 1) + spacing
            }
        }
    }
}

#Preview {
    ContentView()
}
