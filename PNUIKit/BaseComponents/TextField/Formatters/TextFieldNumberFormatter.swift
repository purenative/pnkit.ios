public struct TextFieldNumberFormatter: TextFieldFormatter {
    public let formatSymbol: Character
    public let format: String
    
    public init(
        formatSymbol: Character = Character("N"),
        format: String
    ) {
        self.formatSymbol = formatSymbol
        self.format = format
    }
    
    public func process(text: String) -> String {
        let numbers: [Character] = text.filter(\.isNumber)
        
        var result = ""
        var nextNumberIndex: Int? = numbers.indices.first
        
        for formatChar in format {
            if let numberIndex = nextNumberIndex {
                if formatChar == formatSymbol {
                    result.append(numbers[numberIndex])
                    nextNumberIndex = numberIndex + 1 < numbers.count ? numberIndex + 1 : nil
                } else {
                    result.append(formatChar)
                }
            } else {
                break
            }
        }
        
        return result
    }
}
