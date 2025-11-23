import SwiftUI

public struct ShimmerListContainer<
    TopContent: View,
    ItemContent: View,
    SeparatorContent: View
>: View {
    private let contentColor: Color
    private let highlightColor: Color
    private let itemsCount: Int
    private let spacing: CGFloat
    private let padding: EdgeInsets
    
    @ViewBuilder
    private let topContent: () -> TopContent
    @ViewBuilder
    private let itemContnet: () -> ItemContent
    @ViewBuilder
    private let separatorContent: () -> SeparatorContent
    
    public init(
        contentColor: Color,
        highlightColor: Color,
        itemsCount: Int,
        spacing: CGFloat = 16,
        padding: EdgeInsets = EdgeInsets(top: 16, leading: 16, bottom: 16, trailing: 16),
        topContent: @escaping () -> TopContent = { EmptyView() },
        itemContnet: @escaping () -> ItemContent,
        separatorContent: @escaping () -> SeparatorContent = { EmptyView() }
    ) {
        self.contentColor = contentColor
        self.highlightColor = highlightColor
        self.itemsCount = itemsCount
        self.spacing = spacing
        self.padding = padding
        self.topContent = topContent
        self.itemContnet = itemContnet
        self.separatorContent = separatorContent
    }
    
    public var body: some View {
        Color.clear
            .overlay(alignment: .top) {
                VStack(spacing: spacing) {
                    topContent()
                    
                    let indices = 0..<itemsCount
                    ForEach(indices, id: \.self) { index in
                        itemContnet()
                        
                        if index != indices.last {
                            separatorContent()
                        }
                    }
                }
                .padding(padding)
                .shimmering(
                    contentColor: contentColor,
                    highlightColor: highlightColor
                )
            }
    }
}
