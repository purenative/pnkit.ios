import SwiftUI

public struct AuthFormScreenGeometryProxy {
    public let isKeyboardOpened: Bool
    public let focusedFieldBinding: FocusState<AnyHashable?>.Binding
}
    
public struct AuthFormScreenTemplate<
    Field: Hashable & Identifiable,
    HeaderContent: View,
    FieldContent: View,
    FooterContent: View
>: View {
    @StateObject
    private var keyboardState = KeyboardState()
    @FocusState
    private var focusedField: AnyHashable?
    @State
    private var currentContentHeight: CGFloat
    @State
    private var formOffsetY: CGFloat?
    @State
    private var isAppeared = false
    
    private let fields: [Field]
    private let spacing: CGFloat
    private let padding: EdgeInsets
    private let headerContent: ((AuthFormScreenGeometryProxy) -> HeaderContent)?
    private let fieldContent: (Field) -> FieldContent
    private let footerContent: ((AuthFormScreenGeometryProxy) -> FooterContent)?
    
    public init(
        fields: [Field],
        spacing: CGFloat = 16,
        padding: EdgeInsets = EdgeInsets(top: 16, leading: 16, bottom: 16, trailing: 16),
        initialContentHeight: CGFloat? = nil,
        @ViewBuilder headerContent: @escaping (AuthFormScreenGeometryProxy) -> HeaderContent,
        @ViewBuilder fieldContent: @escaping (Field) -> FieldContent,
        @ViewBuilder footerContent: @escaping (AuthFormScreenGeometryProxy) -> FooterContent
    ) {
        self.fields = fields
        self.spacing = spacing
        self.padding = padding
        currentContentHeight = initialContentHeight ?? .zero
        self.headerContent = headerContent
        self.fieldContent = fieldContent
        self.footerContent = footerContent
    }
    
    public var body: some View {
        GeometryReader { proxy in
            let pageGeometry = AuthFormScreenGeometryProxy(
                isKeyboardOpened: keyboardState.isOpened,
                focusedFieldBinding: $focusedField,
            )
            
            let formOffsetY = formOffsetY ?? calculateFormOffsetY(
                isKeyboardOpened: pageGeometry.isKeyboardOpened,
                currentContentHeight: currentContentHeight,
                containerSize: proxy.size
            )
            
            VStack(spacing: spacing) {
                if let headerContent {
                    headerContent(pageGeometry)
                }
                
                ForEach(fields) { field in
                    fieldContent(field)
                        .id(field)
                        .focused($focusedField, equals: field)
                }
                
                if let footerContent {
                    footerContent(pageGeometry)
                }
            }
            .padding(padding)
            .writeViewHeight(to: $currentContentHeight)
            .offset(y: formOffsetY)
            .onReceive(keyboardState.$height, perform: { keyboardHeight in
                updateFormOffsetY(
                    isKeyboardOpened: keyboardHeight > .zero,
                    currentContentHeight: currentContentHeight,
                    containerSize: proxy.size
                )
            })
            .onChange(of: currentContentHeight, perform: { newContentHeight in
                updateFormOffsetY(
                    isKeyboardOpened: pageGeometry.isKeyboardOpened,
                    currentContentHeight: newContentHeight,
                    containerSize: proxy.size
                )
            })
        }
        .transaction({
            if (isAppeared) {
                $0.animation = keyboardState.animation
            }
        })
        .onAppear(perform: { isAppeared = true })
        .onDisappear(perform: { isAppeared = false })
    }
    
    private func calculateFormOffsetY(
        isKeyboardOpened: Bool,
        currentContentHeight: CGFloat,
        containerSize: CGSize
    ) -> CGFloat {
        if isAppeared && isKeyboardOpened {
            (containerSize.height - currentContentHeight)
        } else {
            (containerSize.height - currentContentHeight) / 2
        }
    }
    
    private func updateFormOffsetY(
        isKeyboardOpened: Bool,
        currentContentHeight: CGFloat,
        containerSize: CGSize
    ) {
        formOffsetY = calculateFormOffsetY(
            isKeyboardOpened: isKeyboardOpened,
            currentContentHeight: currentContentHeight,
            containerSize: containerSize
        )
    }
}
