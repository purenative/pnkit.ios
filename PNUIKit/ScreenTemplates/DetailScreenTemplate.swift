import SwiftUI

public struct DetailScreenTemplate<
    Model,
    DetailContent: View,
    ShimmerContent: View,
    ErrorContent: View
>: View {
    @StateObject
    private var scrollViewState = ScrollViewState()
    
    private let isScrollable: Bool
    private let padding: EdgeInsets
    
    @Binding
    private var isLoading: Bool
    @Binding
    private var model: Model?
    @Binding
    private var error: String
    
    private let detailBuilder: (Model) -> DetailContent
    private let shimmerBuilder: () -> ShimmerContent
    private let errorBuilder: (String) -> ErrorContent
    
    public init(
        isScrollable: Bool,
        padding: EdgeInsets = EdgeInsets(top: 16, leading: 16, bottom: 16, trailing: 16),
        
        isLoading: Binding<Bool> = .constant(false),
        model: Binding<Model?>,
        error: Binding<String> = .constant(""),
        
        detailBuilder: @escaping (Model) -> DetailContent,
        shimmerBuilder: @escaping () -> ShimmerContent,
        errorBuilder: @escaping (String) -> ErrorContent = { _ in EmptyView() }
    ) {
        self.isScrollable = isScrollable
        self.padding = padding
        
        _isLoading = isLoading
        _model = model
        _error = error
        
        self.detailBuilder = detailBuilder
        self.shimmerBuilder = shimmerBuilder
        self.errorBuilder = errorBuilder
    }
    
    public var body: some View {
        if error.isEmpty {
            if isLoading {
                shimmerBuilder()
            } else if let model {
                buildContentSurface {
                    detailBuilder(model)
                        .padding(padding)
                }
            }
        } else {
            errorBuilder(error)
        }
    }
    
    @ViewBuilder
    private func buildContentSurface<Content: View>(@ViewBuilder content: @escaping () -> Content) -> some View {
        if isScrollable {
            ScrollView(state: scrollViewState) {
                content()
            }
        } else {
            content()
        }
    }
}
