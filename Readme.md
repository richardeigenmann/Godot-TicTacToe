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

``` python
get_tree().get_nodes_in_group("Tiles")
```

Global State: the game has some global state like whether it's the human's turn 
and whether the human is playing X or O. The Tile can query this using the 
`get_node(/root/Board")` function.

# TODO

Add unit tests: https://github.com/bitwes/Gut
Add autoplay
