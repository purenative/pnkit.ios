import SwiftUI

extension View {
    public func asAny() -> AnyView {
        AnyView(self)
    }
}
