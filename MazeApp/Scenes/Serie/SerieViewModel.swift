import Foundation

public protocol SerieViewModeling: AnyObject {
    func loadScreen()
    func getSeries()
    var sections: [String] { get }
}

final class SerieViewModel {
    typealias Dependencies = HasApi
    private let dependencies: Dependencies
    private let coordinator: SerieCoordinating
    weak var displayer: SerieDisplaying?
    
    private var series: [Series] = []
    private(set) var sections: [String] = [String(), "Episodes"]
    private let show: Show
    
    init(coordinator: SerieCoordinating,
         dependencies: Dependencies,
         show: Show) {
        self.coordinator = coordinator
        self.dependencies = dependencies
        self.show = show
    }
}

// MARK: - SeriesViewModeling
extension SerieViewModel: SerieViewModeling {
    func loadScreen() {
        displayer?.displayShow(show)
        getSeries()
    }
    
    func getSeries() {
        displayer?.displayLoad()
        dependencies.api.execute(endpoint: SeriesEndpoint.episodes(id: show.id)) { [weak self] (result: Result<Success<Series>, ApiError>) in
            guard let self = self else { return }
            self.handleResponse(result)
        }
    }
    
    func handleResponse(_ result: Result<Success<Series>, ApiError>) {
        switch result {
        case .success(let response):
            let episodesForSeason = Array(Dictionary(grouping:response.model){$0.season}.values).sorted{
                guard let first = $0.first, let second = $1.first else {
                    return false
                }
                return first.season < second.season
            }
            series = episodesForSeason
            createTitles()
            episodesForSeason.enumerated().forEach {
                displayer?.displayEpisodes(items(with: $0.element), in: $0.offset + 1)
            }
        case .failure:
            displayer?.displayEpisodesFailure()
        }
    }
    func items(with series: [Serie]) -> ItemsViewModel {
        var items: [ItemViewModel] = [
                .header(firstTitle: "Number",
                        secondTitle: "Date",
                        thirdTitle: "Name",
                        fourthTitle: "Score")
            ]
        series.forEach {
            items.append(
                .body(
                    firstTitle: "\($0.number)",
                    secondTitle: AppDateFormatter.format($0.airdate),
                    thirdTitle: $0.name,
                    fourthTitle: average($0.rating.average))
            )
        }
        return ItemsViewModel(
            items: items
        )
    }
    
    func createTitles() {
        sections = [String()]
        self.series.forEach { series in
            if let firstEpisode = series.first {
                sections.append("Season \(firstEpisode.season)")
            }
        }
    }
    
    func average(_ average: Double?) -> String {
        var averageText = "-"
        if let average = average {
            averageText = "\(average)"
        }
        return averageText
    }
}


//
//// MARK: - Setup
//func setup(with episodes: [Serie], dependencies: Dependencies) {
//    numberStackView.addArrangedSubview(title("Number"))
//    dateStackView.addArrangedSubview(title("Date"))
//    nameStackView.addArrangedSubview(title("Name"))
//    scoreStackView.addArrangedSubview(title("Score"))
//    setupEpisodes(episodes)
//}
//
//func setupEpisodes(_ episodes: [Serie]) {
//    episodes.forEach {

//    }
//}
//
//func title(_ title: String) -> UILabel {
//    let label = UILabel()
//    label.numberOfLines = .zero
//    label.font = .preferredFont(for: .callout, weight: .bold)
//    label.text = title
//    return label
//}
//
//}
