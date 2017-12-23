local utility = require(
    GetScriptDirectory() .."/utility/ability_item_usage")

function AbilityUsageThink()
  local npcBot = GetBot()

  utility.UseGlyph(npcBot)

  utility.UseWard(npcBot, "shadow_shaman_mass_serpent_ward")
  utility.UseChanneledSingleDisable(npcBot, "shadow_shaman_shackles")
  utility.UseSingleDisable(npcBot, "shadow_shaman_voodoo")
  utility.UseMultiNuke(npcBot, "shadow_shaman_ether_shock")
end
