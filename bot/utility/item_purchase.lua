local logger = require(
  GetScriptDirectory() .."/utility/logger")

local item_recipe = require(
  GetScriptDirectory() .."/database/item_recipe")

local item_build = require(
  GetScriptDirectory() .."/database/item_build")

local item_sell = require(
  GetScriptDirectory() .."/database/item_sell")

local functions = require(
  GetScriptDirectory() .."/utility/functions")

local constants = require(
  GetScriptDirectory() .."/utility/constants")

NEXT_BUY_ITEM = nil
NEXT_SELL_ITEM = nil

local M = {}

local function IsTpScrollPresent(npc_bot)
  local tp_scroll = npc_bot:FindItemSlot("item_tpscroll")

  return tp_scroll ~= -1
end

local function PurchaseCourier(npc_bot)
  if GetNumCouriers() > 0 then return end

  local players = GetTeamPlayers(GetTeam())

  -- Buy courier only by a player of 5th position
  if players[5] == npc_bot:GetPlayerID() then

    logger.Print("PurchaseCourier() - " .. npc_bot:GetUnitName() .. " bought courier")

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

local function GetInventoryAndStashItems(npc_bot)
  local _, result = functions.GetItems(
    npc_bot,
    constants.INVENTORY_AND_STASH_SIZE)

  return result
end

local function IsItemAlreadyBought(inventory, item)
  local index = functions.GetElementIndexInList(inventory, item)

  -- This nil assignment is required to process recipes with several
  -- identical components
  if index ~= -1 then
    inventory[index] = "nil"
    return true
  end
  return false
end

local function FindNextComponentToBuy(npc_bot, item)
  -- Do not buy anything until curier bring some items
  if npc_bot:GetCourierValue() > 0 then return "nil" end

  local component_list = item_recipe.ITEM_RECIPE[item].components

  local inventory = GetInventoryAndStashItems(npc_bot)

  for _, component in functions.spairs(component_list) do
    if component ~= "nil"
      and not IsItemAlreadyBought(inventory, component) then

      if IsRecipeItem(component) then
        return FindNextComponentToBuy(npc_bot, component)
      else
        return component
      end
    end
  end

  return "nil"
end

local function PurchaseItem(npc_bot, item)
  if IsRecipeItem(item) then
    item = FindNextComponentToBuy(npc_bot, item)
  end

  if item == "nil" or (npc_bot:GetGold() < GetItemCost(item)) then
    return
  end

  NEXT_BUY_ITEM = item
end

local function FindNextItemToBuy(item_list)
  for i, item in functions.spairs(item_list) do
    if item ~= "nil" then return i, item end
  end

  return "nil"
end

local function PurchaseItemList(npc_bot, item_type)
  if NEXT_BUY_ITEM ~= nil then return end

  local item_list = item_build.ITEM_BUILD[npc_bot:GetUnitName()].items

  local i, item = FindNextItemToBuy(item_list)

  if functions.IsElementInList(
    GetInventoryAndStashItems(
      npc_bot),
      item) then

    item_list[i] = "nil"
    return
  end

  PurchaseItem(npc_bot, item)
end

local function SellItemByIndex(npc_bot, index, condition)
  local item = npc_bot:GetItemInSlot(index);

  if npc_bot:GetLevel() < condition.level
    and DotaTime() < (condition.time * 60) then

    return
  end

  if npc_bot:DistanceFromFountain() <= constants.BASE_SHOP_USE_RADIUS
    or npc_bot:DistanceFromSideShop() <= constants.SHOP_USE_RADIUS
    or npc_bot:DistanceFromSecretShop() <= constants.SHOP_USE_RADIUS then

    NEXT_SELL_ITEM = item
  end
end

local function GetSlotIndex(inventory_index)
  return inventory_index - 1
end

local function SellExtraItem(npc_bot)
  if NEXT_SELL_ITEM ~= nil then return end

  if not functions.IsItemSlotsFull(npc_bot) then return end

  local inventory = functions.GetInventoryItems(npc_bot)

  for item, condition in functions.spairs(item_sell.ITEM_SELL) do

    local index = functions.GetElementIndexInList(inventory, item)

    if index ~= -1 then

      SellItemByIndex(
        npc_bot,
        GetSlotIndex(index),
        condition)
      return
    end
  end

end

function M.ItemPurchaseThink()
  local npc_bot = GetBot()

  PurchaseCourier(npc_bot)

  PurchaseTpScroll(npc_bot)

  SellExtraItem(npc_bot)

  PurchaseItemList(npc_bot)
end

-- Provide an access to local functions for unit tests only
M.test_IsTpScrollPresent = IsTpScrollPresent
M.test_PurchaseCourier = PurchaseCourier
M.test_PurchaseTpScroll = PurchaseTpScroll
M.test_IsRecipeItem = IsRecipeItem
M.test_IsItemAlreadyBought = IsItemAlreadyBought
M.test_GetInventoryAndStashItems = GetInventoryAndStashItems
M.test_FindNextComponentToBuy = FindNextComponentToBuy
M.test_PurchaseItem = PurchaseItem
M.test_FindNextItemToBuy = FindNextItemToBuy
M.test_PurchaseItemList = PurchaseItemList
M.test_SellItemByIndex = SellItemByIndex
M.test_SellExtraItem = SellExtraItem

return M
