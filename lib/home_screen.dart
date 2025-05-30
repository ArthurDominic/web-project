import 'package:flutter/material.dart';
import 'movie_detail_screen.dart';
import 'music_screen.dart';
class HomeScreen extends StatefulWidget {
  static const routeName = '/home';

  HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();
  bool _showSearchBar = false;

  final List<Map<String, String>> _allMovies = [
    {'title': 'Movie 1', 'image': 'assets/movie1.jpg', 'video': 'assets/movie1.mp4'},
    {'title': 'Movie 2', 'image': 'assets/movie2.jpg', 'video': 'assets/movie2.mp4'},
    {'title': 'Movie 3', 'image': 'assets/movie3.jpg', 'video': 'assets/movie3.mp4'},
    {'title': 'Movie 4', 'image': 'assets/movie4.jpg', 'video': 'assets/movie4.mp4'},
    {'title': 'Movie 5', 'image': 'assets/movie5.jpg', 'video': 'assets/movie5.mp4'},
    {'title': 'Movie 6', 'image': 'assets/movie6.jpg', 'video': 'assets/movie6.mp4'},
    {'title': 'Movie 7', 'image': 'assets/movie7.jpg', 'video': 'assets/movie7.mp4'},
    {'title': 'Movie 8', 'image': 'assets/movie8.jpg', 'video': 'assets/movie8.mp4'},
    {'title': 'Movie 9', 'image': 'assets/movie9.jpg', 'video': 'assets/movie9.mp4'},
    {'title': 'Movie 10', 'image': 'assets/movie10.jpg', 'video': 'assets/movie10.mp4'},
    {'title': 'Movie 11', 'image': 'assets/movie11.jpg', 'video': 'assets/movie11.mp4'},
    {'title': 'Movie 12', 'image': 'assets/movie12.jpg', 'video': 'assets/movie12.mp4'},
    {'title': 'Movie 13', 'image': 'assets/movie13.jpg', 'video': 'assets/movie13.mp4'},
  {'title': 'Movie 14', 'image': 'assets/movie14.jpg', 'video': 'assets/movie14.mp4'},
  {'title': 'Movie 15', 'image': 'assets/movie15.jpg', 'video': 'assets/movie15.mp4'},
  {'title': 'Movie 16', 'image': 'assets/movie16.jpg', 'video': 'assets/movie16.mp4'},
  {'title': 'Movie 17', 'image': 'assets/movie17.jpg', 'video': 'assets/movie17.mp4'},
  {'title': 'Movie 18', 'image': 'assets/movie18.jpg', 'video': 'assets/movie18.mp4'},
  {'title': 'Movie 19', 'image': 'assets/movie19.jpg', 'video': 'assets/movie19.mp4'},
  {'title': 'Movie 20', 'image': 'assets/movie20.jpg', 'video': 'assets/movie20.mp4'},
  {'title': 'Movie 21', 'image': 'assets/movie21.jpg', 'video': 'assets/movie21.mp4'},
  {'title': 'Movie 22', 'image': 'assets/movie22.jpg', 'video': 'assets/movie22.mp4'},
  {'title': 'Movie 23', 'image': 'assets/movie23.jpg', 'video': 'assets/movie23.mp4'},
  {'title': 'Movie 24', 'image': 'assets/movie24.jpg', 'video': 'assets/movie24.mp4'},
  {'title': 'Movie 25', 'image': 'assets/movie25.jpg', 'video': 'assets/movie25.mp4'},
  {'title': 'Movie 26', 'image': 'assets/movie26.jpg', 'video': 'assets/movie26.mp4'},
  {'title': 'Movie 27', 'image': 'assets/movie27.jpg', 'video': 'assets/movie27.mp4'},
  {'title': 'Movie 28', 'image': 'assets/movie28.jpg', 'video': 'assets/movie28.mp4'},
  {'title': 'Movie 29', 'image': 'assets/movie29.jpg', 'video': 'assets/movie29.mp4'},
  {'title': 'Movie 30', 'image': 'assets/movie30.jpg', 'video': 'assets/movie30.mp4'},
  {'title': 'Movie 31', 'image': 'assets/movie31.jpg', 'video': 'assets/movie31.mp4'},
  {'title': 'Movie 32', 'image': 'assets/movie32.jpg', 'video': 'assets/movie32.mp4'},
  {'title': 'Movie 33', 'image': 'assets/movie33.jpg', 'video': 'assets/movie33.mp4'},
  {'title': 'Movie 34', 'image': 'assets/movie34.jpg', 'video': 'assets/movie34.mp4'},
  {'title': 'Movie 35', 'image': 'assets/movie35.jpg', 'video': 'assets/movie35.mp4'},
  {'title': 'Movie 36', 'image': 'assets/movie36.jpg', 'video': 'assets/movie36.mp4'},

  ];

