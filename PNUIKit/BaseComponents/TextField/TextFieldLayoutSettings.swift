import UIKit

public struct TextFieldLayoutSettings {
    let textColor: UIColor
    let textFont: UIFont
    let placeholderColor: UIColor
    let placeholderFont: UIFont
    let textRectInsets: UIEdgeInsets
    
    public init(
        backgroundColor: UIColor = .black,
        textColor: UIColor = .black,
        textFont: UIFont = .systemFont(ofSize: 14),
        placeholderColor: UIColor = .gray,
        placeholderFont: UIFont = .systemFont(ofSize: 14),
        textRectInsets: UIEdgeInsets = .zero
    ) {
        self.textColor = textColor
        self.textFont = textFont
        self.placeholderColor = placeholderColor
        self.placeholderFont = placeholderFont
        self.textRectInsets = textRectInsets
    }
    
    public static var `default`: Self {
        Self()
    }
}
