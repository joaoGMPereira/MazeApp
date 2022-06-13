import UIKit

struct ItemsViewModel: CellViewModelling {
    let items: [ItemViewModel]
}

struct ItemViewModel {
    let firstTitle: String, secondTitle: String, thirdTitle: String, fourthTitle: String
    let firstImage: String?, secondImage: String?, thirdImage: String?, fourthImage: String?
    let firstFont: UIFont, secondFont: UIFont, thirdFont: UIFont, fourthFont: UIFont
    let nameIsHighlited: Bool
    
    static func header(
        firstTitle: String,
        secondTitle: String,
        thirdTitle: String,
        fourthTitle: String,
        firstFont: UIFont = .preferredFont(for: .callout, weight: .bold),
        secondFont: UIFont = .preferredFont(for: .callout, weight: .bold),
        thirdFont: UIFont = .preferredFont(for: .callout, weight: .bold),
        fourthFont: UIFont = .preferredFont(for: .callout, weight: .bold)
    ) -> ItemViewModel {
        .init(firstTitle: firstTitle,
              secondTitle: secondTitle,
              thirdTitle: thirdTitle,
              fourthTitle: fourthTitle,
              firstImage: nil,
              secondImage: nil,
              thirdImage: nil,
              fourthImage: nil,
              firstFont: firstFont,
              secondFont: secondFont,
              thirdFont: thirdFont,
              fourthFont: fourthFont,
              nameIsHighlited: false)
    }
    
    static func body(
        firstTitle: String,
        secondTitle: String,
        thirdTitle: String,
        fourthTitle: String,
        firstFont: UIFont = .preferredFont(for: .footnote, weight: .medium),
        secondFont: UIFont = .preferredFont(for: .footnote, weight: .medium),
        thirdFont: UIFont = .preferredFont(for: .footnote, weight: .medium),
        fourthFont: UIFont = .preferredFont(for: .footnote, weight: .medium)
    ) -> ItemViewModel {
        .init(firstTitle: firstTitle,
              secondTitle: secondTitle,
              thirdTitle: thirdTitle,
              fourthTitle: fourthTitle,
              firstImage: nil,
              secondImage: nil,
              thirdImage: nil,
              fourthImage: "star.fill",
              firstFont: firstFont,
              secondFont: secondFont,
              thirdFont: thirdFont,
              fourthFont: fourthFont,
              nameIsHighlited: true)
    }
}
