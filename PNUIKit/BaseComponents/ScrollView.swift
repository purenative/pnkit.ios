import SwiftUI

public class ScrollViewState: ObservableObject {
    private var isEndReached = false
    
    private let onEndReached: () -> Void
    
    public init(onEndReached: @escaping () -> Void = { }) {
        self.onEndReached = onEndReached
    }
    
    @MainActor
    fileprivate func handlePreferenceChange(
        value: SmartScrollStatePreferenceKey.Value,
        scrollGeometry: GeometryProxy
    ) {
        let newState = SmartScrollState(
            frameSize: scrollGeometry.size,
            contentOffset: CGPoint(x: -value.contentOffset.x, y: -value.contentOffset.y),
            contentSize: value.contentSize
        )
        let isEndReachedNow = newState.isEndReached
        guard isEndReached != isEndReachedNow else { return }
        isEndReached = isEndReachedNow
        onEndReached()
    }
}
    
public struct ScrollView<Content: View>: View {
    @ObservedObject
    private var state: ScrollViewState
    
    private let coordinateSpaceName = UUID()
    
    private let axes: Axis.Set
    private let showsIndicators: Bool
    private let content: () -> Content
    
    public init(
        state: ScrollViewState,
        axes: Axis.Set = .vertical,
        showsIndicators: Bool = true,
        @ViewBuilder content: @escaping () -> Content
    ) {
        _state = .init(wrappedValue: state)
        
        self.axes = axes
        self.showsIndicators = showsIndicators
        self.content = content
    }
    
    public var body: some View {
        GeometryReader { scrollGeometry in
            SwiftUI.ScrollView(axes, showsIndicators: showsIndicators) {
                content()
                    .background(GeometryReader { contentGeometry in
                        Color.clear.preference(
                            key: SmartScrollStatePreferenceKey.self,
                            value: SmartScrollStatePreferenceKey.Value(
                                contentOffset: contentGeometry.frame(in: .named(coordinateSpaceName)).origin,
                                contentSize: contentGeometry.size
                            )
                        )
                    })
            }
            .coordinateSpace(name: coordinateSpaceName)
            .onPreferenceChange(SmartScrollStatePreferenceKey.self, perform: { value in
                state.handlePreferenceChange(
                    value: value,
                    scrollGeometry: scrollGeometry
                )
            })
        }
    }
}

fileprivate struct SmartScrollState {
    let frameSize: CGSize
    let contentOffset: CGPoint
    let contentSize: CGSize
    
    var isEndReached: Bool {
        contentSize.height > 0 && contentOffset.y >= contentSize.height - frameSize.height
    }
}

fileprivate struct SmartScrollStatePreferenceKey: PreferenceKey {
    struct Value: Equatable {
        let contentOffset: CGPoint
        let contentSize: CGSize
        
        init(contentOffset: CGPoint, contentSize: CGSize) {
            self.contentOffset = contentOffset
            self.contentSize = contentSize
        }
        
        static var zero: Value {
            Value(contentOffset: .zero, contentSize: .zero)
        }
    }
    
    static let defaultValue: Value = .zero
    
    static func reduce(value: inout Value, nextValue: () -> Value) { }
}
