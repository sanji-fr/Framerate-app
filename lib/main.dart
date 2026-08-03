import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:file_picker/file_picker.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const FramerateApp());
}

// -----------------------------------------------------------------------------
// THEME, APP ICON PRESETS, & MODEL CONFIGS
// -----------------------------------------------------------------------------

class AppThemeConfig {
  final String id;
  final String name;
  final String section;
  final Color background;
  final Color surface;
  final Color accent;
  final Color textPrimary;
  final Color textSecondary;
  final String watermarkAsset;
  final String animationType;
  final String linkedIcon;

  const AppThemeConfig({
    required this.id,
    required this.name,
    required this.section,
    required this.background,
    required this.surface,
    required this.accent,
    required this.textPrimary,
    required this.textSecondary,
    required this.watermarkAsset,
    required this.animationType,
    required this.linkedIcon,
  });
}

class ThemePresets {
  static const List<AppThemeConfig> all = [
    // Gurren Lagann
    AppThemeConfig(
      id: 'pierce_heavens', name: 'Pierce the Heavens', section: 'Gurren Lagann',
      background: Color(0xFF0A0A12), surface: Color(0xFF131320), accent: Color(0xFFFF2200),
      textPrimary: Colors.white, textSecondary: Color(0xFF9E9EB8), watermarkAsset: 'drill', animationType: 'drill', linkedIcon: '🌀 Spiral Core Drill ("F")',
    ),
    AppThemeConfig(
      id: 'giga_drill', name: 'Giga Drill Breaker', section: 'Gurren Lagann',
      background: Color(0xFF120905), surface: Color(0xFF1E110A), accent: Color(0xFFFF9900),
      textPrimary: Colors.white, textSecondary: Color(0xFFB89E9E), watermarkAsset: 'tornado', animationType: 'tornado', linkedIcon: '🌪️ Giga Tornado ("F")',
    ),
    AppThemeConfig(
      id: 'super_tengen', name: 'Super Tengen Toppa', section: 'Gurren Lagann',
      background: Color(0xFF070614), surface: Color(0xFF100F24), accent: Color(0xFF00F0FF),
      textPrimary: Colors.white, textSecondary: Color(0xFF8E9EE0), watermarkAsset: 'nebula', animationType: 'nebula', linkedIcon: '🌌 Galaxy Nebula ("F")',
    ),

    // Hollow Knight & Silksong
    AppThemeConfig(
      id: 'pharloom_silk', name: 'Pharloom Silk', section: 'Hollow Knight & Silksong',
      background: Color(0xFF0B0B12), surface: Color(0xFF151522), accent: Color(0xFFE63956),
      textPrimary: Colors.white, textSecondary: Color(0xFF9E9EA8), watermarkAsset: 'needle', animationType: 'needle', linkedIcon: '🧵 Crimson Needle ("F")',
    ),
    AppThemeConfig(
      id: 'grounded_pharloom', name: 'Grounded Pharloom', section: 'Hollow Knight & Silksong',
      background: Color(0xFF08120C), surface: Color(0xFF102014), accent: Color(0xFFA0E040),
      textPrimary: Colors.white, textSecondary: Color(0xFF9EB8A0), watermarkAsset: 'moss', animationType: 'moss', linkedIcon: '🍄 Moss Grotto ("F")',
    ),
    AppThemeConfig(
      id: 'void_soul', name: 'Void & Soul', section: 'Hollow Knight & Silksong',
      background: Color(0xFF0A0D12), surface: Color(0xFF121822), accent: Color(0xFFFFFFFF),
      textPrimary: Colors.white, textSecondary: Color(0xFF8FA0B8), watermarkAsset: 'shell', animationType: 'shell', linkedIcon: '🛡️ Pure Vessel Shell ("F")',
    ),

    // FromSoftware
    AppThemeConfig(
      id: 'grace_tarnished', name: 'Grace of the Tarnished', section: 'FromSoftware',
      background: Color(0xFF08090C), surface: Color(0xFF13151C), accent: Color(0xFFF0C265),
      textPrimary: Colors.white, textSecondary: Color(0xFFA8A498), watermarkAsset: 'grace', animationType: 'grace', linkedIcon: '⚔️ Erdtree Grace ("F")',
    ),
    AppThemeConfig(
      id: 'ashen_firelink', name: 'Ashen Firelink', section: 'FromSoftware',
      background: Color(0xFF0C0B0A), surface: Color(0xFF181614), accent: Color(0xFFFF7700),
      textPrimary: Colors.white, textSecondary: Color(0xFFB8A8A0), watermarkAsset: 'bonfire', animationType: 'bonfire', linkedIcon: '🔥 Bonfire Ember ("F")',
    ),
    AppThemeConfig(
      id: 'yharnam_paleblood', name: 'Yharnam Paleblood', section: 'FromSoftware',
      background: Color(0xFF0B0B0E), surface: Color(0xFF16161B), accent: Color(0xFF9A1818),
      textPrimary: Colors.white, textSecondary: Color(0xFFA89E9E), watermarkAsset: 'rune', animationType: 'rune', linkedIcon: '🩸 Caryll Blood Rune ("F")',
    ),
    AppThemeConfig(
      id: 'shadow_shinobi', name: 'Shadow Shinobi', section: 'FromSoftware',
      background: Color(0xFF0E0C0A), surface: Color(0xFF1A1612), accent: Color(0xFFE65100),
      textPrimary: Colors.white, textSecondary: Color(0xFFB8A89E), watermarkAsset: 'kanji', animationType: 'kanji', linkedIcon: '🍂 Deathblow Kanji ("F")',
    ),
    AppThemeConfig(
      id: 'fires_rubicon', name: 'Fires of Rubicon', section: 'FromSoftware',
      background: Color(0xFF0B0E11), surface: Color(0xFF141C22), accent: Color(0xFFFF3300),
      textPrimary: Colors.white, textSecondary: Color(0xFF9EAAB8), watermarkAsset: 'mech', animationType: 'mech', linkedIcon: '🤖 Coral Thruster ("F")',
    ),

    // One Piece & Sanji
    AppThemeConfig(
      id: 'grand_line', name: 'Grand Line Treasure', section: 'One Piece & Sanji',
      background: Color(0xFF081018), surface: Color(0xFF101E2E), accent: Color(0xFFFF8C00),
      textPrimary: Colors.white, textSecondary: Color(0xFF9EB0C8), watermarkAsset: 'compass', animationType: 'compass', linkedIcon: '🧭 Log Pose Compass ("F")',
    ),
    AppThemeConfig(
      id: 'gear_five', name: 'Gear 5 Drums', section: 'One Piece & Sanji',
      background: Color(0xFF0D0F1A), surface: Color(0xFF171A2E), accent: Color(0xFFF1F2F6),
      textPrimary: Colors.white, textSecondary: Color(0xFF9EA3C8), watermarkAsset: 'cloud', animationType: 'cloud', linkedIcon: '👒 Straw Hat Jolly Roger ("F")',
    ),
    AppThemeConfig(
      id: 'black_leg_ifrit', name: 'Black Leg Ifrit', section: 'One Piece & Sanji',
      background: Color(0xFF080A0F), surface: Color(0xFF121622), accent: Color(0xFFFF4500),
      textPrimary: Colors.white, textSecondary: Color(0xFF9EAEC8), watermarkAsset: 'flame', animationType: 'flame', linkedIcon: '🔥 Blue Flame Ifrit ("F")',
    ),
    AppThemeConfig(
      id: 'diable_jambe', name: 'Diable Jambe', section: 'One Piece & Sanji',
      background: Color(0xFF110A0A), surface: Color(0xFF221313), accent: Color(0xFFFF5500),
      textPrimary: Colors.white, textSecondary: Color(0xFFC8A3A3), watermarkAsset: 'kick', animationType: 'kick', linkedIcon: '⚡ Searing Kick Boot ("F")',
    ),
    AppThemeConfig(
      id: 'stealth_black', name: 'Stealth Black', section: 'One Piece & Sanji',
      background: Color(0xFF090A0E), surface: Color(0xFF13151F), accent: Color(0xFFFF0055),
      textPrimary: Colors.white, textSecondary: Color(0xFF9EA3C8), watermarkAsset: 'visor', animationType: 'visor', linkedIcon: '🕶️ Raid Visor ("F")',
    ),
    AppThemeConfig(
      id: 'mr_prince', name: 'Mr. Prince', section: 'One Piece & Sanji',
      background: Color(0xFF080D11), surface: Color(0xFF111C24), accent: Color(0xFFE0B034),
      textPrimary: Colors.white, textSecondary: Color(0xFF9EB4C8), watermarkAsset: 'smoke', animationType: 'smoke', linkedIcon: '🚬 Golden Rose Smoke ("F")',
    ),
    AppThemeConfig(
      id: 'vinsmoke_prince', name: 'Vinsmoke Prince', section: 'One Piece & Sanji',
      background: Color(0xFF110B12), surface: Color(0xFF241624), accent: Color(0xFFF0A8D0),
      textPrimary: Colors.white, textSecondary: Color(0xFFC8A3C4), watermarkAsset: 'rose', animationType: 'rose', linkedIcon: '🌹 Totto Land Rose ("F")',
    ),

    // JoJo's Bizarre Adventure
    AppThemeConfig(
      id: 'phantom_blood', name: 'Phantom Blood', section: 'JoJo Bizarre Adventure',
      background: Color(0xFF0F0A0A), surface: Color(0xFF1E1313), accent: Color(0xFFD4AF37),
      textPrimary: Colors.white, textSecondary: Color(0xFFC8A3A3), watermarkAsset: 'mask', animationType: 'mask', linkedIcon: '🏺 Stone Mask ("F")',
    ),
    AppThemeConfig(
      id: 'battle_tendency', name: 'Battle Tendency', section: 'JoJo Bizarre Adventure',
      background: Color(0xFF090E14), surface: Color(0xFF121C28), accent: Color(0xFF00E5FF),
      textPrimary: Colors.white, textSecondary: Color(0xFF9EB4C8), watermarkAsset: 'hamon', animationType: 'hamon', linkedIcon: '⚡ Hamon Spark Circle ("F")',
    ),
    AppThemeConfig(
      id: 'pillar_men', name: 'Pillar Men Awakening', section: 'JoJo Bizarre Adventure',
      background: Color(0xFF0C0808), surface: Color(0xFF1A1010), accent: Color(0xFFB30000),
      textPrimary: Colors.white, textSecondary: Color(0xFFC8A3A3), watermarkAsset: 'pillar', animationType: 'pillar', linkedIcon: '🗿 Aztec Stone Relief ("F")',
    ),
    AppThemeConfig(
      id: 'dynamic_hamon', name: 'Dynamic Hamon Duo', section: 'JoJo Bizarre Adventure',
      background: Color(0xFF0A0D14), surface: Color(0xFF141A28), accent: Color(0xFF00D2FF),
      textPrimary: Colors.white, textSecondary: Color(0xFF9EB8C8), watermarkAsset: 'bubbles', animationType: 'bubbles', linkedIcon: '🫧 Caesar Bubble ("F")',
    ),
    AppThemeConfig(
      id: 'stardust_crusaders', name: 'Stardust Crusaders', section: 'JoJo Bizarre Adventure',
      background: Color(0xFF0A0B10), surface: Color(0xFF141620), accent: Color(0xFFA020F0),
      textPrimary: Colors.white, textSecondary: Color(0xFF9EA3C8), watermarkAsset: 'star', animationType: 'star', linkedIcon: '⭐ Star Platinum Fist ("F")',
    ),
    AppThemeConfig(
      id: 'diamond_unbreakable', name: 'Diamond is Unbreakable', section: 'JoJo Bizarre Adventure',
      background: Color(0xFF120917), surface: Color(0xFF22122E), accent: Color(0xFF00FF99),
      textPrimary: Colors.white, textSecondary: Color(0xFFC0A3C8), watermarkAsset: 'diamond', animationType: 'diamond', linkedIcon: '💎 Crazy Diamond Shard ("F")',
    ),
    AppThemeConfig(
      id: 'golden_wind', name: 'Golden Wind', section: 'JoJo Bizarre Adventure',
      background: Color(0xFF180816), surface: Color(0xFF30102C), accent: Color(0xFFFFD700),
      textPrimary: Colors.white, textSecondary: Color(0xFFD4A3CF), watermarkAsset: 'bug', animationType: 'bug', linkedIcon: '🐞 Golden Ladybug ("F")',
    ),
    AppThemeConfig(
      id: 'stone_ocean', name: 'Stone Ocean', section: 'JoJo Bizarre Adventure',
      background: Color(0xFF090C14), surface: Color(0xFF121928), accent: Color(0xFF00D0FF),
      textPrimary: Colors.white, textSecondary: Color(0xFF9EB4C8), watermarkAsset: 'string', animationType: 'string', linkedIcon: '🧵 Stone Free String ("F")',
    ),
    AppThemeConfig(
      id: 'steel_ball_run', name: 'Steel Ball Run', section: 'JoJo Bizarre Adventure',
      background: Color(0xFF140C08), surface: Color(0xFF281810), accent: Color(0xFF32CD32),
      textPrimary: Colors.white, textSecondary: Color(0xFFC8B0A3), watermarkAsset: 'spin', animationType: 'spin', linkedIcon: '⚾ Golden Spin Sphere ("F")',
    ),
    AppThemeConfig(
      id: 'jojolion', name: 'JoJolion', section: 'JoJo Bizarre Adventure',
      background: Color(0xFF0C1014), surface: Color(0xFF182028), accent: Color(0xFFFF69B4),
      textPrimary: Colors.white, textSecondary: Color(0xFF9EB0C8), watermarkAsset: 'bubble', animationType: 'bubble', linkedIcon: '🧼 Soft & Wet Soap ("F")',
    ),
    AppThemeConfig(
      id: 'jojolands', name: 'The JOJOLands', section: 'JoJo Bizarre Adventure',
      background: Color(0xFF071216), surface: Color(0xFF0E242C), accent: Color(0xFF00F5D4),
      textPrimary: Colors.white, textSecondary: Color(0xFF9EC8C4), watermarkAsset: 'rain', animationType: 'rain', linkedIcon: '🌧️ November Rain Drop ("F")',
    ),
    AppThemeConfig(
      id: 'joestar_legacy', name: 'Joestar Legacy', section: 'JoJo Bizarre Adventure',
      background: Color(0xFF0B0813), surface: Color(0xFF161026), accent: Color(0xFFFFB700),
      textPrimary: Colors.white, textSecondary: Color(0xFFB0A3C8), watermarkAsset: 'birthmark', animationType: 'birthmark', linkedIcon: '⭐ Joestar Birthmark ("F")',
    ),

    // Kojima Productions
    AppThemeConfig(
      id: 'chiral_connection', name: 'Chiral Connection', section: 'Kojima Productions',
      background: Color(0xFF0E1113), surface: Color(0xFF1B2226), accent: Color(0xFF00E5FF),
      textPrimary: Colors.white, textSecondary: Color(0xFF9EAAB8), watermarkAsset: 'odradek', animationType: 'odradek', linkedIcon: '📡 Odradek Scanner ("F")',
    ),
    AppThemeConfig(
      id: 'tactical_stealth', name: 'Tactical Stealth', section: 'Kojima Productions',
      background: Color(0xFF09100D), surface: Color(0xFF12201A), accent: Color(0xFF00FF41),
      textPrimary: Colors.white, textSecondary: Color(0xFF9EB8B0), watermarkAsset: 'codec', animationType: 'codec', linkedIcon: '❗ Codec Alert Icon ("F")',
    ),
    AppThemeConfig(
      id: 'ground_zeroes', name: 'Ground Zeroes HUD', section: 'Kojima Productions',
      background: Color(0xFF080D12), surface: Color(0xFF101A24), accent: Color(0xFF00E5FF),
      textPrimary: Colors.white, textSecondary: Color(0xFF9EB4C8), watermarkAsset: 'idroid', animationType: 'idroid', linkedIcon: '💻 iDroid Hologram ("F")',
    ),

    // Basic & Minimalist
    AppThemeConfig(
      id: 'true_oled', name: 'True OLED', section: 'Basic & Minimalist',
      background: Color(0xFF000000), surface: Color(0xFF111111), accent: Color(0xFFFFFFFF),
      textPrimary: Colors.white, textSecondary: Color(0xFF888888), watermarkAsset: 'none', animationType: 'none', linkedIcon: '🖤 Pitch Black Icon ("F")',
    ),
    AppThemeConfig(
      id: 'streamflix_red', name: 'Streamflix Red', section: 'Basic & Minimalist',
      background: Color(0xFF0D0D0D), surface: Color(0xFF1A1A1A), accent: Color(0xFFE50914),
      textPrimary: Colors.white, textSecondary: Color(0xFF999999), watermarkAsset: 'none', animationType: 'none', linkedIcon: '🔴 Streamflix Badge ("F")',
    ),
    AppThemeConfig(
      id: 'midnight_indigo', name: 'Midnight Indigo', section: 'Basic & Minimalist',
      background: Color(0xFF0A0E17), surface: Color(0xFF141C2E), accent: Color(0xFF00D2FF),
      textPrimary: Colors.white, textSecondary: Color(0xFF9EAEC8), watermarkAsset: 'none', animationType: 'none', linkedIcon: '🌌 Indigo Night Icon ("F")',
    ),
    AppThemeConfig(
      id: 'golden_age', name: 'Golden Age Cinema', section: 'Basic & Minimalist',
      background: Color(0xFF120F0D), surface: Color(0xFF241E1A), accent: Color(0xFFE2B653),
      textPrimary: Colors.white, textSecondary: Color(0xFFC8B8A3), watermarkAsset: 'none', animationType: 'none', linkedIcon: '🎞️ Vintage Film Reel ("F")',
    ),
  ];

