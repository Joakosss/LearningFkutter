import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

//Flutter ejecuta la app llamada MyApp
void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MyAppState(),
      child: MaterialApp(
        title: 'Namer App',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.lightGreen),
        ),
        home: MyHomePage(),
      ),
    );
  }
}

// Clase de Flutter que notifica a otros cuando su valor es modificado
// En este caso current que es una palabra random de Word Pair
class MyAppState extends ChangeNotifier {
  var current = WordPair.random();

  // mi primera funcion!!
  void getNext() {
    //Actualizamos el current, y anunciamos que fue modificado
    //para que los widget con watch se re rendericen
    current = WordPair.random();
    notifyListeners();
  }

  //Creamos logica para guardar palabras favoritas C:
  //WordPair lista de pares como estilo de diccionarios clave : valor
  var favorites = <WordPair>[];
  void togleFavorite() {
    if (favorites.contains(current)) {
      favorites.remove(current);
    } else {
      favorites.add(current);
    }
    notifyListeners();
  }
}

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    var pair = appState.current;

    IconData icon;
    if (appState.favorites.contains(pair)) {
      icon = Icons.favorite;
    } else {
      icon = Icons.favorite_border;
    }

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            BigCard(pair: pair),
            SizedBox(
              height: 10,
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                FilledButton.icon(
                    onPressed: () {
                      appState.togleFavorite();
                    },
                    icon: Icon(icon),
                    label: Text("Like")),
                SizedBox(width: 10),
                FilledButton(
                    onPressed: () {
                      appState.getNext();
                    },
                    child: Text("Next")),
              ],
            )
          ],
        ),
      ),
    );
  }
}

class BigCard extends StatelessWidget {
  const BigCard({
    super.key,
    required this.pair,
  });

  final WordPair pair;

  @override
  Widget build(BuildContext context) {
    //accedo al tema del contexto
    final theme = Theme.of(context);

    //Genero un style
    final style = theme.textTheme.displayMedium!
        .copyWith(color: theme.colorScheme.onPrimary);

    return Card(
      color: theme.colorScheme.primary,
      elevation: 5,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Text(
          pair.asLowerCase,
          //Le pasamos el texto en minuscula
          style: style,
        ),
      ),
    );
  }
}
