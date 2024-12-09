import 'package:flutter/material.dart';
import 'dart:math';
import 'package:collection/collection.dart';

void main() {
  runApp(MonApplication());
}

class MonApplication extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Jeu 2048 - Projet MOUSSA BENYACINE Ishaq',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: PlateauDeJeu(),
    );
  }
}

// Classe representant le plateau de jeu
class PlateauDeJeu extends StatefulWidget {
  @override
  _EtatPlateauDeJeu createState() => _EtatPlateauDeJeu();
}

class _EtatPlateauDeJeu extends State<PlateauDeJeu> {
  // Grille de jeu
  List<List<int>> grille = List.generate(4, (_) => List.generate(4, (_) => 0));
  int score = 0; // Score actuel
  bool jeuTermine = false; // Indique si le jeu est termine
  bool jeuGagne = false; // Indique si le joueur a gagne
  int valeurCible = 2048; // Valeur a atteindre pour gagner

  @override
  void initState() {
    super.initState();
    _ajouterTuileAleatoire(); // Ajout deux tuiles au debut
    _ajouterTuileAleatoire();
  }

  // Ajoute une tuile dans une case vide
  void _ajouterTuileAleatoire() {
    Random hasard = Random();
    List<List<int>> casesVides = [];

    for (int ligne = 0; ligne < 4; ligne++) {
      for (int colonne = 0; colonne < 4; colonne++) {
        if (grille[ligne][colonne] == 0) {
          casesVides.add([ligne, colonne]);
        }
      }
    }

    if (casesVides.isNotEmpty) {
      List<int> caseAleatoire = casesVides[hasard.nextInt(casesVides.length)];
      int ligne = caseAleatoire[0];
      int colonne = caseAleatoire[1];
      int valeur = hasard.nextBool() ? 2 : 4;

      setState(() {
        grille[ligne][colonne] = valeur;
      });
    }
  }

  // Verifie si le joueur a gagne
  bool _verifierVictoire() {
    for (int ligne = 0; ligne < 4; ligne++) {
      for (int colonne = 0; colonne < 4; colonne++) {
        if (grille[ligne][colonne] == valeurCible) {
          return true;
        }
      }
    }
    return false;
  }

  // Verifie si le jeu est termine
  bool _verifierJeuTermine() {
    for (int ligne = 0; ligne < 4; ligne++) {
      for (int colonne = 0; colonne < 4; colonne++) {
        if (grille[ligne][colonne] == 0) {
          return false;
        }
        if (ligne < 3 && grille[ligne][colonne] == grille[ligne + 1][colonne]) {
          return false;
        }
        if (colonne < 3 &&
            grille[ligne][colonne] == grille[ligne][colonne + 1]) {
          return false;
        }
      }
    }
    return true;
  }

  // Deplace les tuiles vers la gauche
  bool _deplacerGauche() {
    bool deplacementEffectue = false;
    int nouveauScore = score;

    List<List<int>> ancienneGrille =
    grille.map((ligne) => List<int>.from(ligne)).toList();

    for (int ligne = 0; ligne < 4; ligne++) {
      List<int> nouvelleLigne = grille[ligne].where((e) => e != 0).toList();
      for (int i = 0; i < nouvelleLigne.length - 1; i++) {
        if (nouvelleLigne[i] == nouvelleLigne[i + 1]) {
          nouvelleLigne[i] *= 2;
          nouveauScore += nouvelleLigne[i];
          nouvelleLigne.removeAt(i + 1);
          deplacementEffectue = true;
        }
      }
      while (nouvelleLigne.length < 4) {
        nouvelleLigne.add(0);
      }
      grille[ligne] = nouvelleLigne;
    }

    if (!ListEquality().equals(grille, ancienneGrille)) {
      deplacementEffectue = true;
      setState(() {
        score = nouveauScore;
      });
    }

    return deplacementEffectue;
  }

  // Deplace les tuiles vers la droite
  bool _deplacerDroite() {
    setState(() {
      grille = grille.map((ligne) => ligne.reversed.toList()).toList();
    });

    bool deplacementEffectue = _deplacerGauche();

    setState(() {
      grille = grille.map((ligne) => ligne.reversed.toList()).toList();
    });

    return deplacementEffectue;
  }

  // Deplace les tuiles vers le haut
  bool _deplacerHaut() {
    setState(() {
      grille = List.generate(
        4,
            (colonne) =>
            List.generate(4, (ligne) => grille[ligne][colonne], growable: false),
      );
    });

    bool deplacementEffectue = _deplacerGauche();

    setState(() {
      grille = List.generate(
        4,
            (ligne) =>
            List.generate(4, (colonne) => grille[colonne][ligne], growable: false),
      );
    });

    return deplacementEffectue;
  }

