import UIKit

class TextProcessor {
    private let formatter: TextFieldFormatter?
    private weak var textField: UITextField?
    
    init(
        textField: UITextField,
        formatter: TextFieldFormatter?
    ) {
        self.textField = textField
        self.formatter = formatter
    }
    
    func setText(_ text: String) {
        guard let textField, textField.text != text else { return }
        let formattedText = formatter?.process(text: text) ?? text
        guard textField.text != formattedText else { return }
        textField.text = formattedText
        
        textField.selectedTextRange = textField.textRange(
            from: textField.endOfDocument,
            to: textField.endOfDocument
        )
    }
    
    func updateText(
        withReplacement text: String,
        at range: NSRange
    ) -> Bool {
        guard let textField, let formatter else { return false }
        let currentText = textField.text ?? ""
        guard var updatedTextRange = Range(range, in: currentText) else { return false }
        updatedTextRange = transformedRangeIfRemovingByBackspace(text: text, range: updatedTextRange)
        let updatedText = currentText.replacingCharacters(in: updatedTextRange, with: text)
        let formattedText = formatter.process(text: updatedText)
        guard textField.text != formattedText else { return true }
        textField.text = formattedText
        
        let nearestCaretPositionIndex = text.isEmpty ? nearestFormatPositionIndexAfterRemoving(text: text, range: range) : nearestFormatPositionIndexAfterInserting(text: text, at: range)
        let caretPosition = nearestCaretPositionIndex.flatMap {
            textField.position(
                from: textField.beginningOfDocument,
                offset: $0
            )
        }
        guard let caretPosition else { return true }
        textField.selectedTextRange = textField.textRange(
            from: caretPosition,
            to: caretPosition
        )
        
        return true
    }
    
    private func transformedRangeIfRemovingByBackspace(
        text: String,
        range: Range<String.Index>
    ) -> Range<String.Index> {
        guard text.isEmpty, let formatter else { return range }
        guard formatter.format[range.lowerBound] != formatter.formatSymbol else { return range }
        guard range.lowerBound > formatter.format.startIndex else { return range }
        let newRange = Range(uncheckedBounds: (formatter.format.index(before: range.lowerBound), formatter.format.index(before: range.upperBound)))
        return transformedRangeIfRemovingByBackspace(
            text: text,
            range: newRange
        )
    }
    
    private func nearestFormatPositionIndexAfterInserting(text: String, at range: NSRange) -> Int? {
        guard let formatter else { return nil }
        
        var targetPositionIndex = range.location
        var symbolsLeft = text.count
        
        for (formatCharacterIndex, formatCharacter) in formatter.format.enumerated() {
            guard formatCharacterIndex >= range.location else { continue }
            
            targetPositionIndex += 1
            if formatCharacter == formatter.formatSymbol {
                symbolsLeft -= 1
            }
            
            guard symbolsLeft > 0 else { break }
        }
        
        return targetPositionIndex
    }
    
    private func nearestFormatPositionIndexAfterRemoving(text: String, range: NSRange) -> Int? {
        guard let formatter else { return nil }
        
        var targetPositionIndex = range.location + 1
        var symbolsLeft = max(1, text.count)
        
        for (formatCharacterIndex, formatCharacter) in formatter.format.enumerated().reversed() {
            guard formatCharacterIndex <= range.location else { continue }
            
            targetPositionIndex -= 1
            if formatCharacter == formatter.formatSymbol {
                symbolsLeft -= 1
            }
            
            guard symbolsLeft > 0 else { break }
        }
        
        return targetPositionIndex
    }
}
