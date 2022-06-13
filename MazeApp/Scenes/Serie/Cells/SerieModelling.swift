protocol SerieModelling {}
extension Show: SerieModelling {}
struct SerieEpisodes: SerieModelling {
    var series: Series
}
