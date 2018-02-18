local item_build = require(
  GetScriptDirectory() .."/database/item_build")

local M = {}

-- Format of the PURCHASE_LIST list:
-- {
--   hero_name = {
--     ITEM_TO_BUY = "item_name",
--     ITEM_TO_SELL = item_handle,
--     ITEM_BUILD = { "item_name", "item_name", ...}
--   },
-- ...
-- }

PURCHASE_LIST = {}

local function IsInitPurchaseList(bot)
  return PURCHASE_LIST ~= nil and PURCHASE_LIST[bot:GetUnitName()] ~= nil
end

local function InitPurchaseList(bot)
  if not IsInitPurchaseList(bot) then
    PURCHASE_LIST[bot:GetUnitName()] = {}
  end
end

function M.GetItemToSell(bot)
  return PURCHASE_LIST[bot:GetUnitName()].ITEM_TO_SELL
end

function M.GetItemToBuy(bot)
  return PURCHASE_LIST[bot:GetUnitName()].ITEM_TO_BUY
end

function M.SetItemToSell(bot, item)
  PURCHASE_LIST[bot:GetUnitName()].ITEM_TO_SELL = item
end

function M.SetItemToBuy(bot, item)
  PURCHASE_LIST[bot:GetUnitName()].ITEM_TO_BUY = item
end

function M.GetItemBuild(bot)
  return PURCHASE_LIST[bot:GetUnitName()].ITEM_BUILD
end

function M.MakePurchaseList(bot)
  InitPurchaseList(bot)

  PURCHASE_LIST[bot:GetUnitName()].ITEM_BUILD =
    item_build.ITEM_BUILD[bot:GetUnitName()].items
end

-- Provide an access to local functions for unit tests only
M.test_InitPurchaseList = InitPurchaseList

return M