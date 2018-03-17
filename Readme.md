# Tic Tac Toe with Godot

My first Godot game!

[Screenshot]: https://github.com/richardeigenmann/Godot-TicTacToe/Screenshots/Screenshot.png

Wikipedia has an article about the Game: https://en.wikipedia.org/wiki/Tic-tac-toe

## Motivation

My motivation is to learn to use the Godot Game engine after being introduced to
it at Fosdem 2017 and Fosdem 2018 (v3).

## Notable points

The Board has 4 TextureRect bars to make the 9 slot grid.

A TileButton class which extends Button has a click listener and an internal
state.

9 of these TileButtons are added to each of the slot grids. The TileButtons are
all added to a Group called Tiles.

Thus the data model of the game is held in the TileButton nodes of the Tiles
group. This allows game logic to query the state using the GDScript call:

```python
get_tree().get_nodes_in_group("Tiles")
```

Global State: the game has some global state like whether it's the human's turn
and whether the human is playing X or O. The Tile can query this using the
`get_node(/root/Board")` function.

## Algos

One of the interesting things about programming the game is how to actually
program the winning algorithm. Wikipedia has a (self confessed) broken algo.
MinMax is billed to be the smarter choice. Random clearly isn't so great.

I've chosen to add non displaying nodes to the Game that have the following
interface function:

```python
func playMove( player, opponent ):
```

This allows me to call the `playMove` function in the Bard GDScript on whichever
Algo I choose.


## TODO

* Add unit tests: https://github.com/bitwes/Gut
* Add autoplay
* The logic from Wikipedia doesn't work!
