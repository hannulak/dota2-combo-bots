local constants = require(
  GetScriptDirectory() .."/utility/constants")

local functions = require(
  GetScriptDirectory() .."/utility/functions")

local common_algorithms = require(
  GetScriptDirectory() .."/utility/common_algorithms")

local M = {}

local RUNES = {
  RUNE_POWERUP_1,
  RUNE_POWERUP_2,
  RUNE_BOUNTY_1,
  RUNE_BOUNTY_2,
  RUNE_BOUNTY_3,
  RUNE_BOUNTY_4,
}

local function GetClosestRune(bot)
  local rune_distance = {}

  for _, rune in pairs(RUNES) do
    local loc = GetRuneSpawnLocation(rune)
    rune_distance[rune] = GetUnitToLocationDistance(bot, loc)
  end

  local rune, distance = functions.GetKeyAndElementWith(
    rune_distance,
    function(t, a, b) return t[a] < t[b] end)

  if distance < constants.MAX_HERO_DISTANCE_FROM_RUNE then
    return rune, distance
  else
    return nil, 0
  end
end

local function IsBeginningOfMatch()
  return DotaTime() < 0
end

local function IsPowerRune(rune)
  return rune == RUNE_POWERUP_1
         or rune == RUNE_POWERUP_2
end

local function IsRuneAppeared(rune)
  local spawn_time = functions.ternary(IsPowerRune(rune), 2, 5)
  local time = DotaTime()
  local last_appear = time - (time % (spawn_time * 60))

  -- Bot moves to a rune at 8 seconds before it appears
  return 112 <= (time - last_appear)
end

function GetDesire()
  local bot = GetBot()
  local rune, distance = GetClosestRune(bot)

  if rune == nil then
    return 0 end

  if (functions.IsBotInFightingMode(bot)
     and (constants.MIN_HERO_DISTANCE_FROM_RUNE < distance
          or GetRuneStatus(rune) == RUNE_STATUS_MISSING))
     or functions.IsBotCasting(bot)
     or common_algorithms.IsEnemyHeroOnTheWay(
          bot,
          GetRuneSpawnLocation(rune)) then

    return 0 end

  if IsBeginningOfMatch() then
    if not IsPowerRune(rune) then
      return constants.MAX_RUNE_DESIRE
    else
      return 0
    end
  end

  if GetRuneStatus(rune) == RUNE_STATUS_MISSING
     and not IsRuneAppeared(rune) then
    return 0 end

  if GetRuneStatus(rune) == RUNE_STATUS_AVAILABLE then
    return constants.MAX_RUNE_DESIRE end

  return functions.GetNormalizedDesire(
           functions.DistanceToDesire(
             distance,
             constants.MAX_HERO_DISTANCE_FROM_RUNE,
             0.3),
           constants.MAX_RUNE_DESIRE)
end

function Think()
  local bot = GetBot()
  local rune, distance = GetClosestRune(bot)

  if rune == nil then
    return end

  if constants.MIN_HERO_DISTANCE_FROM_RUNE < distance then
    bot:Action_MoveToLocation(GetRuneSpawnLocation(rune))
  else
    bot:Action_PickUpRune(rune)
  end
end

return M
