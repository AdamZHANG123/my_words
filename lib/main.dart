import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';

final _biggerFont = const TextStyle(fontSize: 18.0);

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My App',
      home: RandomWords(),
    );
  }
}

class RandomWords extends StatefulWidget {
  @override
  _RandomWordsState createState() => _RandomWordsState();
}

class _RandomWordsState extends State<RandomWords> {
  final _suggestions = <WordPair>[];
  Set<WordPair> _savedSuggestions = Set<WordPair>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Startup Name Generator'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.list),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => LikedSuggestions(
                          saved: _savedSuggestions,
                        )),
              );
            },
          )
        ],
      ),
      body: _buildSuggestions(),
    );
  }

  Widget _buildSuggestions() {
    return ListView.builder(
      padding: const EdgeInsets.all(16.0),
      itemBuilder: (context, i) {
        if (i.isOdd) return Divider();
        final index = i ~/ 2;
        if (index >= _suggestions.length) {
          _suggestions.addAll(generateWordPairs().take(10));
        }
        return _buildRow(_suggestions[index]);
      },
    );
  }

  Widget _buildRow(WordPair pair) {
    final _savedAlready = _savedSuggestions.contains(pair);

    return ListTile(
      title: Text(
        pair.asPascalCase,
        style: _biggerFont,
      ),
      trailing: Icon(
        _savedAlready ? Icons.favorite : Icons.favorite_border,
        color: _savedAlready ? Colors.red : null,
      ),
      onTap: () {
        setState(() {
          _savedAlready
              ? _savedSuggestions.remove(pair)
              : _savedSuggestions.add(pair);
          print(_savedSuggestions);
        });
      },
    );
  }
}

class LikedSuggestions extends StatelessWidget {
  final Set<WordPair> saved;

  LikedSuggestions({Key key, this.saved}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final tiles = saved.map((WordPair pair) {
      return ListTile(
        title: Text(
          pair.asPascalCase,
          style: _biggerFont,
        ),
      );
    });

    final divided =
        ListTile.divideTiles(context: context, tiles: tiles).toList();

    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text('Liked Suggestions'),
        ),
        body: ListView(
          children: divided,
        ));
  }
}
