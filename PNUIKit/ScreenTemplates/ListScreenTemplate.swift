import SwiftUI

public struct ListScreenTemplate<
        Model: Identifiable,
        TopContent: View,
        ItemContent: View,
        SeparatorContent: View,
        ShimmerContent: View,
        LoaderContent: View,
        ErrorContent: View
>: View {
    @StateObject
    private var scrollViewState: ScrollViewState
    
    private let isLazy: Bool
    private let spacing: CGFloat
    private let padding: EdgeInsets
    
    @Binding
    private var isLoading: Bool
    @Binding
    private var models: [Model]
    @Binding
    private var error: String
    
    private let isItemTappable: (Model) -> Bool
    private let onItemTapped: (Model) -> Void
    
    private let topBuilder: () -> TopContent
    private let itemBuilder: (Model) -> ItemContent
    private let separatorBuilder: () -> SeparatorContent
    private let shimmerBuilder: () -> ShimmerContent
    private let loaderBuilder: () -> LoaderContent
    private let errorBuilder: (String) -> ErrorContent
    
    private var needShowShimmer: Bool {
        isLoading && models.isEmpty
    }
    
    private var needShowNextPageLoader: Bool {
        isLoading && !models.isEmpty
    }
    
    public init(
        isLazy: Bool,
        spacing: CGFloat = 16,
        padding: EdgeInsets = EdgeInsets(top: 16, leading: 16, bottom: 16, trailing: 16),
        
        isLoading: Binding<Bool>,
        models: Binding<[Model]>,
        error: Binding<String> = .constant(""),
        
        isItemTappable: @escaping (Model) -> Bool = { _ in true },
        onItemTapped: @escaping (Model) -> Void = { _ in },
        onEndReached: @escaping () -> Void = { },
        
        @ViewBuilder topBuilder: @escaping () -> TopContent = { EmptyView() },
        @ViewBuilder itemBuilder: @escaping (Model) -> ItemContent,
        @ViewBuilder separatorBuilder: @escaping () -> SeparatorContent = { EmptyView() },
        @ViewBuilder shimmerBuilder: @escaping () -> ShimmerContent = { EmptyView() },
        @ViewBuilder loaderBuilder: @escaping () -> LoaderContent = { EmptyView() },
        @ViewBuilder errorBuilder: @escaping (String) -> ErrorContent = { _ in EmptyView() }
    ) {
        _scrollViewState = .init(wrappedValue: .init(onEndReached: onEndReached))
        
        self.isLazy = isLazy
        self.spacing = spacing
        self.padding = padding
        
        _isLoading = isLoading
        _models = models
        _error = error
        
        self.isItemTappable = isItemTappable
        self.onItemTapped = onItemTapped
        
        self.topBuilder = topBuilder
        self.itemBuilder = itemBuilder
        self.separatorBuilder = separatorBuilder
        self.shimmerBuilder = shimmerBuilder
        self.loaderBuilder = loaderBuilder
        self.errorBuilder = errorBuilder
    }
    
    public var body: some View {
        if error.isEmpty {
            if needShowShimmer {
                shimmerBuilder()
            } else {
                buildMainContent()
            }
        } else {
            errorBuilder(error)
        }
    }
    
    @ViewBuilder
    private func buildMainContent() -> some View {
        ZStack {
            if needShowShimmer {
                loaderBuilder()
            } else {
                ScrollViewReader { scrollProxy in
                    ScrollView(state: scrollViewState) {
                        buildStack {
                            topBuilder()
                            
                            buildListContent()
                            
                            if needShowNextPageLoader {
                                loaderBuilder()
                                    .frame(height: 30)
                            } else {
                                Color.clear
                                    .frame(height: 30)
                            }
                        }
                        .padding(padding)
                    }
                }
            }
        }
    }
    
    @ViewBuilder
    private func buildStack<Content: View>(@ViewBuilder content: () -> Content) -> some View {
        if isLazy {
            LazyVStack(
                spacing: spacing,
                content: content
            )
        } else {
            VStack(
                spacing: spacing,
                content: content
            )
        }
    }
    
    @ViewBuilder
    private func buildListContent() -> some View {
        ForEach(models) { model in
            itemBuilder(model)
                .onTapped(
                    isEnabled: isItemTappable(model),
                    { onItemTapped(model) }
                )
            
            if models.last?.id != model.id {
                separatorBuilder()
            }
        }
    }
}
