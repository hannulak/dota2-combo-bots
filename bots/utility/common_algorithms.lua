local functions = require(
  GetScriptDirectory() .."/utility/functions")

local constants = require(
  GetScriptDirectory() .."/utility/constants")

local M = {}

function M.IsAttackTargetable(unit)
  return unit:CanBeSeen()
         and unit:IsAlive()
         and not unit:IsInvulnerable()
         and not unit:IsIllusion()
end

function M.CompareMaxHealth(t, a, b)
  return t[b]:GetHealth() < t[a]:GetHealth()
end

function M.CompareMinHealth(t, a, b)
  return t[a]:GetHealth() < t[b]:GetHealth()
end

function M.CompareMaxHeroKills(t, a, b)
  return GetHeroKills(t[b]:GetPlayerID()) <
    GetHeroKills(t[a]:GetPlayerID())
end

local function CompareMaxPlayerKills(t, a, b)
  return GetHeroKills(t[b]) < GetHeroKills(t[a])
end

function M.GetMaxKillsPlayer(team, validate_function)
  local players = GetTeamPlayers(team)
  local player = functions.GetElementWith(
    players,
    CompareMaxPlayerKills,
    validate_function)

  return player
end

local function GetNormalizedRadius(radius)
  if radius == nil or radius == 0 then
    return constants.DEFAULT_ABILITY_USAGE_RADIUS
  end

  -- TODO: Trick with MAX_ABILITY_USAGE_RADIUS breaks Sniper's ult.
  -- But the GetNearbyHeroes function has the maximum radius 1600.

  return functions.ternary(
    constants.MAX_ABILITY_USAGE_RADIUS < radius,
    constants.MAX_ABILITY_USAGE_RADIUS,
    radius)
end

function M.GetEnemyHeroes(bot, radius)
  return bot:GetNearbyHeroes(
    GetNormalizedRadius(radius),
    true,
    BOT_MODE_NONE)
end

function M.GetAllyHeroes(bot, radius)
  return bot:GetNearbyHeroes(
    GetNormalizedRadius(radius),
    false,
    BOT_MODE_NONE)
end

function M.GetEnemyCreeps(bot, radius)
  local enemy_creeps = bot:GetNearbyCreeps(
    GetNormalizedRadius(radius),
    true)

  local neutral_creeps = bot:GetNearbyNeutralCreeps(
    GetNormalizedRadius(radius))

  if enemy_creeps == nil or #enemy_creeps == 0 then
    return {} end

  if neutral_creeps == nil or #neutral_creeps == 0 then
    return enemy_creeps end

  return functions.ComplementOfLists(enemy_creeps, neutral_creeps, true)
end

function M.GetNeutralCreeps(bot, radius)
  return bot:GetNearbyNeutralCreeps(GetNormalizedRadius(radius))
end

function M.GetAllyCreeps(bot, radius)
  return bot:GetNearbyCreeps(GetNormalizedRadius(radius), false)
end

function M.GetEnemyBuildings(bot, radius)
  local towers = bot:GetNearbyTowers(GetNormalizedRadius(radius), true)

  if #towers ~= 0 then
    return towers end

  return bot:GetNearbyBarracks(GetNormalizedRadius(radius), true)
end

function M.IsEnemyHeroOnTheWay(bot, location)
  local enemies = M.GetEnemyHeroes(bot, constants.MAX_GET_UNITS_RADIUS)
  local bot_distance = GetUnitToLocationDistance(bot, location)

  return nil ~= functions.GetElementWith(
    enemies,
    nil,
    function(unit)
      return GetUnitToLocationDistance(unit, location) < bot_distance
    end)
end

local function GetUnitManaLevel(unit)
  return unit:GetMana() / unit:GetMaxMana()
end

local function GetUnitHealthLevel(unit)
  return functions.GetRate(unit:GetHealth(), unit:GetMaxHealth())
end

