local logger = require(
  GetScriptDirectory() .."/utility/logger")

local item_recipe = require(
  GetScriptDirectory() .."/database/item_recipe")

local item_build = require(
  GetScriptDirectory() .."/database/item_build")

local functions = require(
  GetScriptDirectory() .."/utility/functions")

local M = {}

local function IsTpScrollPresent(npc_bot)
  local tp_scroll = npc_bot:FindItemSlot("item_tpscroll")

  return tp_scroll ~= -1
end

local function PurchaseCourier(npc_bot)
  if GetNumCouriers() > 0 then return end

  local players = GetTeamPlayers(GetTeam())

  -- Buy courier only by player of 5th position
  if players[5] == npc_bot:GetPlayerID() then

    logger.Print("PurchaseCourier() - " .. npc_bot:GetUnitName() .. " bought Courier")

    npc_bot:ActionImmediate_PurchaseItem("item_courier")
  end
end

local function PurchaseTpScroll(npc_bot)
  if IsTpScrollPresent(npc_bot) then return end

  if (npc_bot:GetGold() >= GetItemCost("item_tpscroll")) then

    logger.Print("PurchaseTpScroll() - " .. npc_bot:GetUnitName() .. " bought TpScroll")

    npc_bot:ActionImmediate_PurchaseItem("item_tpscroll")
  end
end

local function IsRecipeItem(item)
  return item_recipe.ITEM_RECIPE[item] ~= nil
end

local function IsItemAlreadyBought(item, inventory)
  local index = functions.GetElementIndexInList(item, inventory)

  if index ~= -1 then
    inventory[index] = "nil"
    return true
  end
  return false
end

local function GetInventoryAndStashItems(npc_bot)
  local result = {}

  for i = 0, 16, 1 do
    local item = npc_bot:GetItemInSlot(i)
    if item ~= nil then
      table.insert(result, item:GetName())
    else
      table.insert(result, "nil")
    end
  end

  return result
end

local function FindNextComponentToBuy(npc_bot, item)
  -- Do not buy anything until curier bring some items
  if npc_bot:GetCourierValue() > 0 then return "nil" end

  local component_list = item_recipe.ITEM_RECIPE[item].components

  local inventory = GetInventoryAndStashItems(npc_bot)

  for _, component in pairs(component_list) do
    if component ~= "nil"
      and not IsItemAlreadyBought(component, inventory) then

      return component
    end
  end

  return "nil"
end

local function PurchaseItem(npc_bot, item)
  if IsRecipeItem(item) then
    item = FindNextComponentToBuy(npc_bot, item)
  end

  if item ~= "nil" and (npc_bot:GetGold() >= GetItemCost(item)) then

    logger.Print("PurchaseItem() - " .. npc_bot:GetUnitName() .. " bought " .. item)

    return npc_bot:ActionImmediate_PurchaseItem(item)
            == PURCHASE_ITEM_SUCCESS
  end

  return false
end

local function FindNextItemToBuy(item_list)
  for i, item in pairs(item_list) do
    if item ~= "nil" then return i, item end
  end

  return "nil"
end

local function PurchaseItemList(npc_bot, item_type)
  local item_list = item_build.ITEM_BUILD[npc_bot:GetUnitName()].items

  local i, item = FindNextItemToBuy(item_list)

  if PurchaseItem(npc_bot, item)
    and IsItemAlreadyBought(item, GetInventoryAndStashItems(npc_bot)) then

    -- Mark the item as bought
    item_list[i] = "nil"
  end
end

function M.ItemPurchaseThink()
  local npc_bot = GetBot()

  PurchaseCourier(npc_bot)

  PurchaseTpScroll(npc_bot)

  PurchaseItemList(npc_bot)
end

-- Provide an access to local functions for unit tests only
M.test_IsTpScrollPresent = IsTpScrollPresent
M.test_PurchaseCourier = PurchaseCourier
M.test_PurchaseTpScroll = PurchaseTpScroll
M.test_PurchaseItem = PurchaseItem
M.test_FindNextItemToBuy = FindNextItemToBuy
M.test_PurchaseItemList = PurchaseItemList

return M