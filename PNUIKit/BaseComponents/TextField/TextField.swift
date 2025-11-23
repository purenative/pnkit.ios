import SwiftUI

public struct TextField: UIViewRepresentable {
    private let initialText: String
    private let placeholder: String?
    private let layoutSettings: TextFieldLayoutSettings
    private let formatter: TextFieldFormatter?
    private let keyboardType: UIKeyboardType
    @Binding
    private var isSecureTextEntry: Bool
    private let dismissKeyboardOnReturn: Bool
    private let onTextChanged: (String) -> Void
    
    public init(
        initialText: String,
        placeholder: String?,
        layoutSettings: TextFieldLayoutSettings,
        formatter: TextFieldFormatter?,
        keyboardType: UIKeyboardType,
        isSecureTextEntry: Binding<Bool> = .constant(false),
        dismissKeyboardOnReturn: Bool,
        onTextChanged: @escaping (String) -> Void
    ) {
        self.initialText = initialText
        self.placeholder = placeholder
        self.layoutSettings = layoutSettings
        self.formatter = formatter
        self.keyboardType = keyboardType
        _isSecureTextEntry = isSecureTextEntry
        self.dismissKeyboardOnReturn = dismissKeyboardOnReturn
        self.onTextChanged = onTextChanged
    }
    
    public func makeUIView(context: Context) -> TextFieldBase {
        let textField = TextFieldBase(formatter: formatter)
        
        context.coordinator.bind(
            textField: textField,
            onTextChanged: onTextChanged
        )
        
        textField.useLayoutSettings(layoutSettings)
        textField.placeholder = placeholder
        textField.updateText(initialText)
        textField.keyboardType = keyboardType
        textField.dismissKeyboardOnReturn = dismissKeyboardOnReturn
        textField.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        textField.isSecureTextEntry = isSecureTextEntry
        
        return textField
    }
    
    public func updateUIView(_ textField: TextFieldBase, context: Context) {
        textField.updateText(initialText)
        textField.isSecureTextEntry = isSecureTextEntry
    }
    
    public func makeCoordinator() -> TextFieldCoordinator {
        TextFieldCoordinator()
    }
}
    
public final class TextFieldCoordinator {
    private var onTextChanged: ((String) -> Void)?
    
    @MainActor
    func bind(
        textField: UITextField,
        onTextChanged: @escaping (String) -> Void
    ) {
        self.onTextChanged = onTextChanged
        
        textField.addTarget(
            self,
            action: #selector(onEditingChanged),
            for: .editingChanged
        )
    }
    
    @objc
    private func onEditingChanged(textField: UITextField) {
        onTextChanged?(textField.text ?? "")
    }
}