  // Deplace les tuiles vers le bas
  bool _deplacerBas() {
    setState(() {
      grille = List.generate(
        4,
            (colonne) =>
            List.generate(4, (ligne) => grille[ligne][colonne], growable: false),
      );
    });

    setState(() {
      grille = grille.map((ligne) => ligne.reversed.toList()).toList();
    });

    bool deplacementEffectue = _deplacerGauche();

    setState(() {
      grille = grille.map((ligne) => ligne.reversed.toList()).toList();
    });

    setState(() {
      grille = List.generate(
        4,
            (ligne) =>
            List.generate(4, (colonne) => grille[colonne][ligne], growable: false),
      );
    });

    return deplacementEffectue;
  }

  // Reinitialise le jeu
  void _reinitialiserJeu() {
    setState(() {
      grille = List.generate(4, (_) => List.generate(4, (_) => 0));
      score = 0;
      jeuTermine = false;
      jeuGagne = false;
      _ajouterTuileAleatoire();
      _ajouterTuileAleatoire();
    });
  }

  // Determine la couleur d'une tuile en fonction de la valeur
  Color _obtenirCouleurTuile(int valeur) {
    switch (valeur) {
      case 2:
        return Color(0xFFE4C693);
      case 4:
        return Color(0xFFDACD88);
      case 8:
        return Color(0xFFB7F37A);
      case 16:
        return Color(0xFF64F670);
      case 32:
        return Color(0xFF5FF7DB);
      case 64:
        return Color(0xFF3BBFF7);
      case 128:
        return Color(0xFFDD73ED);
      case 256:
        return Color(0xFFDF62ED);
      case 512:
        return Color(0xFFED50D3);
      case 1024:
        return Color(0xFFED3FC4);
      case 2048:
        return Color(0xFFED2EAA);
      default:
        return Color(0xFFA9A9A9);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (jeuGagne) {
      return _afficherDialogFin("Vous avez gagne !");
    }

    if (jeuTermine) {
      return _afficherDialogFin("Vous avez perdu !");
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Jeu 2048'),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'Score : $score',
              style: TextStyle(fontSize: 20),
            ),
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _afficherGrille(),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _reinitialiserJeu,
              child: Text("Recommencer"),
            ),
          ],
        ),
      ),
    );
  }

  // Affiche un message de fin de partie
  Widget _afficherDialogFin(String message) {
    return Scaffold(
      appBar: AppBar(title: Text('Jeu 2048')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              message,
              style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _reinitialiserJeu,
              child: Text("Recommencer"),
            ),
          ],
        ),
      ),
    );
  }

  // Affiche la grille de jeu
  Widget _afficherGrille() {
    return GestureDetector(
      onHorizontalDragEnd: (details) {
        if (details.primaryVelocity! < 0) {
          if (_deplacerGauche()) {
            _ajouterTuileAleatoire();
            _verifierEtatJeu();
          }
        } else if (details.primaryVelocity! > 0) {
          if (_deplacerDroite()) {
            _ajouterTuileAleatoire();
            _verifierEtatJeu();
          }
        }
      },
      onVerticalDragEnd: (details) {
        if (details.primaryVelocity! < 0) {
          if (_deplacerHaut()) {
            _ajouterTuileAleatoire();
            _verifierEtatJeu();
          }
        } else if (details.primaryVelocity! > 0) {
          if (_deplacerBas()) {
            _ajouterTuileAleatoire();
            _verifierEtatJeu();
          }
        }
      },
      child: SizedBox(
        height: MediaQuery.of(context).size.width,
        child: GridView.builder(
          physics: NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
          ),
          itemCount: 16,
          itemBuilder: (context, index) {
            int ligne = index ~/ 4;
            int colonne = index % 4;
            int valeur = grille[ligne][colonne];
            return Container(
              margin: EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: _obtenirCouleurTuile(valeur),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(
                child: Text(
                  valeur > 0 ? '$valeur' : '',
                  style: TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                    color: valeur >= 128 ? Colors.white : Colors.black,
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  // Verifie l'etat du jeu
  void _verifierEtatJeu() {
    if (_verifierVictoire()) {
      setState(() {
        jeuGagne = true;
      });
    }
    if (_verifierJeuTermine()) {
      setState(() {
        jeuTermine = true;
      });
    }
  }
}
