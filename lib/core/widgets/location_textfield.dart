import 'package:flutter/material.dart';
import 'package:quickdrop_app/core/widgets/custom_svg.dart' show CustomIcon;
import 'package:quickdrop_app/theme/AppTheme.dart';
import 'package:quickdrop_app/theme/colors.dart';

class NominatimService {
  /// Complete list of Moroccan cities and villages (345 locations)
  static final List<String> moroccanCities = [
    'Casablanca', 'Fes', 'Sale', 'Marrakesh', 'Tangier', 'Rabat', 'Meknes',
    'Oujda', 'Kenitra', 'Agadir', 'Tetouan', 'Safi', 'Temara', 'Inzegan',
    'Mohammedia', 'Laayoune', 'Khouribga', 'Beni Mellal', 'Jdida', 'Taza',
    'Ait Melloul', 'Nador', 'Settat', 'Ksar El Kbir', 'Larache', 'Khemisset',
    'Guelmim', 'Berrechid', 'Wad Zam', 'Fkih Ben Saleh', 'Taourirt', 'Berkane',
    'Sidi Slimane', 'Errachidia', 'Sidi Kacem', 'Khenifra', 'Tifelt', 'Essaouira',
    'Taroudant', 'El Kelaa des Sraghna', 'Oulad Teima', 'Youssoufia', 'Sefrou',
    'Ben Guerir', 'Tan-Tan', 'Ouazzane', 'Guercif', 'Dakhla', 'Hoceima', 'Fnideq',
    'Ouarzazate', 'Tiznit', 'Suq Sebt Oulad Nama', 'Azrou', 'Lahraouyine',
    'Ben Slimane', 'Midelt', 'Jerada', 'Skhirat', 'Souk Larbaa', 'Ain Harrouda',
    'Boujad', 'Kasbat Tadla', 'Sidi Bennour', 'Martil', 'Lqliaa', 'Cape Bojador',
    'Azemmour', 'M\'diq', 'Tinghir', 'Al Aaroui', 'Chefchaouen', 'M\'Rirt', 'Zagora',
    'El Aioun Sidi Mellouk', 'Lamkansa', 'Smara', 'Taounate', 'Bin Anşār', 'Sidi Yahya El Gharb',
    'Zaio', 'Amalou Ighriben', 'Asilah', 'Azilal', 'Mechra Bel Ksiri', 'El Hajeb',
    'Bouznika', 'Imzouren', 'Tahla', 'BouiZazarene Ihaddadene', 'Ain El Aouda', 'Bouarfa',
    'Arfoud', 'Demnate', 'Sidi Slimane Echcharraa', 'Zaouiat Cheikh', 'Ain Taoujdate',
    'Echemmaia', 'Aourir', 'Sabaa Aiyoun', 'Oulad Ayad', 'Ben Ahmed', 'Tabounte',
    'Jorf El Melha', 'Missour', 'Laattaouia', 'Er-Rich', 'Segangan', 'Rissani',
    'Sidi Taibi', 'Sidi Ifni', 'Ait Ourir', 'Ahfir', 'El Ksiba', 'El Gara', 'Drarga',
    'Imintanoute', 'Goulmima', 'Karia Ba Mohamed', 'Mehdya', 'El Borouj', 'Bouhdila',
    'Chichaoua', 'Bni Bouayach', 'Oulad Berhil', 'Jmaat Shaim', 'Bir Jdid', 'Tata',
    'Boujniba', 'Temsia', 'Mediouna', 'Kalaat M\'Gouna', 'Sebt Gzoula', 'Outat El Haj',
    'Imouzzer Kandar', 'Ain Bni Mathar', 'Bouskoura', 'Agourai', 'Midar', 'Lalla Mimouna',
    'Ribat El Kheir', 'Moulay Driss Zerhoun', 'Figuig', 'Boumia', 'Tamallalt', 'Nouaceur',
    'Rommani', 'Jorf', 'Ifran', 'Bouizakarn', 'Oulad Mbarek', 'Afourar', 'Zmamra',
    'Ait Ishaq', 'Tit Mellil', 'Assa', 'Bhalil', 'Targuist', 'Beni Yakhlef', 'El Menzel',
    'Aguelmous', 'Sid L\'Mokhtar', 'Boumalne Dades', 'Farkhana', 'Oulad Abbou', 'Amizmiz',
    'Boulanouare', 'Ben Taieb', 'Ouled Frej', 'Driouch', 'Deroua', 'Hattane', 'El Marsa',
    'Tamanar', 'Ait Iaaza', 'Sidi Allal El Bahraoui', 'Dar Ould Zidouh', 'Sid Zouine',
    'Boudnib', 'Foum Zguid', 'Tissa', 'Jaadar', 'Oulmes', 'Bouknadel', 'Harhoura',
    'El Guerdan', 'Selouane', 'Maaziz', 'Oulad M\'Rah', 'Loudaya', 'Massa', 'Aklim',
    'Ouaouizert', 'Bni Drar', 'El Kbab', 'Oued Amlil', 'Sidi Rahel Chatai', 'Guigou',
    'Agdz', 'Khnichet', 'Karia', 'Sidi Ahmed', 'Zag', 'Oulad Yaich', 'Tinjdad',
    'Ouad Laou', 'Tighassaline', 'Tounfit', 'Bni Tadjite', 'Bouanane', 'Oulad Hriz Sahel',
    'Talsint', 'Taghjijt', 'Boulemane', 'Zirara', 'Taouima', 'Tahannaout', 'Bradia',
    'Moulay Abdallah', 'Sidi Rahal', 'Tameslouht', 'Aghbala', 'El Ouatia', 'Tendrara',
    'Taznakht', 'Fam El Hisn', 'Akka', 'Dar Gueddari', 'Itzer', 'Taliouine', 'Oualidia',
    'Aoulouz', 'Moulay Bousselham', 'Tarfaya', 'Ghafsai', 'Foum Jamaa', 'Ain Leuh',
    'Moulay Bouazza', 'Kariat Arkmane', 'Kehf Nsour', 'Sidi Bou Othmane', 'Oulad Tayeb',
    'Had Kourt', 'Bab Berrad', 'Loulad', 'Zaida', 'Tafrawt', 'Khemis Sahel', 'Ait Baha',
    'Biougra', 'Dar Bni Karrich', 'El Hanchane', 'Sidi Jaber', 'Irherm', 'Debdou',
    'Ras Kebdana', 'Laaounate', 'Hadj Kaddour', 'Skhour Rhamna', 'Bzou', 'Ain Cheggag',
    'Bouderbala', 'Sidi Smail', 'Oulad Zbair', 'Bni Chiker', 'Lakhsas', 'Talmest', 'Aknoul',
    'Tiztoutine', 'Bab Taza', 'Imouzzer Marmoucha', 'Gourrama', 'Ajdir', 'Mhaya',
    'Oulad Ghadbane', 'Zrarda', 'Zoumi', 'Ain Karma', 'Thar Essouk', 'Lagouira', 'Ras El Ain',
    'Sidi Ali Ben Hamdouche', 'Sebt Jahjouh', 'Tiddas', 'Zaouiat Bougrin', 'Tafersit',
    'Touissit', 'Saidia', 'Lalla Takerkoust', 'Skhinate', 'Moulay Brahim', 'Soualem',
    'Gueznaia', 'Moulay Yacoub', 'Sidi Allal Tazi', 'Laakarta', 'Alnif', 'Dar El Kebdani',
    'Jebha', 'Ain Erreggada', 'Sidi Addi', 'Skoura', 'Smimou', 'Ain Jemaa', 'Timahdite',
    'Ait Daoud', 'Souk El Had', 'Had Bouhssoussen', 'Oulad Said', 'Arbaoua', 'Ain Dorij',
    'Madagh', 'Tighza', 'Matmata', 'Kerouna', 'Kassita', 'Bni Hadifa', 'Oued El Heimar',
    'Kerrouchen', 'Tainaste', 'Guisser', 'Sidi Boubker', 'Tamassint', 'Assahrij',
    'Aghbalou Nssardane', 'Tizi Ouasli', 'Moqrisset', 'Sebt Lamaarif', 'Issaguen', 'Bouguedra',
    'Brikcha', 'Ighoud', 'Ajdir, Taza', 'Oulad Amrane', 'Kettara', 'Aoufous', 'Tafetachte',
    'Naima', 'Tnin Sidi Lyamani', 'N\'Zalat Bni Amar', 'Ahrara', 'Sidi Abdallah Ghiat',
    'Sidi Bouzid', 'Ounagha', 'Moulay Idris', 'Volubilis', 'Al Hoceima', 'El Jadida',
  ];

