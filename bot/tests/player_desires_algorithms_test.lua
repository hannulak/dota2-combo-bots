package.path = package.path .. ";../utility/?.lua"

require("global_functions")

local algorithms = require("player_desires_algorithms")
local luaunit = require('luaunit')

function test_have_low_hp()
  test_RefreshBot()

  local npc_bot = GetBot()

  npc_bot.health = 10
  luaunit.assertTrue(algorithms.have_low_hp(npc_bot, ability))

  npc_bot.health = npc_bot.max_health
  luaunit.assertFalse(algorithms.have_low_hp(npc_bot, ability))
end

function test_PlayerOnLane()
  test_RefreshBot()

  luaunit.assertTrue(algorithms.test_PlayerOnLane(LANE_TOP))

  LANE_DISTANCE = 3000

  luaunit.assertFalse(algorithms.test_PlayerOnLane(LANE_TOP))
end

function test_player_on_top()
  test_RefreshBot()

  LANE_DISTANCE = 200
  luaunit.assertTrue(algorithms.player_on_top())

  LANE_DISTANCE = 3000
  luaunit.assertFalse(algorithms.player_on_top())
end

function test_player_on_mid()
  test_RefreshBot()

  LANE_DISTANCE = 200
  luaunit.assertTrue(algorithms.player_on_mid())

  LANE_DISTANCE = 3000
  luaunit.assertFalse(algorithms.player_on_mid())
end

function test_player_on_bot()
  test_RefreshBot()

  LANE_DISTANCE = 200
  luaunit.assertTrue(algorithms.player_on_bot())

  LANE_DISTANCE = 3000
  luaunit.assertFalse(algorithms.player_on_bot())
end

os.exit(luaunit.LuaUnit.run())
