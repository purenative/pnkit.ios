import UIKit

public final class TextFieldBase: UITextField, UITextFieldDelegate {
    private var textProcessor: TextProcessor!
    private var layoutSettings = TextFieldLayoutSettings.default
    
    var dismissKeyboardOnReturn = false
    
    public override var placeholder: String? {
        didSet { updatePlaceholder() }
    }
    
    init(formatter: TextFieldFormatter?) {
        super.init(frame: .zero)
        
        textProcessor = TextProcessor(textField: self, formatter: formatter)
        delegate = self
        applyLayoutSettings()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func textRect(forBounds bounds: CGRect) -> CGRect {
        bounds.inset(by: layoutSettings.textRectInsets)
    }
    
    public override func editingRect(forBounds bounds: CGRect) -> CGRect {
        bounds.inset(by: layoutSettings.textRectInsets)
    }
    
    public override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        bounds.inset(by: layoutSettings.textRectInsets)
    }
    
    func updateText(_ text: String) {
        textProcessor.setText(text)
    }
    
    func useLayoutSettings(_ layoutSettings: TextFieldLayoutSettings) {
        self.layoutSettings = layoutSettings
        applyLayoutSettings()
    }
    
    private func applyLayoutSettings() {
        backgroundColor = .clear
        textColor = layoutSettings.textColor
        font = layoutSettings.textFont
        updatePlaceholder()
        setNeedsLayout()
        layoutIfNeeded()
    }
    
    private func updatePlaceholder() {
        guard let placeholder else { return }
        
        attributedPlaceholder = NSAttributedString(
            string: placeholder,
            attributes: [
                .font: layoutSettings.placeholderFont,
                .foregroundColor: layoutSettings.placeholderColor
            ]
        )
    }
    
    // MARK: - UITextFieldDelegate
    
    public func textField(
        _ textField: UITextField,
        shouldChangeCharactersIn range: NSRange,
        replacementString string: String
    ) -> Bool {
        guard textProcessor.updateText(withReplacement: string, at: range) else { return true }
        sendActions(for: .editingChanged)
        return false
    }
    
    public func textField(
        _ textField: UITextField,
        shouldChangeCharactersInRanges ranges: [NSValue],
        replacementString string: String
    ) -> Bool {
        guard let range = ranges.first?.rangeValue else { return true }
        
        guard textProcessor.updateText(withReplacement: string, at: range) else { return true }
        sendActions(for: .editingChanged)
        return false
    }
    
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        guard dismissKeyboardOnReturn else { return true }
        
        textField.resignFirstResponder()
        return false
    }
}