  static AppThemeConfig getById(String id) {
    return all.firstWhere((t) => t.id == id, orElse: () => all.first);
  }
}

// -----------------------------------------------------------------------------
// APP STATE & STORAGE MANAGER
// -----------------------------------------------------------------------------

class FramerateState extends ChangeNotifier {
  String currentThemeId = 'pierce_heavens';
  bool linkIconToTheme = true;
  String securityPin = '';
  bool isLocked = false;
  int shuffleIntervalDays = 1;
  
  List<Map<String, dynamic>> mediaList = [
    {
      'id': '1',
      'title': 'Elden Ring: Shadow of the Erdtree',
      'type': 'Game',
      'franchise': 'FromSoftware',
      'watched': false,
      'liked': false,
      'rating': 5,
      'poster': 'https://images.unsplash.com/photo-1542751371-adc38448a05e?w=600',
    },
    {
      'id': '2',
      'title': 'Death Stranding 2: On the Beach',
      'type': 'Game',
      'franchise': 'Kojima Productions',
      'watched': true,
      'liked': true,
      'rating': 5,
      'poster': 'https://images.unsplash.com/photo-1511512578047-dfb367046420?w=600',
    },
    {
      'id': '3',
      'title': 'One Piece: Egghead Arc',
      'type': 'Anime',
      'franchise': 'One Piece',
      'watched': false,
      'liked': true,
      'rating': 5,
      'poster': 'https://images.unsplash.com/photo-1534447677768-be436bb09401?w=600',
    },
    {
      'id': '4',
      'title': 'JoJo\'s Bizarre Adventure: Steel Ball Run',
      'type': 'Manga',
      'franchise': 'JoJo Bizarre Adventure',
      'watched': true,
      'liked': true,
      'rating': 5,
      'poster': 'https://images.unsplash.com/photo-1579783902614-a3fb3927b675?w=600',
    },
  ];