  List<Map<String, String>> _filteredMovies = [];

  @override
  void initState() {
    super.initState();
    _filteredMovies = List.from(_allMovies);
    _searchController.addListener(_filterMovies);
  }

  void _filterMovies() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredMovies = _allMovies
          .where((movie) => movie['title']!.toLowerCase().contains(query))
          .toList();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final crossAxisCount = screenWidth > 1000 ? 6 : screenWidth > 600 ? 4 : 2;

   return Scaffold(
  appBar: AppBar(
    title: Image.asset('assets/netflix_logo.png', height: 50),
    backgroundColor: Colors.black,
    actions: [
      IconButton(
        icon: _showSearchBar ? const Icon(Icons.close) : const Icon(Icons.search),
        onPressed: () {
          setState(() {
            _showSearchBar = !_showSearchBar;
            if (!_showSearchBar) {
              _searchController.clear();
            } 
          });
        },
      ),
      IconButton(
        icon: const Icon(Icons.account_circle),
        onPressed: () {},
      ),
    ],
  ),
  backgroundColor: Colors.black,
  body: Column(
    children: [
      if (_showSearchBar)
        Container(
          color: Colors.black,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: TextField(
            controller: _searchController,
            style: const TextStyle(color: Colors.white),
            decoration: const InputDecoration(
              hintText: 'Search movies...',
              hintStyle: TextStyle(color: Colors.white54),
              filled: true,
              fillColor: Colors.grey,
              border: OutlineInputBorder(borderSide: BorderSide.none),
              contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 0),
            ),
          ),
        ),
      Expanded(
        child: GridView.builder(
          padding: EdgeInsets.zero,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            crossAxisSpacing: 0,
            mainAxisSpacing: 0,
            childAspectRatio: 2 / 3,
          ),
          itemCount: _filteredMovies.length,
          itemBuilder: (context, index) {
            final movie = _filteredMovies[index];
            return GestureDetector(
              onTap: () {
                Navigator.of(context).pushNamed(
                  MovieDetailScreen.routeName,
                  arguments: movie,
                );
              },
              child: Stack(
                children: [
                  Positioned.fill(
                    child: Image.asset(
                      movie['image']!,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      color: Colors.black54,
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: Text(
                        movie['title']!,
                        style: const TextStyle(color: Colors.white, fontSize: 12),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    ],
  ),
  bottomNavigationBar: BottomNavigationBar(
    backgroundColor: Colors.black,
    selectedItemColor: Colors.red,
    unselectedItemColor: Colors.white70,
    type: BottomNavigationBarType.fixed,
    items: const [
      BottomNavigationBarItem(
        icon: Icon(Icons.home),
        label: 'Home',
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.movie),
        label: 'Movies',
        ),
      BottomNavigationBarItem(
        icon: Icon(Icons.search),
        label: 'Search',
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.music_note),
        label: 'Music',
     
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.more_horiz),
        label: 'More',
      ),
    ],
    onTap: (index) {
      // You can implement navigation logic here
    },
  ),
);
  }
}