  static Future<List<String>> getSuggestions(String query) async {
    if (query.isEmpty) return [];

    final lowerQuery = query.toLowerCase().trim();
    
    // Filter cities that start with the query (prioritize exact prefix matches)
    final startsWith = moroccanCities
        .where((city) => city.toLowerCase().startsWith(lowerQuery))
        .toList();

    // If we have prefix matches, return them
    if (startsWith.isNotEmpty) {
      return startsWith;
    }

    // Otherwise, return cities that contain the query
    return moroccanCities
        .where((city) => city.toLowerCase().contains(lowerQuery))
        .toList();
  }
}

class LocationTextField extends StatefulWidget {
  final TextEditingController controller;
  final String hintText;
  final String headerText;
  bool displayHeader = true;
  bool isRequired = true;
  final Color iconColor ;
  final Function(String)? onLocationSelected;

   LocationTextField({
    super.key,
    required this.controller,
    required this.hintText,
    required this.headerText,
    this.displayHeader = true,
    this.isRequired = true,
    this.iconColor = AppColors.lessImportant,
    this.onLocationSelected,
  });

  @override
  State<LocationTextField> createState() => _LocationTextFieldState();
}

class _LocationTextFieldState extends State<LocationTextField> {
  List<String> _suggestions = [];
  bool _isLoading = false;
  final LayerLink _layerLink = LayerLink();
  OverlayEntry? _overlayEntry;

