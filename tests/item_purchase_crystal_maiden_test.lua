package.path = package.path .. ";../?.lua"
require("global_functions")
require("item_purchase_crystal_maiden")

ItemPurchaseThink()

-- Buy an item_tango with 150 gold cost at the beginning
assert((GetBot():GetGold() == 475), "ItemPurchaseThink() - failed")
