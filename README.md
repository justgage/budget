Budget
======

A simple command line budgeting program that helps me to learn [Elixir](elixir-lang.org)

__Pros:__

- Simple
- File format is human readable
- Command line based (if you're like me)

__Cons:__

- Simplistic
- No database
- Command line based (if you're not like me)

# Building

you can build a binary for your system if you have `elixir` installed and run:

```
$ mix deps.get
$ mix escript.build
```
(I'm assuming you have Elixir installed), just note that binaries will still not run without the Erlang vm installed (this should be there if you installed Elixir).

# Usage

calling budget without any arguments gives you the help text:

```
$ ./budget
Help: 
    COMMANDS:
    $ budget add name amount [details] (eg: $budget add gage 12 "got paid")
      'adds an expense to the budget'

    $ budget bal name
      'shows `name`s current balence'

    $ budget log name
      'shows a log of recent expenses from `name`'
      
    $ budget help 
      'shows this help text'
    
```
