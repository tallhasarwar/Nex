import UIKit

public protocol InfoLabelDelegate: class {

  func infoLabel(_ infoLabel: InfoLabel, didExpand expanded: Bool)
}

open class InfoLabel: ActiveLabel {

  lazy var tapGestureRecognizer: UITapGestureRecognizer = { [unowned self] in
    let gesture = UITapGestureRecognizer()
    gesture.addTarget(self, action: #selector(labelDidTap(_:)))

    return gesture
  }()

  open var numberOfVisibleLines = 2

  var ellipsis: String {
    return "... \(LightboxConfig.InfoLabel.ellipsisText)"
  }

  open weak var infoDelegate: InfoLabelDelegate?
  fileprivate var shortText = ""

  var fullText: String {
    didSet {
      shortText = truncatedText
      updateText(fullText)
      configureLayout()
    }
  }

  var expandable: Bool {
    return shortText != fullText
  }

  fileprivate(set) var expanded = false {
    didSet {
      infoDelegate?.infoLabel(self, didExpand: expanded)
    }
  }

  var truncatedText: String {
    var truncatedText = fullText

    guard numberOfLines(fullText) > numberOfVisibleLines else {
      return truncatedText
    }

    // Perform quick "rough cut"
    while numberOfLines(truncatedText) > numberOfVisibleLines * 2 {
        truncatedText = String(truncatedText.prefix(truncatedText.count / 2))
    }

    // Capture the endIndex of truncatedText before appending ellipsis
    var truncatedTextCursor = truncatedText.endIndex

    truncatedText += ellipsis

    // Remove characters ahead of ellipsis until the text is the right number of lines
    while numberOfLines(truncatedText) > numberOfVisibleLines {
      // To avoid "Cannot decrement before startIndex"
      guard truncatedTextCursor > truncatedText.startIndex else {
        break
      }

      truncatedTextCursor = truncatedText.index(before: truncatedTextCursor)
      truncatedText.remove(at: truncatedTextCursor)
    }

    return truncatedText
  }

  // MARK: - Initialization

  public init(text: String, expanded: Bool = false) {
    self.fullText = text
    super.init(frame: CGRect.zero)

    numberOfLines = 0
    updateText(text)
    self.expanded = expanded
    
    self.enabledTypes = [.hashtag]
    self.hashtagColor = UIColor(red: 0.06, green: 0.46, blue: 0.96, alpha: 1.0)

    addGestureRecognizer(tapGestureRecognizer)
  }

  public required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: - Actions

  @objc func labelDidTap(_ tapGestureRecognizer: UITapGestureRecognizer) {
    shortText = truncatedText
    expanded ? collapse() : expand()
  }

  func expand() {
    frame.size.height = heightForString(fullText)
    updateText(fullText)

    expanded = expandable
  }

  func collapse() {
    frame.size.height = heightForString(shortText)
    updateText(shortText)

    expanded = false
  }

  fileprivate func updateText(_ string: String) {
    let textAttributes = LightboxConfig.InfoLabel.textAttributes
    let attributedString = NSMutableAttributedString(string: string, attributes: textAttributes)

    if let range = string.range(of: ellipsis) {
        let ellipsisColor = LightboxConfig.InfoLabel.ellipsisColor
        let ellipsisRange = NSRange(range, in: string)
        attributedString.addAttribute(NSForegroundColorAttributeName, value: ellipsisColor, range: ellipsisRange)
    }

    attributedText = attributedString
  }

  // MARK: - Helper methods

  fileprivate func heightForString(_ string: String) -> CGFloat {
    return string.boundingRect(
      with: CGSize(width: bounds.size.width, height: CGFloat.greatestFiniteMagnitude),
      options: [.usesLineFragmentOrigin, .usesFontLeading],
      attributes: [NSFontAttributeName: font],
      context: nil).height
  }

  fileprivate func numberOfLines(_ string: String) -> Int {
    let lineHeight = "A".size(attributes: [NSFontAttributeName: font]).height
    let totalHeight = heightForString(string)

    return Int(totalHeight / lineHeight)
  }
}

// MARK: - LayoutConfigurable

extension InfoLabel: LayoutConfigurable {

  @objc public func configureLayout() {
    shortText = truncatedText
    expanded ? expand() : collapse()
  }
}