public protocol TextFieldFormatter {
    var formatSymbol: Character { get }
    var format: String { get }
    func process(text: String) -> String
}