function M.IsUnitLowHp(unit)
  return unit:GetHealth() <= constants.UNIT_LOW_HEALTH
         or GetUnitHealthLevel(unit)
            <= constants.UNIT_LOW_HEALTH_LEVEL
end

function M.IsUnitLowMp(unit)
  return GetUnitManaLevel(unit) <= constants.UNIT_LOW_MANA_LEVEL
end

function M.IsUnitHalfHp(unit)
  return GetUnitHealthLevel(unit) <= constants.UNIT_HALF_HEALTH_LEVEL
end

function M.GetLastPlayerLocation(player)
  if player == nil then
    return nil end

  local seen_info = GetHeroLastSeenInfo(player)

  if seen_info == nil
     or #seen_info == 0
     or seen_info[1] == nil
     or 10 < seen_info[1].time_since_seen then
    return nil end

  return seen_info[1].location
end

function M.GetTotalDamage(units, target)
  if units == nil or #units == 0 or target == nil then
    return 0 end

  local total_damage = 0

  functions.DoWithElements(
    units,
    function(unit)
      if unit:GetAttackTarget() == target then
        total_damage = total_damage + unit:GetAttackDamage()
      end
    end)

  return total_damage
end

local BUILDINGS = {
  [LANE_TOP] = {
    {id = TOWER_TOP_1, type ="TYPE_TOWER"},
    {id = TOWER_TOP_2, type ="TYPE_TOWER"},
    {id = TOWER_TOP_3, type ="TYPE_TOWER"},
    {id = BARRACKS_TOP_MELEE, type = "TYPE_BARRACKS"},
    {id = BARRACKS_TOP_RANGED, type = "TYPE_BARRACKS"},
  },
  [LANE_BOT] = {
    {id = TOWER_BOT_1, type = "TYPE_TOWER"},
    {id = TOWER_BOT_2, type = "TYPE_TOWER"},
    {id = TOWER_BOT_3, type = "TYPE_TOWER"},
    {id = BARRACKS_BOT_MELEE, type = "TYPE_BARRACKS"},
    {id = BARRACKS_BOT_RANGED, type = "TYPE_BARRACKS"},
  },
  [LANE_MID] = {
    {id = TOWER_MID_1, type = "TYPE_TOWER"},
    {id = TOWER_MID_2, type = "TYPE_TOWER"},
    {id = TOWER_MID_3, type = "TYPE_TOWER"},
    {id = TOWER_BASE_1, type = "TYPE_TOWER"},
    {id = TOWER_BASE_2, type = "TYPE_TOWER"},
    {id = BARRACKS_MID_MELEE, type = "TYPE_BARRACKS"},
    {id = BARRACKS_MID_RANGED, type = "TYPE_BARRACKS"},
    {id = nil, type = "TYPE_ANCIENT"},
  },
}

local function GetBuilding(building_id, building_type)
  local GET_BUILDING_FUNCTIONS = {
    TYPE_TOWER = GetTower,
    TYPE_BARRACKS = GetBarracks,
    TYPE_ANCIENT = GetAncient
  }

  if "TYPE_ANCIENT" == building_type then
    return GET_BUILDING_FUNCTIONS[building_type](GetTeam())
  else
    return GET_BUILDING_FUNCTIONS[building_type](GetTeam(), building_id)
  end
end

function M.GetNearestFrontBuilding(lane)
  local front_location = GetLaneFrontLocation(GetOpposingTeam(), lane, 0)
  local result = nil
  local min_distance = 10000000

  for _, building_info in pairs(BUILDINGS[lane]) do
    local building = GetBuilding(
      building_info.id,
      building_info.type)

    if building ~= nil
       and GetUnitToLocationDistance(building, front_location)
           < min_distance then

       min_distance = GetUnitToLocationDistance(building, front_location)
       result = building
    end
  end

  return result
end

-- Provide an access to local functions for unit tests only
M.test_GetNormalizedRadius = GetNormalizedRadius
M.test_GetUnitHealthLevel = GetUnitHealthLevel
M.test_GetBuilding = GetBuilding

return M