  Future<void> _fetchSuggestions(String input) async {
    if (input.isEmpty) {
      _hideOverlay();
      return;
    }

    setState(() => _isLoading = true);

    try {
      final results = await NominatimService.getSuggestions(input);

      if (mounted) {
        setState(() {
          _suggestions = results;
          _isLoading = false;
        });

        if (results.isNotEmpty) {
          _showOverlay();
        } else {
          _hideOverlay();
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        _hideOverlay();
      }
    }
  }

  void _showOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        width: 300,
        child: CompositedTransformFollower(
          link: _layerLink,
          showWhenUnlinked: false,
          offset: const Offset(0, 56),
          child: Material(
            elevation: 10,
            borderRadius: BorderRadius.circular(8),
            child: SizedBox(
              height: 250,
              child: ListView.builder(
                padding: EdgeInsets.zero,
                itemCount: _suggestions.length,
                itemBuilder: (context, index) {
                  final suggestion = _suggestions[index];
                  return ListTile(
                    leading:  CustomIcon(
                        iconPath: "assets/icon/map-point.svg",
                        size: 16,
                        color: widget.iconColor,
                      ),
                    title: Text(
                      suggestion,
                      style: const TextStyle(fontSize: 14),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    onTap: () {
                      widget.controller.text = suggestion;
                      widget.onLocationSelected?.call(suggestion);
                      _hideOverlay();
                    },
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );

    Overlay.of(context).insert(_overlayEntry!);
  }

  void _hideOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  @override
  void dispose() {
    _hideOverlay();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
     final BorderSide borderSide = BorderSide(
      color: Colors.grey.shade200,
      width: AppTheme.textFieldBorderWidth,
    );

     final BorderSide focusedBorderSide = BorderSide(
      color:  AppColors.blue,
      width: 2,
    );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
         if (widget.displayHeader)
            Text(
              widget.headerText,
              style: const TextStyle(
                color: AppColors.headingText,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
            if (widget.isRequired)
              const Text(
                ' *',
                style: TextStyle(
                  color: Colors.red,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
          

        if (widget.displayHeader) const SizedBox(height: 8),
        CompositedTransformTarget(
          link: _layerLink,
          child: TextFormField(
                  controller: widget.controller,
                  onChanged: _fetchSuggestions,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: AppColors.shipmentText,
                  ),
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.grey.shade50,
                    contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                    hintText: widget.hintText,
                    hintStyle: const TextStyle(
                      color: Color(0xFF9CA3AF),
                      fontWeight: FontWeight.normal,
                    ),
                    enabledBorder: OutlineInputBorder(
                    borderSide: borderSide,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: focusedBorderSide,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderSide: const BorderSide(
                      color: AppColors.error,
                      width: AppTheme.textFieldBorderWidth,
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  focusedErrorBorder: OutlineInputBorder(
                    borderSide: const BorderSide(
                      color: AppColors.error,
                      width: AppTheme.textFieldBorderWidth,
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                    prefixIcon: Padding(
                      padding: const EdgeInsets.all(12),
                      child: CustomIcon(
                        iconPath: "assets/icon/map-point.svg",
                        size: 20,
                        color: widget.iconColor,
                      ),
                    ),        
                  ),
                    
                  
                ),
        ),
        if (_isLoading)
          const Padding(
            padding: EdgeInsets.only(top: 8),
            child: LinearProgressIndicator(minHeight: 2),
          ),
      ],
    );
  }
}