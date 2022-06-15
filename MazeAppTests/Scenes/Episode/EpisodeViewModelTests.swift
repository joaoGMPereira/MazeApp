import XCTest
@testable import MazeApp

class EpisodeDisplayingSpy: EpisodeDisplaying {
    enum Messages: AutoEquatable {
        case displaySummary(SummaryViewModel, String)
        case displayEpisodeFailure(FeedbackModel)
        case displayLoad
    }
    
    private(set) var messages: [Messages] = []
    
    func displaySummary(_ summary: SummaryViewModel, title: String) {
        messages.append(.displaySummary(summary, title))
    }
    
    func displayEpisodeFailure(with feedback: FeedbackModel) {
        messages.append(.displayEpisodeFailure(feedback))
    }
    
    func displayLoad() {
        messages.append(.displayLoad)
    }
}

class EpidosdeViewModelTests: XCTestCase {
    
    func testInit_ShouldNotCallLoadShows() {
        let (_, display, _) = makeSut()
        XCTAssertTrue(display.messages.isEmpty)
    }
    
    
    func testLoadEpisode_WhenSuccessApi_ShouldDisplayEpisode() {
        let (sut, displayer, api) = makeSut()
        let episode = Episode.episodeFixture()
        api.response = episode
        sut.loadScreen()
        XCTAssertEqual(
            displayer.messages,
            [.displayLoad,
             .displaySummary(
                .init(summary:
                        .init(
                            title: episode.summary ?? String(),
                            isHidden: episode.summary == nil),
                      imageUrl: episode.image?.original,
                      score: .init(title: sut.average(episode.rating.average),
                                   font: .preferredFont(for: .footnote, weight: .bold),
                                   alignment: .justified,
                                   image: "star.fill",
                                   isHidden: episode.rating.average == nil),
                      schedule: .init(title: sut.schedule(with: episode),
                                      font: .preferredFont(for: .footnote, weight: .bold),
                                      alignment: .justified,
                                      image: "tv"),
                      genres: []
                ), "E\(episode.number)S\(episode.season) \(episode.name)")])
    }
    
    func testLoadEpisode_WhenFailureApi_ShouldDisplayEpisodeFailure() {
        let (sut, displayer, _) = makeSut()
        sut.loadScreen()
        XCTAssertEqual(
            displayer.messages,
            [.displayLoad,
             .displayEpisodeFailure(.init(
                title: "Something didn't go right while we searched for the episode",
                subtitle: "Verify you connection and please try again",
                buttonName: "Try again") {})])
    }
    
    func testLoadEpisode_WhenFailureApiAndSuccessAfter_ShouldDisplayEpisode() {
        let (sut, displayer, api) = makeSut()
        sut.loadScreen()
        let episode = Episode.episodeFixture()
        let feedback = FeedbackModel(
            title: "Something didn't go right while we searched for the episode",
            subtitle: "Verify you connection and please try again",
            buttonName: "Try again") {
                api.response = episode
                sut.loadScreen()
            }
        feedback.completion?()
        XCTAssertEqual(
            displayer.messages,
            [.displayLoad,
             .displayEpisodeFailure(feedback),
             .displayLoad,
             .displaySummary(
                .init(summary:
                        .init(
                            title: episode.summary ?? String(),
                            isHidden: episode.summary == nil),
                      imageUrl: episode.image?.original,
                      score: .init(title: sut.average(episode.rating.average),
                                   font: .preferredFont(for: .footnote, weight: .bold),
                                   alignment: .justified,
                                   image: "star.fill",
                                   isHidden: episode.rating.average == nil),
                      schedule: .init(title: sut.schedule(with: episode),
                                      font: .preferredFont(for: .footnote, weight: .bold),
                                      alignment: .justified,
                                      image: "tv"),
                      genres: []
                ), "E\(episode.number)S\(episode.season) \(episode.name)")])
    }
    
    func makeSut() -> (sut: EpisodeViewModel, displayer: EpisodeDisplayingSpy, api: ApiProtocolSpy) {
        let api = ApiProtocolSpy()
        let sut = EpisodeViewModel.init(dependencies: DependencyContainerMock(api), show: "1", season: "1", episodeId: "1")
        let displayer = EpisodeDisplayingSpy()
        sut.displayer = displayer
        return (sut, displayer, api)
    }
}

extension Episode {
    static func episodeFixture(name: String? = nil, id: Int? = nil) -> Episode {
        .init(id: id ?? .anyValue,
              name: name ?? .anyValue,
              season: .anyValue,
              number: .anyValue,
              rating: .init(average: 5),
              image: .init(medium: .anyValue, original: .anyValue),
              summary: .anyValue,
              airtime: .anyValue,
              runtime: .anyValue)
    }
}
