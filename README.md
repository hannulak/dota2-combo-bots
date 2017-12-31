# Dota 2 Combo Bots 0.1 version

*This project is still in prototyping and developing stage.*

These are bots for Dota 2 and a toolkit to configure them.

A current development state is available in the [`CHANGELOG.md`](CHANGELOG.md) file.

## Why this project appeared?

Dota has default bots that are fit excellent for new players training. But they are too weak to compete with more experienced players. Therefore, these players do not have reliable computer opponents, which allow them to train some tactics and ideas.

There are several well-known projects that suggest more powerful bots for experienced players. But most of them have some drawbacks that make them unreliable for daily Dota training.

The aim of this project is providing a reliable solution for experienced players training.

## Architecture

The main issue with any Dota bots is to transform knowledge from the game experts and pro players into the source code. The Combo Bots project has a solution to this issue.

The knowledge about the game is extracted from the source code into the Excel document, which is named Database. Any player can edit this document and use generator script to produce Lua files. These files have the format, which can be read by the bot. Thus, we have a flexible mechanism to configure the bot and adapt it for your purposes.

## System Requirements

You need nothing except the Dota 2 game to play with Combo Bots.

These applications are required to edit the Combo Bot Database:

* Free [LibreOffice](https://www.libreoffice.org) or MS Office.
* [Python interpreter](https://www.python.org/downloads) of the 2.x version.
* Windows, Linux or Mac OS.
* Bash interpreter to automate Lua scripts generating and unit tests launching (optional)

The [Lua interpreter](https://www.lua.org/download.html) of the 5.3 and above version is required to launch unit tests locally.

## Installation

Now the Combo Bots project is still in development stage. It is not ready for testing by players community. Therefore, it is not available on Steam yet.

You can download the bots and install them manually in the Dota 2 game directory. These are steps to do it:

1. Download the [Combo Bots archive](https://github.com/ellysh/dota2-combo-bots/archive/master.zip).
2. Unpack the archive.
3. Copy all files from the `bot` sub-directory to the `$DOTA\dota 2 beta\game\dota\scripts\vscripts\bots` directory.
4. Start the Dota 2 game.
5. Create a lobby (Play Dota -> Create Lobby).
6. Specify the `Local Dev Script` option in the lobby bot settings for one of the teams.

More details about installing custom bots you can find in this [Dota 2 AI Quick Start](http://ruoyusun.com/2017/01/08/dota2-ai-quickstart.html) guide.

## Configuration

You can find Combo Bots Database file in the `generator/database/docs/Database.ods` path. It has the standard Excel document format.

There are several sheets in the document:

* HEROES
* ITEM_RECIPE
* ITEM_BUILD
* ITEM_SELL
* SKILL_BUILD
* SKILL_USAGE

You should use the internal (built-in) game names of the items, units, heroes, and abilities to fill these sheets. These are links, where you can find this information:

1. Item and hero names:<br/>
https://dota2.gamepedia.com/Cheats
2. Names of the hero abilities:<br/>
https://developer.valvesoftware.com/wiki/Dota_2_Workshop_Tools/Scripting/Built-In_Ability_Names
3. Names of the items abilities match the items names.

These are steps to generate Lua scripts from the Database document:

1. Save each sheet of the Database document as the CSV file with the `;` field delimiter and `"` text delimiter.
2. Use the `generator/generator.py` file to create Lua script from each of saved CSV files. The script has three parameters: name of the sheet, number of columns and a name of the input CSV file. You can get examples of the script usage in the `generator/launch.sh` file.
3. Copy all generated Lua scripts to the `bot/database` directory.

### HEROES

The `HEROES` sheet specifies a list of heroes that can be selected by bot on the draft step.

These are columns of this sheet:

1. Hero - this is the built-in name of the hero to select.
2. Position - these are two values that match a possible hero's [farm position](http://wiki.teamliquid.net/dota2/Farm_Dependency) in a team.
3. Combo Heroes - these are three possible heroes that can be effectively [combined](http://truepicker.com/en/combo/double) with the current hero.
4. Counter Heroes - these are three possible heroes that can be effectively [countered](http://dotapicker.com/counterpick) by the current hero.

The bot uses data from this sheet to select heroes on the draft step.

Now only the All Pick draft mode is supported.

### ITEM_RECIPE

The `ITEM_RECIPE` sheet describes a list of components to assemble the recipe items.

These are columns of this sheet:

1. Item - this is a name of the recipe item to assemble.
2. Components - these are four or fewer components, which are required to assemble the current item. If a component is a recipe item too, you should specify the name of this item here instead of its components.

The bot uses this data in the item purchasing algorithm. Thanks to this sheet, you can specify only final recipe items in the item builds.

### ITEM_BUILD

The `ITEM_BUILD` sheet describes a list of items that bot should buy when playing on different heroes.

These are columns of this sheet:

1. Hero - this is the built-in hero name.
2. Starting Items - these are three or fewer basic items that will be bought at the beginning of a game.
3. Core Items - these are three or fewer items that will be bought after the starting ones.
4. Extra items - these are four or fewer items that will be bought after the core ones.

The bot follows the sequence of items on this sheet when buying them. If the inventory of a hero is full, the bot will sell some items according to conditions from the `ITEM_SELL` sheet.

### ITEM_SELL

The `ITEM_SELL` sheet describes the conditions when the bot should sell the specific items.

These are columns of this sheet:

1. Item - this is a name of the item to sell.
2. Level - this is a hero level when the current item should be sold.
3. Time - this is a game time when the current item should be sold.

The bot will sell the specified items when its inventory is full and either Level or Time condition happens.

### SKILL_BUILD

The `SKILL_BUILD` sheet describes a sequence, how the bot will level up abilities and talents when playing on the specific heroes.

These are columns of this sheet:

1. Hero - this is the built-in hero name.
2. 1..18 level - these are abilities that will be leveled up when the hero reaches the corresponding level. These columns are marked green color.
3. 10..25 level - these are talents that will be leveled up when the hero reaches the corresponding level. These columns are marked red color.

The abilities are numbered from the 1st:

| Default ability hotkey | Number |
| -- | -- |
| Q | 1 |
| W | 2 |
| E | 3 |
| R | 4 |

This is the scheme of the talents numbering

| Talent level | Position in the tree | Number |
| -- | -- | -- |
| 10 | right | 1 |
| 10 | left | 2 |
| 15 | right | 3 |
| 15 | left | 4 |
| 20 | right | 5 |
| 20 | left | 6 |
| 25 | right | 7 |
| 25 | left | 8 |

We use the numbers instead of the abilities and talents names because of two reasons:

1. This way is shorter for writing.
2. [Official documentation](https://developer.valvesoftware.com/wiki/Dota_2_Workshop_Tools/Scripting/Built-In_Ability_Names) is deprecated and uses obsoleted talent names. Please do not use them and read the actual values from the game instead.

The bot will follow rules from this sheet when it gains a new level and updates its abilities.

### SKILL_USAGE

The `SKILL_USAGE` sheet describes conditions when the bot should use each of hero's abilities. The conditions are implemented as the functions in the `bot/utility/ability_usage_algorithms.lua` file. If you want to add a new condition, you should implement the function in this file with the corresponding name. Each condition-function returns a desire (0.0 to 1.0 value) to use the ability and the target for it.

These are columns of this sheet:

1. Skill Name - this is the built-in name of a hero ability.
2. Any Mode - this condition will be checked for any [active mode](https://developer.valvesoftware.com/wiki/Dota_Bot_Scripting#Bot_Modes) of the bot.
3. Team Fight - this condition will be checked when the bot is in a team fight.
4. `BOT_MODE_ROAM` - this is a condition for both `BOT_MODE_ROAM` and `BOT_MODE_TEAM_ROAM` modes.
5. `BOT_MODE_PUSH_TOWER` - this is a condition for any of `BOT_MODE_PUSH_TOWER_TOP`, `BOT_MODE_PUSH_TOWER_MID` and `BOT_MODE_PUSH_TOWER_BOT` modes.
6. `BOT_MODE_ATTACK` - this is a condition for the `BOT_MODE_ATTACK` mode.
7. `BOT_MODE_LANING` - this is a condition for the `BOT_MODE_LANING` mode.
8. `BOT_MODE_FARM` - this is a condition for the `BOT_MODE_FARM` mode.
9. `BOT_MODE_DEFEND_TOWER` - this is a condition for any of `BOT_MODE_DEFEND_TOWER_TOP`, `BOT_MODE_DEFEND_TOWER_MID` and `BOT_MODE_DEFEND_TOWER_BOT` modes.
10. `BOT_MODE_RETREAT` - this is a condition for the `BOT_MODE_RETREAT` mode.
11. `BOT_MODE_DEFEND_ALLY` - this is a condition for the `BOT_MODE_DEFEND_ALLY` mode.

The aggressive bot modes are marked red color on the sheet. Green color marks the defensive modes.

The bot will use the most desired ability when checking all of them with the condition, which matches to its active mode.

## Contributing

I will be glad to any help with the development of this project.

If you are familiar with Lua scripting, you can help with the code development. Please, send your patches via email or make push commits on GitHub.

If you are a game expert, you can help with filling the Database. You can send me your `Database.odt` file. Then I will use it to generate Lua scripts and merge new features in the project repository.

## Acknowledgements

Thanks to [adamqqqplay](https://github.com/adamqqqplay) and his great [Ranked Matchmaking AI](https://github.com/adamqqqplay/dota2ai) project. Some of his ideas and concepts are used here.

## Contacts

You can ask any questions about usage of Combo Bots via email petrsum@gmail.com.

## License

This project is distributed under the GPL v3.0 license