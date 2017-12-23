local functions = require(
  GetScriptDirectory() .."/utility/functions")

local M = {}

local function IsCourierFree(state)
  return state ~= COURIER_STATE_MOVING
         and state ~= COURIER_STATE_DELIVERING_ITEMS
end

local function IsCourierIdle(time, state)
  if state ~= COURIER_STATE_IDLE then return end

  if courier.idle_time == nil then
    courier.idle_time = GameTime()
  elseif 10 < (GameTime() - courier.idle_time) then
    return true
  end

  return false
end

local function IsSecretShopRequired(npc_bot)
  return npc_bot.is_secret_shop_required ~= nil
         and npc_bot.is_secret_shop_required
         and npc_botGetActiveMode() ~= BOT_MODE_SECRET_SHOP
end

local function IsCourierDamaged(courier)
  return courier:GetHealth() / courier:GetMaxHealth() <= 0.9
end

function M.CourierUsageThink()
  local npc_bot = GetBot()
  local courier = GetCourier(0)

  if not npc_bot:IsAlive() or courier == nil then
    return
  end

  local courier_state = GetCourierState(courier)

  if state == COURIER_STATE_DEAD then return end

  if IsCourierDamaged(courier) then
    npc_bot:ActionImmediate_Courier(courier, COURIER_ACTION_BURST)
  end

  if IsCourierFree(courier_state) and npc_bot:GetCourierValue() > 0
    and not functions.IsItemSlotsFull() then

    npc_bot:ActionImmediate_Courier(
      courier,
      COURIER_ACTION_TRANSFER_ITEMS)
  end

  if IsCourierFree(courier_state) and IsSecretShopRequired(npc_bot) then

    npc_bot:ActionImmediate_Courier(courier, COURIER_ACTION_SECRET_SHOP)
  end

  if courier_state == COURIER_STATE_AT_BASE
    and npc_bot:GetStashValue() > 0 then

    npc_bot:ActionImmediate_Courier(
      courier,
      COURIER_ACTION_TAKE_AND_TRANSFER_ITEMS)
  end

  if IsCourierIdle(courier) then

    npc_bot:ActionImmediate_Courier(courier, COURIER_ACTION_RETURN)

  end
end

-- Provide an access to local functions for unit tests only
M.test_IsCourierFree = IsCourierFree
M.test_IsCourierIdle = IsCourierIdle
M.test_IsSecretShopRequired = IsSecretShopRequired
M.test_IsCourierDamaged = IsCourierDamaged

return M