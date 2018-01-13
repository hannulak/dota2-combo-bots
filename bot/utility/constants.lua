local M = {}

M.INVENTORY_SIZE = 8
M.INVENTORY_AND_STASH_SIZE = 16

M.SHOP_USE_RADIUS = 250
M.BASE_SHOP_USE_RADIUS = 600
M.SHOP_WALK_RADIUS = 3000 -- ~10 second to walk

M.DEFAULT_ABILITY_USAGE_RADIUS = 600
M.MAX_ABILITY_USAGE_RADIUS = 1600

M.MELEE_ATTACK_RADIUS = 200

M.ABILITY_NO_TARGET = 1
M.ABILITY_UNIT_TARGET = 2
M.ABILITY_LOCATION_TARGET = 3

M.UNIT_LOW_HEALTH_LEVEL = 0.4 -- 40%
M.UNIT_LOW_MANA_LEVEL = 0.3 -- 30%

M.BOT_MODES = {
  BOT_MODE_NONE = 0,
  BOT_MODE_LANING = 1,
  BOT_MODE_ATTACK = 2,
  BOT_MODE_ROAM = 3,
  BOT_MODE_RETREAT = 4,
  BOT_MODE_SECRET_SHOP = 5,
  BOT_MODE_SIDE_SHOP = 6,
  BOT_MODE_PUSH_TOWER_TOP = 8,
  BOT_MODE_PUSH_TOWER_MID = 9,
  BOT_MODE_PUSH_TOWER_BOT = 10,
  BOT_MODE_DEFEND_TOWER_TOP = 11,
  BOT_MODE_DEFEND_TOWER_MID = 12,
  BOT_MODE_DEFEND_TOWER_BOT = 13,
  BOT_MODE_ASSEMBLE = 14,
  BOT_MODE_TEAM_ROAM = 16,
  BOT_MODE_FARM = 17,
  BOT_MODE_DEFEND_ALLY = 18,
  BOT_MODE_EVASIVE_MANEUVERS = 19,
  BOT_MODE_ROSHAN = 20,
  BOT_MODE_ITEM = 21,
  BOT_MODE_WARD = 22,
}

M.MAX_HERO_DISTANCE_FROM_LANE = 1200

return M