  FramerateState() {
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    currentThemeId = prefs.getString('theme_id') ?? 'pierce_heavens';
    linkIconToTheme = prefs.getBool('link_icon_to_theme') ?? true;
    securityPin = prefs.getString('security_pin') ?? '';
    isLocked = securityPin.isNotEmpty;
    shuffleIntervalDays = prefs.getInt('shuffle_interval') ?? 1;
    notifyListeners();
  }

  Future<void> setTheme(String id) async {
    currentThemeId = id;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('theme_id', id);
    notifyListeners();
  }

  Future<void> setLinkIconToTheme(bool value) async {
    linkIconToTheme = value;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('link_icon_to_theme', value);
    notifyListeners();
  }

  Future<void> setPin(String pin) async {
    securityPin = pin;
    isLocked = pin.isNotEmpty;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('security_pin', pin);
    notifyListeners();
  }

  void randomizeTheme() {
    final randomTheme = ThemePresets.all[DateTime.now().second % ThemePresets.all.length];
    setTheme(randomTheme.id);
  }

  void toggleWatched(String id) {
    final index = mediaList.indexWhere((m) => m['id'] == id);
    if (index != -1) {
      mediaList[index]['watched'] = !mediaList[index]['watched'];
      notifyListeners();
    }
  }

  void toggleLiked(String id) {
    final index = mediaList.indexWhere((m) => m['id'] == id);
    if (index != -1) {
      mediaList[index]['liked'] = !mediaList[index]['liked'];
      notifyListeners();
    }
  }

