package.path = package.path .. ";../utility/?.lua"

pcall(require, "luacov")
require("global_functions")

local algorithms = require("team_desires_algorithms")
local luaunit = require("luaunit")

function test_ally_mega_creeps()
  BARRAK_HEALTH = 100
  luaunit.assertFalse(algorithms.ally_mega_creeps())

  BARRAK_HEALTH = 0
  luaunit.assertTrue(algorithms.ally_mega_creeps())
end

function test_IsAllyHaveItem()
  local test_item = "item_enchanted_mango"

  luaunit.assertFalse(algorithms.test_IsAllyHaveItem(test_item))

  local unit = Unit:new()
  unit.inventory = { test_item }

  UNITS = { unit }

  luaunit.assertTrue(algorithms.test_IsAllyHaveItem(test_item))
end

function test_ally_has_aegis_succeed()
  luaunit.assertFalse(algorithms.ally_has_aegis())

  local unit = Unit:new()
  unit.inventory = { "item_aegis" }

  UNITS = { unit }

  luaunit.assertTrue(algorithms.ally_has_aegis())
end

function test_ally_has_cheese_succeed()
  luaunit.assertFalse(algorithms.ally_has_cheese())

  local unit = Unit:new()
  unit.inventory = { "item_cheese" }

  UNITS = { unit }

  luaunit.assertTrue(algorithms.ally_has_cheese())
end

function test_max_kills_enemy_hero_alive()
  IS_HERO_ALIVE = true
  luaunit.assertTrue(algorithms.max_kills_enemy_hero_alive())

  IS_HERO_ALIVE = false
  luaunit.assertFalse(algorithms.max_kills_enemy_hero_alive())
end

function test_max_kills_ally_hero_alive()
  IS_HERO_ALIVE = true
  luaunit.assertTrue(algorithms.max_kills_ally_hero_alive())

  IS_HERO_ALIVE = false
  luaunit.assertFalse(algorithms.max_kills_ally_hero_alive())
end

function test_time_is_more_3_minutes_fails()
  TIME = 1 * 60
  luaunit.assertFalse(algorithms.time_is_more_3_minutes())
end

function test_time_is_more_3_minutes_succeed()
  TIME = 6 * 60
  luaunit.assertTrue(algorithms.time_is_more_3_minutes())
end

function test_NumberUnitsOnLane_succed()
  local unit = Unit:new()

  UNITS = { unit, unit, unit }

  LANE_DISTANCE = 200

  luaunit.assertEquals(
    algorithms.test_UnitsOnLane(
      UNIT_LIST_ALLIED_HEROES,
      LANE_TOP),
    UNITS)

  UNITS = { unit }

  luaunit.assertEquals(
    algorithms.test_UnitsOnLane(
      UNIT_LIST_ALLIED_HEROES,
      LANE_TOP),
    UNITS)
end

function test_UnitsOnLane_fails()
  local unit = Unit:new()

  UNITS = {}

  luaunit.assertEquals(
    algorithms.test_UnitsOnLane(
      UNIT_LIST_ALLIED_HEROES,
      LANE_TOP),
      {})

  UNITS = { unit }
  LANE_DISTANCE = 3000

  luaunit.assertEquals(
    algorithms.test_UnitsOnLane(
      UNIT_LIST_ALLIED_HEROES,
      LANE_TOP),
      {})

  unit.health = 0
  UNITS = { unit }
  LANE_DISTANCE = 200

  luaunit.assertEquals(
    algorithms.test_UnitsOnLane(
      UNIT_LIST_ALLIED_HEROES,
      LANE_TOP),
      {})
end

function test_more_ally_heroes_on_lane_then_enemy()
  luaunit.assertFalse(algorithms.more_ally_heroes_on_top_then_enemy())
  luaunit.assertFalse(algorithms.more_ally_heroes_on_mid_then_enemy())
  luaunit.assertFalse(algorithms.more_ally_heroes_on_bot_then_enemy())
end

function test_more_ally_heroes_alive_then_enemy()
  luaunit.assertFalse(algorithms.more_ally_heroes_alive_then_enemy())
end

function test_no_enemy_heroes_on_lane()
  LANE_DISTANCE = 3000

  luaunit.assertTrue(algorithms.no_enemy_heroes_on_top())
  luaunit.assertTrue(algorithms.no_enemy_heroes_on_mid())
  luaunit.assertTrue(algorithms.no_enemy_heroes_on_bot())
end

function test_is_night_succeed()
  TIME_OF_DAY = 0.24
  luaunit.assertTrue(algorithms.is_night())

  TIME_OF_DAY = 0.26
  luaunit.assertFalse(algorithms.is_night())

  TIME_OF_DAY = 0.74
  luaunit.assertFalse(algorithms.is_night())

  TIME_OF_DAY = 0.76
  luaunit.assertTrue(algorithms.is_night())
