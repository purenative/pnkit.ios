import SwiftUI

public struct ShimmerDetailContainer<DetailContent: View>: View {
    private let fromColor: Color
    private let toColor: Color
    private let padding: EdgeInsets
    private let detailContent: () -> DetailContent
    
    public init(
        fromColor: Color,
        toColor: Color,
        padding: EdgeInsets = EdgeInsets(top: 16, leading: 16, bottom: 16, trailing: 16),
        @ViewBuilder detailContent: @escaping () -> DetailContent
    ) {
        self.fromColor = fromColor
        self.toColor = toColor
        self.padding = padding
        self.detailContent = detailContent
    }
    
    public var body: some View {
        Color.clear
            .overlay(alignment: .top) {
                detailContent()
                    .shimmering(
                        fromColor: fromColor,
                        toColor: toColor
                    )
            }
            .padding(padding)
    }
}
