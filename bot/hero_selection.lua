local heroes = require(
    GetScriptDirectory() .."/database/heroes")

local logger = require(
    GetScriptDirectory() .."/utility/logger")

function GetBotNames ()
    return  {"Alfa", "Bravo", "Charlie", "Delta", "Echo"}
end

function IsElementInList(element, list)
  for _, e in pairs(list) do
    if e == element then return true end
  end
  return false
end

function IsIntersectionOfLists(list1, list2)
  for _, e in pairs(list1) do
    if IsElementInList(e, list2) then return true end
  end
  return false
end

function IsHeroPickedByTeam(hero, team)
  local players = GetTeamPlayers(team)

  for _, player in pairs(players) do
    if hero == GetSelectedHeroName(player) then return true end
  end

  return false
end

function IsHeroPicked(hero)
  return IsHeroPickedByTeam(hero, GetTeam())
         or IsHeroPickedByTeam(hero, GetOpposingTeam())
end

function GetRandomTrue()
  return (RandomInt(0, 100) % 2) == 0
end

function GetRandomHero(position)
  while true do
    for _, hero in pairs(heroes.HEROES) do
      if IsElementInList(position, hero.position)
        and GetRandomTrue()
        and not IsHeroPicked(hero.name) then
        logger.Print("GetRandomHero() - name = " .. hero.name .. " position = " .. hero.position[1])
        return hero.name
      end
    end
  end
end

function GetComboHero(position, combo_heroes)
  for _, hero in pairs(heroes.HEROES) do
    if IsElementInList(position, hero.position)
      and not IsHeroPicked(hero.name)
      and IsIntersectionOfLists(combo_heroes, hero.combo_heroes) then
        logger.Print("GetComboHero() - name = " .. hero.name .. " position = " .. hero.position[1])
        return hero.name
    end
  end
  return GetRandomHero(position)
end

-- TODO: Now the draft algorithm works only for all pick mode for a team of bots
function Think()
  local players = GetTeamPlayers(GetTeam())

  local heroPosition5 = GetRandomHero(5)
  SelectHero(players[5], heroPosition5)

  local heroPosition4 = GetComboHero(4, {heroPosition5})
  SelectHero(players[4], heroPosition4)

  local heroPosition3 = GetComboHero(3, {heroPosition4, heroPosition5})
  SelectHero(players[3], heroPosition3)

  local heroPosition2 = GetComboHero(
    2,
    {heroPosition3, heroPosition4, heroPosition5})

  SelectHero(players[2], heroPosition2)

  local heroPosition1 = GetComboHero(
    1,
    {heroPosition2, heroPosition3, heroPosition4, heroPosition5})

  SelectHero(players[1], heroPosition1)
end

function UpdateLaneAssignments()
  -- Radiant:  easy lane = bot / hard lane = top
  -- Dire:     easy lane = top / hard lane = bot

  -- TODO: Consider the hero combos when choosing the lanes
  if ( GetTeam() == TEAM_RADIANT ) then
    return {
      [1] = LANE_BOT,
      [2] = LANE_MID,
      [3] = LANE_TOP,
      [4] = LANE_BOT,
      [5] = LANE_TOP,
    }
  elseif ( GetTeam() == TEAM_DIRE ) then
    return {
      [1] = LANE_TOP,
      [2] = LANE_MID,
      [3] = LANE_BOT,
      [4] = LANE_TOP,
      [5] = LANE_BOT,
    }
  end
end