package.path = package.path .. ";../utility/?.lua"

require("global_functions")

local mode_shop = require("mode_shop")
local constants = require("constants")
local luaunit = require('luaunit')

function test_GetDesire_negative()
  test_RefreshBot()

  UNIT_IS_CHANNELING = true
  luaunit.assertEquals(mode_shop.GetDesire(), 0)

  UNIT_IS_CHANNELING = false
  luaunit.assertEquals(mode_shop.GetDesire(), 0)

  WAS_DAMAGED = true
  luaunit.assertEquals(mode_shop.GetDesire(), 0)

  WAS_DAMAGED = false
  luaunit.assertEquals(
    mode_shop.GetDesire(
      true,
      constants.SHOP_WALK_RADIUS + 1),
    0)
end

function test_GetDesire_positive()
  test_RefreshBot()

  NEXT_BUY_ITEM = "item_boots"
  IS_SIDE_SHOP_ITEM = true

  luaunit.assertEquals(mode_shop.GetDesire(), 1.0)
end

function test_GetNearestLocation()
  test_RefreshBot()

  local location_1 = {20, 10}
  local location_2 = {10, 10}

  luaunit.assertEquals(
    mode_shop.test_GetNearestLocation(
      GetBot(),
      location_1,
      location_2),
    location_2)
end

function test_Think()
  test_RefreshBot()

  DISTANCE_FROM_SHOP = 1000
  mode_shop.Think()

  luaunit.assertEquals(BOT_ACTION, BOT_ACTION_TYPE_MOVE_TO)

  luaunit.assertEquals(BOT_MOVE_LOCATION, {10, 10})
end

os.exit(luaunit.LuaUnit.run())
