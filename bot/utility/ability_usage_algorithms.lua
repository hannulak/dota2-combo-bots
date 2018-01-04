local logger = require(
  GetScriptDirectory() .."/utility/logger")

local constants = require(
  GetScriptDirectory() .."/utility/constants")

local functions = require(
  GetScriptDirectory() .."/utility/functions")

local M = {}

local function GetEnemyHeroes(npc_bot, radius)
  return npc_bot:GetNearbyHeroes(radius, true, BOT_MODE_NONE)
end

local function GetEnemyCreeps(npc_bot, radius)
  return npc_bot:GetNearbyCreeps(radius, true)
end

local MIN = 1
local MAX = 2

local function GetUnitWith(min_max, get_function, units)
  if #units == 0 then return nil end

  local current_value = functions.ternary(min_max == MIN, 1000000, 0)
  local result = nil

  for _, unit in pairs(units) do
    if unit == nil or not unit:IsAlive() then goto continue end

    local unit_value = unit[get_function](unit)
    local is_positive_comparison = functions.ternary(
      min_max == MIN,
      unit_value < current_value,
      current_value < unit_value)

    if is_positive_comparison then
      current_value = unit_value
      result = unit
    end

    ::continue::
  end

  return result
end

local function IsTargetable(npc)
  return npc:CanBeSeen()
         and not npc:IsMagicImmune()
         and not npc:IsInvulnerable()
         and not npc:IsIllusion()
end

local function IsEnoughDamageToKill(npc, ability)
  return npc:GetHealth() <= npc:GetActualIncomingDamage(
    ability:GetAbilityDamage(),
    ability:GetDamageType())
end

local function GetTarget(target, ability)
  local target_type = functions.GetAbilityTargetType(ability)

  if target_type == constants.ABILITY_LOCATION_TARGET then
    -- TODO: We use constant cast time 0.3 for all abilities
    return target:GetExtrapolatedLocation(0.3)
  end

  if target_type == constants.ABILITY_UNIT_TARGET then
    return target
  end

  return nil
end

function M.min_hp_enemy_hero_to_kill(npc_bot, ability)
  local enemy_heroes = GetEnemyHeroes(npc_bot, ability:GetCastRange())
  local enemy_hero = GetUnitWith(MIN, 'GetHealth', enemy_heroes)

  if enemy_hero == nil
    or not IsTargetable(enemy_hero)
    or not IsEnoughDamageToKill(enemy_hero, ability) then

    return BOT_ACTION_DESIRE_NONE, nil
  end

  return BOT_ACTION_DESIRE_VERYHIGH, GetTarget(enemy_hero, ability)
end

function M.channeling_enemy_hero(npc_bot, ability)
  local enemies = GetEnemyHeroes(npc_bot, ability:GetCastRange())

  for _, enemy in pairs(enemies) do
    if enemy ~= nil
      and enemy:IsChanneling()
      and IsTargetable(enemy) then

      return BOT_ACTION_DESIRE_VERYHIGH, GetTarget(enemy, ability)
    end
  end

  return BOT_ACTION_DESIRE_NONE, nil
end

function M.max_networth_enemy_hero(npc_bot, ability)
  local enemy_heroes = GetEnemyHeroes(npc_bot, ability:GetCastRange())
  local enemy_hero = GetUnitWith(MAX, 'GetNetWorth', enemy_heroes)

  if enemy_hero == nil
    or not IsTargetable(enemy_hero) then

    return BOT_ACTION_DESIRE_NONE, nil
  end

  return BOT_ACTION_DESIRE_HIGH, GetTarget(enemy_hero, ability)
end

function M.three_and_more_enemy_heroes_aoe(npc_bot, ability)
  local enemies = GetEnemyHeroes(npc_bot, ability:GetAOERadius())

  if 3 <= #enemies then return BOT_ACTION_DESIRE_HIGH, nil end

  return BOT_ACTION_DESIRE_NONE, nil
end

