# Tic Tac Toe with Godot

My first Godot game!

[Screenshot]: https://github.com/richardeigenmann/Godot-TicTacToe/Screenshots/Screenshot.png

Wikipedia has an article about the Game: https://en.wikipedia.org/wiki/Tic-tac-toe

## Motivation

My motivation is to learn to use the Godot Game engine after bein introduced to
it at Fosdem 2017 and Fosdem 2018 (v 3).

## Notable points

The Board has 4 TextureTect bar to make the 9 slot grid.

A TileButton class which extend Button has a click listener and an internal 
state.

9 of these TileButtons are added to each of the slot grids. The TileButtons are 
all added to a Group called Tiles.

Thus the data model of the game is held in the TileButton nodes of the Tiles 
group. This allows game logic to query the state using the GDScript call:

```GDScript
get_tree().get_nodes_in_group("Tiles")
```

The xWins and oWins functions are hard coded against the element positions of
the group. Not using a loop is perhaps lazy and error prone but on the other hand 
the computer needs to do all the same tests anyway so it doesn't really matter.

Problem: How to record global state so that after the player has played we need 
the opponent to play?



