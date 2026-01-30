import SwiftUI

fileprivate class FormScreenTemplateState<Field: Hashable>: ObservableObject {
    let fields: [Field]
    private let nextButtonTitle: String
    private let acceptButtonTitle: String
    private let onAcceptButtonTapped: () -> Void
    
    init(
        fields: [Field],
        nextButtonTitle: String,
        acceptButtonTitle: String,
        onAcceptButtonTapped: @escaping () -> Void
    ) {
        self.fields = fields
        self.nextButtonTitle = nextButtonTitle
        self.acceptButtonTitle = acceptButtonTitle
        self.onAcceptButtonTapped = onAcceptButtonTapped
    }
    
    func actionButtonTitle(when focusedField: Field?) -> String {
        fields.last == focusedField || focusedField == nil ? acceptButtonTitle : nextButtonTitle
    }
    
    func nextFocusedField(after focusedField: Field?) -> Field? {
        guard let focusedField else {
            onAcceptButtonTapped()
            return nil
        }
        
        let nextFieldIndex = (fields.firstIndex(of: focusedField) ?? 0) + 1
        
        if nextFieldIndex < fields.count {
            return fields[nextFieldIndex]
        }
        
        onAcceptButtonTapped()
        return nil
    }
}
    
public struct FormScreenAcceptButtonConfiguration {
    public let title: String
    public let isEnabled: Bool
    public let onTapped: () -> Void
}
    
public struct FormScreenTemplate<
    Field: Hashable & Identifiable,
    HeaderContent: View,
    FieldContent: View,
    FooterContent: View,
    AcceptButtonContent: View
>: View {
    @StateObject
    private var state: FormScreenTemplateState<Field>
    @FocusState
    private var focusedField: Field?
    
    private let spacing: CGFloat
    private let padding: EdgeInsets
    private let headerContent: () -> HeaderContent
    private let fieldContent: (Field) -> FieldContent
    private let footerContent: () -> FooterContent
    private let acceptButtonEnabled: Bool
    private let acceptButtonContent: (FormScreenAcceptButtonConfiguration) -> AcceptButtonContent
    
    public init(
        spacing: CGFloat = 16,
        padding: EdgeInsets = EdgeInsets(top: 16, leading: 16, bottom: 16, trailing: 16),
        fields: [Field],
        headerContent: @escaping () -> HeaderContent = { EmptyView() },
        fieldContent: @escaping (Field) -> FieldContent,
        footerContent: @escaping () -> FooterContent = { EmptyView() },
        nextButtonTitle: String,
        acceptButtonTitle: String,
        acceptButtonEnabled: Bool,
        onAcceptButtonTapped: @escaping () -> Void,
        acceptButtonContent: @escaping (FormScreenAcceptButtonConfiguration) -> AcceptButtonContent
    ) {
        let state = FormScreenTemplateState(
            fields: fields,
            nextButtonTitle: nextButtonTitle,
            acceptButtonTitle: acceptButtonTitle,
            onAcceptButtonTapped: onAcceptButtonTapped
        )
        _state = .init(wrappedValue: state)
        
        self.spacing = spacing
        self.padding = padding
        self.headerContent = headerContent
        self.fieldContent = fieldContent
        self.footerContent = footerContent
        self.acceptButtonEnabled = acceptButtonEnabled
        self.acceptButtonContent = acceptButtonContent
    }
    
    public var body: some View {
        VStack(spacing: 0) {
            SwiftUI.ScrollView {
                ScrollViewReader { proxy in
                    VStack(spacing: spacing) {
                        headerContent()
                        
                        ForEach(state.fields) { field in
                            fieldContent(field)
                                .id(field)
                                .focused($focusedField, equals: field)
                        }
                        
                        footerContent()
                    }
                    .padding(padding)
                    .padding(.bottom, 10)
                    .onChange(of: focusedField, perform: { nextField in
                        withAnimation {
                            proxy.scrollTo(nextField, anchor: .bottom)
                        }
                    })
                }
            }
            
            let acceptButtonConfiguration = FormScreenAcceptButtonConfiguration(
                title: state.actionButtonTitle(when: focusedField),
                isEnabled: focusedField != nil || acceptButtonEnabled,
                onTapped: { focusedField = state.nextFocusedField(after: focusedField) }
            )
            acceptButtonContent(acceptButtonConfiguration)
        }
    }
}
