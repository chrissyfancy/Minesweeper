## Introduction

Let's recreate [Minesweeper][minesweeper] in Ruby!

![Minesweeper][minesweeper-screenshot]

### Learning Goals

* Choose an appropriate data structure to represent a game world.
* Write Ruby methods to create your game.

### Instructions

Implement some missing methods in the `Minefield` class to build a version of [Minesweeper][minesweeper].

The [gosu][gosu] library is used to handle the graphics and user input within the `Minesweeper` class. At this point in your Ruby journey, don't spend _too_ much time worrying about how gosu works. Your job is to write Ruby methods; Let gosu do the work of giving you a fun graphical interface on which to play your game!

To install the `gosu` gem, simply run the following commands:

```no-highlight
$ brew install sdl2
$ gem install gosu
```

After you've done so, please take a look at the provided files in the challenge directory.

* `minesweeper.rb` contains the code which interacts with the gosu library, handles drawing the minefield on the screen, and facilitates user interaction. You do not need to alter this code.
* `minefield.rb` handles the state of the game.
* `cell.rb` handles the state of each cell in the minefield.

Most of the work you will need to do is in the `Minefield` and `Cell` classes. Let's start with the `Cell` class.

## Cell

Think about an individual cell in the game of Minesweeper. Ask yourself, what are the different states that a cell can have? It can have a `mine` hidden in it. It can be `revealed` when a user clicks on it. (We won't worry about flags, for now.)

Based on these specifications, this could be one implementation of our `Cell` class:

```
class Cell
  def initialize
    @mine = false
    @revealed = false
  end

  def place_mine
    @mine = true
  end

  def contains_mine?
    @mine
  end

  def reveal!
    @revealed = true
  end

  def revealed?
    @revealed
  end
end
```

## Minefield

Now it's up to you to complete the game! Browse the provided code structure for the `Minefield` class. What problems will you need to solve in order to make this game functional?

Below are a few suggestions to get you started. We have also provided some ideas within the `minefield.rb` file itself.

* How will you plant mines on the board upon starting a new game?
* Upon uncovering a cell, how will you identify the number of adjacent mines?
* How will you determine whether a player has won or lost a game?

Feel free to make some notes or write out some pseudo-code in the file as you start!

## Extra Resources

* [Spencer Dixon's Gosu Tutorial](https://github.com/SpencerCDixon/Gosu-Tutorial)
* [Gosu Documentation](https://github.com/gosu/gosu/wiki/Ruby-Tutorial)

[minesweeper]: http://en.wikipedia.org/wiki/Minesweeper_(video_game)
[gosu]: http://www.libgosu.org/
[minesweeper-screenshot]: https://s3.amazonaws.com/hal-assets.launchacademy.com/minesweeper/minesweeper.png
