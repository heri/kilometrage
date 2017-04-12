# Calcul Kilométrage

* Auteur: [Heri Rakotomalala](http://github.com/heri)
* Date de révision: 18 Avril 2017

Cette application calcule le kilométrage d'un véhicule suivant un fichier contenant les coordonnées lat, long


## Utilisation

* Code

```
git clone git@github.com:heri/kilometrage.git
cd kilometrage && bundle install
```

`bundle` peut prendre un peu de temps

* config sqlite

```
rake db:create
rake db:migrate
```

* optionel : tests

```
rake cucumber
```

* lancer le serveur

```
rails s
```

* Tester l'app à `http://localhost:3000`. Il y a des fichiers de coordonnées dans `/features/asset_specs`, au besoin
