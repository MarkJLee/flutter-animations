class Game {
  final String title;
  final String shortDescription;
  final double rating;
  final String longDescription;
  final String youtubeId;

  Game({
    required this.title,
    required this.shortDescription,
    required this.rating,
    required this.longDescription,
    required this.youtubeId,
  });
}

List<Game> gameInfoList = [
  Game(
    title: "CookieRun: Kingdom",
    shortDescription:
        "Meet our Cookies, all voiced by an amazing cast of voice actors Witness their epic skills, fall in love with their voices, and dress them into new chic costumes.",
    rating: 4.5,
    longDescription:
        "The secrets of the ancient Cookies and their kingdoms are waiting to be unraveled. Join GingerBrave and his friends against Dark Enchantress Cookie and her dark legion. The chronicles of CookieRun: Kingdom have just begun! Choose from a great variety of unique decors to design the Kingdom of your dreams. Produce materials, craft items, arrange all sorts of activities—the vibrant kingdom life awaits!",
    youtubeId: "wYycWFbwlUc",
  ),
  Game(
    title: "Minecraft",
    shortDescription:
        'Minecraft is a game made from blocks that you can transform into whatever you can imagine. Play in Creative mode with unlimited resources, or hunt for tools to fend off danger in Survival mode.',
    rating: 3.4,
    longDescription:
        "Minecraft is a game made from blocks that you can transform into whatever you can imagine. Play in Creative mode with unlimited resources, or hunt for tools to fend off danger in Survival mode. With seamless cross-platform play on Minecraft: Bedrock Edition you can adventure solo or with friends, and discover an infinite, randomly generated world filled with blocks to mine, biomes to explore and mobs to befriend (or fight). The choice is yours in Minecraft, so play your way!",
    youtubeId: "Rla3FUlxJdE",
  ),
  Game(
    title: "Wing Feather Saga",
    shortDescription:
        "The Wing Feather Saga arcade game brings the magical world of Aerwiar to life. Players can join the Igiby children on a thrilling quest against the Fangs of Dang.",
    rating: 5.0,
    longDescription:
        "Based on Andrew Peterson's fantasy book series, the Wing Feather Saga arcade game immerses players in the enchanting world of Aerwiar. Choose to play as one of the Igiby children - Janner, Kalmar, or Leeli - each with unique abilities. Journey across the land on an exciting adventure to defeat the evil Fangs of Dang. Encounter fantastical creatures and mystical environments as you take on quests and battles. Collect treasures and power-ups, learn new skills, and unlock abilities as your character grows. With a sweeping story, beautiful graphics, and addictive gameplay, the Wing Feather Saga arcade game brings all the magic of the books to vivid life.",
    youtubeId: "2LF1tyZd6Ss",
  ),
];
