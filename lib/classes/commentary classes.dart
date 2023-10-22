// for team scores
class TeamScore {
  final String teamscorefirst;
  final String teamscoreSecond;

  TeamScore({
    required this.teamscorefirst,
    required this.teamscoreSecond,
  });
}

// for current runrate
class CurrentRate {
  final String currRate;
  CurrentRate({required this.currRate});
}

// for required runrate
class RequiredRate {
  final String reqRate;
  RequiredRate({required this.reqRate});
}

// for Player of the match 
class PlayerOfMatch {
  final String playerMotmLabel;
  final String playerMotmValue;

  PlayerOfMatch({
    required this.playerMotmLabel,
    required this.playerMotmValue,
  });
}
// for Player of the series 
class PlayerOfSeries {
  final String playerMotsLabel;
  final String playerMotsValue;

  PlayerOfSeries({
    required this.playerMotsLabel,
    required this.playerMotsValue,
  });
}

// for commentary screen classes
class BatterHeaderItem {
  final String batterHeader;
  // final String runsHeader;
  // final String ballsHeader;
  // final String foursHeader;
  // final String sixesHeader;
  // final String strikeRateHeader;

  BatterHeaderItem({
    required this.batterHeader,
    // required this.runsHeader,
    // required this.ballsHeader,
    // required this.foursHeader,
    // required this.sixesHeader,
    // required this.strikeRateHeader,
  });
}

class PlayerData {
  final String playername;
  final String playercountry;
  late final String playerimage;
  final String runs;
  final String ballsfaced;
  final String fours;
  final String sixes;
  final String strikerate;

  PlayerData({
    required this.playername,
    required this.playercountry,
    required this.playerimage,
    required this.runs,
    required this.ballsfaced,
    required this.fours,
    required this.sixes,
    required this.strikerate,
  });
}

class BowlerHeaderItem {
  final String bowlerHeader;
  final String oversHeader;
  final String maidensHeader;
  final String runsHeader;
  final String wicketsHeader;
  final String economyHeader;

  BowlerHeaderItem({
    required this.bowlerHeader,
    required this.oversHeader,
    required this.maidensHeader,
    required this.runsHeader,
    required this.wicketsHeader,
    required this.economyHeader,
  });
}

class BowlerData {
  final String bowlername;
  final String bowlercountry;
  final String bnowlerimage;
  final String overs;
  final String maidens;
  final String runs;
  final String wickets;
  final String economy;

  BowlerData({
    required this.bowlername,
    required this.bowlercountry,
    required this.bnowlerimage,
    required this.overs,
    required this.maidens,
    required this.runs,
    required this.wickets,
    required this.economy,
  });
}

class TimelineData {
  final String recentTimelineText;
  final String recentTimelineValue;

  TimelineData({
    required this.recentTimelineText,
    required this.recentTimelineValue,
  });
}

class KeyStatsData {
  final String keystatsLabel;

  KeyStatsData({
    required this.keystatsLabel,
  });
}

// for live screen classes

class NewsItemMain {
  final String imageUrl;
  final String category;
  final String title;
  final String summary;
  final String time;
  final String articleUrl;

  NewsItemMain({
    required this.imageUrl,
    required this.category,
    required this.title,
    required this.summary,
    required this.time,
    required this.articleUrl,
  });
}

class NewsItemSub {
  final String imageUrl;
  final String category;
  final String title;
  final String time;
  final String articleUrl;

  NewsItemSub({
    required this.imageUrl,
    required this.category,
    required this.title,
    required this.time,
    required this.articleUrl,
  });
}

class MatchItem {
  final String matchTitle;
  final String matchFormat;
  final String team1Name;
  final String team1Score;
  final String team2Name;
  final String team2Score;
  final String matchResult;
  final String team1Flag;
  final String team2Flag;
  final String linkurl;

  MatchItem({
    required this.matchTitle,
    required this.matchFormat,
    required this.team1Name,
    required this.team1Score,
    required this.team2Name,
    required this.team2Score,
    required this.matchResult,
    required this.team1Flag,
    required this.team2Flag,
    required this.linkurl,
  });
}
