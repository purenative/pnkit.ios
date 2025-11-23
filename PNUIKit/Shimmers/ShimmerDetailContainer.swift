import SwiftUI

public struct ShimmerDetailContainer<DetailContent: View>: View {
    private let contentColor: Color
    private let highlightColor: Color
    private let padding: EdgeInsets
    private let detailContent: () -> DetailContent
    
    public init(
        contentColor: Color,
        highlightColor: Color,
        padding: EdgeInsets = EdgeInsets(top: 16, leading: 16, bottom: 16, trailing: 16),
        @ViewBuilder detailContent: @escaping () -> DetailContent
    ) {
        self.contentColor = contentColor
        self.highlightColor = highlightColor
        self.padding = padding
        self.detailContent = detailContent
    }
    
    public var body: some View {
        Color.clear
            .overlay(alignment: .top) {
                detailContent()
                    .shimmering(
                        contentColor: contentColor,
                        highlightColor: highlightColor
                    )
            }
            .padding(padding)
    }
}
