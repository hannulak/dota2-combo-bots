local logger = require(
  GetScriptDirectory() .."/utility/logger")

local functions = require(
  GetScriptDirectory() .."/utility/functions")

local constants = require(
  GetScriptDirectory() .."/utility/constants")

local common_algorithms = require(
  GetScriptDirectory() .."/utility/common_algorithms")

local skill_usage = require(
  GetScriptDirectory() .."/database/skill_usage")

local skill_groups = require(
  GetScriptDirectory() .."/database/skill_groups")

local M = {}

local function CalculateDesireAndTarget(
  bot,
  algorithm,
  bot_mode,
  ability)

  if algorithm == nil then
    return false, nil end

  if not functions.IsBotModeMatch(bot, bot_mode) then
    return false, nil
  end

  return algorithm(bot, ability)
end

local function GetAbilitiesAndItems(bot)
  local result = {}

  for i = 0, 23 do
    local ability = bot:GetAbilityInSlot(i)

    if ability ~= nil and ability:IsFullyCastable() then
      result[ability:GetName()] = ability
    end
  end

  for i = 0, 16 do
    local item = bot:GetItemInSlot(i)

    if item ~= nil and item:IsFullyCastable() then
      result[item:GetName()] = item
    end
  end

  return result
end

local function GetDesiredAbilitiesList(bot)
  local result = {}
  local abilities = GetAbilitiesAndItems(bot)

  for ability_name, ability in pairs(abilities) do
    local ability_groups = skill_usage.SKILL_USAGE[ability_name]

    if ability_groups == nil then
      do goto continue1 end
    end

    for _, ability_group in pairs(ability_groups) do
      if ability_group == "nil" then
        do goto continue2 end
      end

      local algorithms = skill_groups.SKILL_GROUPS[ability_group]

      if algorithms == nil then
        logger.Print("GetDesiredAbilitiesList() - " ..
          bot:GetUnitName() .. " unknown skill group " ..
          tostring(ability_group))

        do goto continue2 end
      end

      for bot_mode, algorithm in functions.spairs(algorithms) do

        local is_succeed, target =
          CalculateDesireAndTarget(bot,
            algorithm[1],
            bot_mode,
            ability)

        local desire = functions.ternary(is_succeed, algorithm[2], 0)

        if desire ~= nil and desire ~= 0 then
           result[ability] = {target, desire}
        end
      end

      ::continue2::
    end
    ::continue1::
  end

  return result
end

local function ChooseAbilityAndTarget(bot)
  local desired_abilities = GetDesiredAbilitiesList(bot)

  local ability, target_desire = functions.GetKeyAndElementWith(
    desired_abilities,
    function(t, a, b) return t[b][2] < t[a][2] end)

  if ability == nil then
    return nil, nil end

  return ability, target_desire[1]
end

local function UseAbility(bot, ability, target)
  if ability == nil then
    return end

  logger.Print("UseAbility() - " .. bot:GetUnitName() ..
    " use " .. ability:GetName())

  local target_type = functions.GetAbilityTargetType(ability)

  if target_type == constants.ABILITY_LOCATION_TARGET then
    bot:Action_UseAbilityOnLocation(ability, target)
    return
  end

  if target_type == constants.ABILITY_NO_TARGET then
    bot:Action_UseAbility(ability)
    return
  end

  bot:Action_UseAbilityOnEntity(ability, target)
end

local function CancelAbility(bot)
  local ability = bot:GetCurrentActiveAbility()

  if not bot:IsChanneling()
     or ability == nil
     or ability:GetName() == "item_tpscroll" then
    return end

  local radius = common_algorithms.GetAbilityRadius(ability)

  if #common_algorithms.GetEnemyHeroes(bot, radius) == 0 then

    logger.Print("CancelAbility() - " .. bot:GetUnitName() ..
      " cancel " .. ability:GetName())

    bot:Action_ClearActions(true)
  end
end

function M.AbilityUsageThink()
  local bot = GetBot()

  CancelAbility(bot)

  if functions.IsBotCasting(bot) then
    return end

  local ability, target = ChooseAbilityAndTarget(bot)

  UseAbility(bot, ability, target)
end

-- Provide an access to local functions and lists for unit tests only
M.test_CalculateDesireAndTarget = CalculateDesireAndTarget
M.test_GetAbilitiesAndItems = GetAbilitiesAndItems
M.test_GetDesiredAbilitiesList = GetDesiredAbilitiesList
M.test_ChooseAbilityAndTarget = ChooseAbilityAndTarget
M.test_UseAbility = UseAbility
M.test_CancelAbility = CancelAbility

return M