local function GetLastAttackedEnemyHero(npc_bot, radius)
  local enemies = GetEnemyHeroes(npc_bot, radius)

  if #enemies == 0 then return nil end

  for _, enemy in pairs(enemies) do
    if enemy == nil or not enemy:IsAlive() then goto continue end

    if npc_bot:WasRecentlyDamagedByHero(enemy, 2.0) then
      return enemy
    end

    ::continue::
  end

  return nil
end

function M.last_attacked_enemy_hero(npc_bot, ability)
  local enemy_hero = GetLastAttackedEnemyHero(
    npc_bot,
    ability:GetCastRange())

  if enemy_hero == nil
    or not IsTargetable(enemy_hero) then

    return BOT_ACTION_DESIRE_NONE, nil
  end

  return BOT_ACTION_DESIRE_HIGH, GetTarget(enemy_hero, ability)
end

function M.three_and_more_creeps(npc_bot, ability)
  local cast_range = ability:GetCastRange()

  local target = npc_bot:FindAoELocation(
    true,
    false,
    npc_bot:GetLocation(),
    cast_range,
    ability:GetSpecialValueInt("radius"),
    0,
    ability:GetAbilityDamage())

  if 3 <= target.count
    and GetUnitToLocationDistance(npc_bot, target.targetloc) < cast_range then
    return BOT_ACTION_DESIRE_LOW, target.targetloc
  end

  return BOT_ACTION_DESIRE_NONE, nil
end

local function GetMaxHpCreep(npc_bot, radius)
  local creeps = GetEnemyCreeps(npc_bot, radius)

  return GetUnitWith(MAX, 'GetHealth', creeps)
end

function M.max_hp_creep(npc_bot, ability)
  local creep = GetMaxHpCreep(
    npc_bot,
    ability:GetCastRange())

  if creep == nil
    or not IsTargetable(creep) then

    return BOT_ACTION_DESIRE_NONE, nil
  end

  return BOT_ACTION_DESIRE_LOW, GetTarget(creep, ability)
end

function M.three_and_more_enemy_heroes(npc_bot, ability)
  local cast_range = ability:GetCastRange()

  local target = npc_bot:FindAoELocation(
    true,
    true,
    npc_bot:GetLocation(),
    cast_range,
    ability:GetSpecialValueInt("radius"),
    0,
    ability:GetAbilityDamage())

  if 3 <= target.count
    and GetUnitToLocationDistance(npc_bot, target.targetloc) < cast_range then
    return BOT_ACTION_DESIRE_HIGH, target.targetloc
  end

  return BOT_ACTION_DESIRE_NONE, nil
end

function M.toggle_on_attack_enemy_hero(npc_bot, ability)
  local target = npc_bot:GetAttackTarget()

  if target == nil then return BOT_ACTION_DESIRE_NONE, nil end

  if not ability:GetAutoCastState() and target:IsHero() then
    -- Enable the ability when we are attacking an enemy hero

    logger.Print("toggle_on_attack_enemy_hero() - " ..
      npc_bot:GetUnitName() .. " activates " .. ability:GetName())

    ability:ToggleAutoCast()
  elseif ability:GetAutoCastState() and not target:IsHero() then
    -- Disable the ability when we are attacking a creep

    logger.Print("toggle_on_attack_enemy_hero() - " ..
      npc_bot:GetUnitName() .. " deactivates " .. ability:GetName())

    ability:ToggleAutoCast()
  end

  return BOT_ACTION_DESIRE_NONE, nil
end

-- Provide an access to local functions and variables for unit tests only
M.test_GetEnemyHeroes = GetEnemyHeroes
M.test_GetEnemyCreeps = GetEnemyCreeps
M.test_GetUnitWith = GetUnitWith
M.test_IsTargetable = IsTargetable
M.test_IsEnoughDamageToKill = IsEnoughDamageToKill
M.test_GetTarget = GetTarget
M.test_GetLastAttackedEnemyHero = GetLastAttackedEnemyHero
M.test_GetMaxHpCreep = GetMaxHpCreep

M.test_MIN = MIN
M.test_MAX = MAX

return M