end

function test_all_enemy_team_dead_succeed()
  IS_HERO_ALIVE = false
  luaunit.assertTrue(algorithms.all_enemy_team_dead())
end

function test_all_enemy_team_dead_fails()
  IS_HERO_ALIVE = true
  luaunit.assertFalse(algorithms.all_enemy_team_dead())
end

function test_enemy_hero_was_seen_succeed()
  IS_HERO_ALIVE = true
  HERO_LAST_SEEN_INFO = { {location = {10, 10}, time_since_seen = 2} }

  luaunit.assertTrue(algorithms.enemy_hero_was_seen())
end

function test_enemy_hero_was_seen_dead_fails()
  IS_HERO_ALIVE = false
  HERO_LAST_SEEN_INFO = { {location = {10, 10}, time_since_seen = 2} }

  luaunit.assertFalse(algorithms.enemy_hero_was_seen())
end

function test_enemy_hero_was_seen_not_seen_fails()
  IS_HERO_ALIVE = true
  HERO_LAST_SEEN_INFO = {}

  luaunit.assertFalse(algorithms.enemy_hero_was_seen())
end

function test_enemy_hero_was_seen_no_nearby_ally_succeed()
  IS_HERO_ALIVE = true
  HERO_LAST_SEEN_INFO = { {location = {10, 10}, time_since_seen = 2} }
  UNITS = {}

  luaunit.assertTrue(algorithms.enemy_hero_was_seen())
end

function test_IsBuildingFocusedByEnemies_nil_building_fails()
  luaunit.assertFalse(algorithms.test_IsBuildingFocusedByEnemies(nil))
end

function test_is_bot_building_focused_by_enemies_succeed()
  UNITS = { Unit:new() }
  TOWER_HEALTH = 10
  ATTACK_TARGET = TOWER
  UNIT_HAS_NEARBY_UNITS = true

  luaunit.assertTrue(algorithms.is_bot_building_focused_by_enemies())
end

function test_is_top_building_focused_by_enemies_succeed()
  UNITS = { Unit:new() }
  TOWER_HEALTH = 10
  ATTACK_TARGET = TOWER
  UNIT_HAS_NEARBY_UNITS = true

  luaunit.assertTrue(algorithms.is_top_building_focused_by_enemies())
end

function test_is_mid_building_focused_by_enemies_succeed()
  UNITS = { Unit:new() }
  TOWER_HEALTH = 10
  ATTACK_TARGET = TOWER
  UNIT_HAS_NEARBY_UNITS = true

  luaunit.assertTrue(algorithms.is_mid_building_focused_by_enemies())
end

function test_IsThreeEnemyHeroesOnLane_succed()
  local unit = Unit:new()

  UNITS = { unit, unit, unit }

  LANE_DISTANCE = 200

  luaunit.assertTrue(algorithms.test_IsThreeEnemyHeroesOnLane(LANE_TOP))
end

function test_IsThreeEnemyHeroesOnLane_two_fails()
  local unit = Unit:new()

  UNITS = { unit, unit }

  LANE_DISTANCE = 200

  luaunit.assertFalse(algorithms.test_IsThreeEnemyHeroesOnLane(LANE_TOP))
end

function test_is_roshan_alive_succeed()
  TIME = 16 * 60
  ROSHAN_KILL_TIME = 5 * 60

  luaunit.assertTrue(algorithms.is_roshan_alive())
end

function test_is_roshan_alive_fails()
  TIME = 16 * 60
  ROSHAN_KILL_TIME = 6 * 60

  luaunit.assertFalse(algorithms.is_roshan_alive())
end

function test_enough_damage_and_health_for_roshan_succeed()
  local unit = Unit:new()
  unit.damage = 300
  unit.health = 2500

  UNITS = { unit, unit, unit }

  luaunit.assertTrue(algorithms.enough_damage_and_health_for_roshan())
end

function test_enough_damage_and_health_for_roshan_few_hp_fails()
  local unit = Unit:new()
  unit.damage = 300
  unit.health = 100

  UNITS = { unit, unit, unit }

  luaunit.assertFalse(algorithms.enough_damage_and_health_for_roshan())
end

function test_enough_damage_and_health_for_roshan_few_damage_fails()
  local unit = Unit:new()
  unit.damage = 10
  unit.health = 2500

  UNITS = { unit, unit, unit }

  luaunit.assertFalse(algorithms.enough_damage_and_health_for_roshan())
end

os.exit(luaunit.LuaUnit.run())