  Future<void> importCsv() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['csv', 'json'],
    );
    if (result != null) {
      notifyListeners();
    }
  }
}

final FramerateState globalState = FramerateState();

// -----------------------------------------------------------------------------
// ROOT APPLICATION & LOCK SCREEN
// -----------------------------------------------------------------------------

class FramerateApp extends StatelessWidget {
  const FramerateApp({super.key});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: globalState,
      builder: (context, _) {
        final theme = ThemePresets.getById(globalState.currentThemeId);
        return MaterialApp(
          title: 'Framerate',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            brightness: Brightness.dark,
            scaffoldBackgroundColor: theme.background,
            primaryColor: theme.accent,
            colorScheme: ColorScheme.dark(
              primary: theme.accent,
              surface: theme.surface,
              background: theme.background,
            ),
            cardColor: theme.surface,
          ),
          home: globalState.isLocked ? const PinLockScreen() : const MainHomeScreen(),
        );
      },
    );
  }
}

class PinLockScreen extends StatefulWidget {
  const PinLockScreen({super.key});

  @override
  State<PinLockScreen> createState() => _PinLockScreenState();
}

class _PinLockScreenState extends State<PinLockScreen> {
  String enteredPin = '';

  void _onKeyPress(String digit) {
    setState(() {
      if (enteredPin.length < 4) enteredPin += digit;
      if (enteredPin.length == 4) {
        if (enteredPin == globalSt
