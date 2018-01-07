HEADER = """
local M = {}
"""

FOOTER = """
}

return M
"""
#---------------------------------------------

HEROES_HEADER = """
M.HEROES = {
"""

HEROES = """
  {
    name = "<0>",
    position = {<1>, <2>},
    combo_heroes = {
      "<3>",
      "<4>",
      "<5>"
    },
    counter_heroes = {
      "<6>",
      "<7>",
      "<8>"
    }
  },
"""

#---------------------------------------------

ITEM_RECIPE_HEADER = """
M.ITEM_RECIPE = {
"""

ITEM_RECIPE = """
  <0> = {
    components = {
      "<1>",
      "<2>",
      "<3>",
      "<4>"}
  },
"""

#---------------------------------------------

ITEM_BUILD_HEADER = """
M.ITEM_BUILD = {
"""

ITEM_BUILD = """
  <0> = {
    items = {
      "<1>",
      "<2>",
      "<3>",
      "<4>",
      "<5>",
      "<6>",
      "<7>",
      "<8>",
      "<9>",
      "<10>",
      "<11>",
      "<12>",
      "<13>"}
  },
"""

#---------------------------------------------

ITEM_SELL_HEADER = """
M.ITEM_SELL = {
"""

ITEM_SELL = """
  <0> = {
    level = <1>,
    time = <2>
  },
"""

#---------------------------------------------

SKILL_BUILD_HEADER = """
M.SKILL_BUILD = {
"""

SKILL_BUILD = """
  <0> = {
    abilities = {
      [1] = <1>,
      [2] = <2>,
      [3] = <3>,
      [4] = <4>,
      [5] = <5>,
      [6] = <6>,
      [7] = <7>,
      [8] = <8>,
      [9] = <9>,
      [10] = <10>,
      [11] = <11>,
      [12] = <12>,
      [13] = <13>,
      [14] = <14>,
      [15] = <15>,
      [16] = <16>,
      [18] = <17>,
      [20] = <18>,
      [25] = <19>
    }
  },
"""

#---------------------------------------------

SKILL_USAGE_HEADER = """
local algorithms = require(
  GetScriptDirectory() .."/utility/ability_usage_algorithms")

M.SKILL_USAGE = {
"""

SKILL_USAGE = """
  <0> = {
      any_mode = {algorithms["<1>"], <2>},
      team_fight = {algorithms["<3>"], <4>},
      BOT_MODE_ROAM = {algorithms["<5>"], <6>},
      BOT_MODE_TEAM_ROAM = {algorithms["<7>"], <8>},
      BOT_MODE_PUSH_TOWER = {algorithms["<9>"], <10>},
      BOT_MODE_ATTACK = {algorithms["<11>"], <12>},
      BOT_MODE_LANING = {algorithms["<13>"], <14>},
      BOT_MODE_ROSHAN = {algorithms["<15>"], <16>},
      BOT_MODE_FARM = {algorithms["<17>"], <18>},
      BOT_MODE_DEFEND_TOWER = {algorithms["<19>"], <20>},
      BOT_MODE_RETREAT = {algorithms["<21>"], <22>},
      BOT_MODE_DEFEND_ALLY = {algorithms["<23>"], <24>}
  },
"""

#---------------------------------------------

TEAM_DESIRES_HEADER = """
M.TEAM_DESIRES = {
"""

TEAM_DESIRES = """
  <0> = {
    PUSH_TOP_LINE_DESIRE = <1>,
    PUSH_MID_LINE_DESIRE = <2>,
    PUSH_BOT_LINE_DESIRE = <3>
  },
"""
