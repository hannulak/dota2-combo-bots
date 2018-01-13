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

os.exit(luaunit.LuaUnit.run())
