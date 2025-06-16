# Tic Tac Toe with the Godot Game Engine

## What you find here

You will find a functional TicTacToe game here that runs in the Godot Game Engine.

The game can be compiled into an Android APK which can be installed and played on your Android Phone.

The computer opponent plays based on a weak algorythm.

## What this is not

This is not a sophisticated TicTacToe game. The algo is flawed, the graphics are ugly and the code reeks of immaturity.

## Motivation

My motivation is to learn to use the Godot Game engine after being introduced to it at Fosdem 2017 and Fosdem 2018. It's also really cool that the game can be compiled to an apk format and can be installed on an Android phone.

## How to try it out

First you need to install the Godot Engine from
https://godotengine.org/

Note that this has not been upgraded from Version 3 so get the V3 Engine.

```bash
# clone the repo
git clone https://github.com/richardeigenmann/Godot-TicTacToe.git

cd Godot-TicTacToe
Godot_v3.5.1-stable_x11.64
```

I.e. change into the directory with the game and start the Godot executable. When Godot is started it looks at the current working directory and if it finds a game there, it starts it.

## Developer Notes

The Board has 4 TextureRect bars to make the 9 slot grid.

A TileButton class which extends Button has a click listener and an internal state.

9 of these TileButtons are added to each of the slot grids. The TileButtons are all added to a Group called Tiles.

Thus the data model of the game is held in the TileButton nodes of the Tiles group. This allows game logic to query the state using the GDScript call:

```python
get_tree().get_nodes_in_group("Tiles")
```

Global State: the game has some global state like whether it's the human's turn and whether the human is playing X or O. The Tile can query this using the `get_node(/root/Board")` function.

I've chosen to add non displaying nodes to the Game that have the following interface function:

```python
func playMove( player, opponent ):
```

This allows me to call the `playMove` function in the Bard GDScript on whichever Algo I choose.

## Algos

One of the interesting things about programming the game is how to actually program the winning algorithm. Wikipedia has a (self confessed) broken algo.

MinMax is billed to be the smarter choice. Random clearly isn't so great.

## TODO

* Add unit tests: https://github.com/bitwes/Gut
* Add autoplay like in the movie 'War Games'
* Find a way to implement game logic that works
* Upgrade to V4
* Make the game look nice
* Add a screenshot

## Further reading

Wikipedia has an article about the Game: https://en.wikipedia.org/wiki/Tic-tac-toe
