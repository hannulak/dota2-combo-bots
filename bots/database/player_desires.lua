
local M = {}

M.PLAYER_DESIRES = {

  has_low_hp = {
    BOT_MODE_PUSH_TOWER_TOP = {-30, 0},
    BOT_MODE_PUSH_TOWER_MID = {-30, 0},
    BOT_MODE_PUSH_TOWER_BOT = {-30, 0},
    BOT_MODE_RETREAT = {85, 0},
    BOT_MODE_TEAM_ROAM = {-30, 0},
    BOT_MODE_ATTACK  = {-30, 0},
    BOT_MODE_EVASIVE_MANEUVERS = {0, 0},
    BOT_MODE_LANING = {15, 16}
  },

  player_on_top = {
    BOT_MODE_PUSH_TOWER_TOP = {5, 0},
    BOT_MODE_PUSH_TOWER_MID = {-5, 0},
    BOT_MODE_PUSH_TOWER_BOT = {-5, 0},
    BOT_MODE_RETREAT = {0, 0},
    BOT_MODE_TEAM_ROAM = {0, 0},
    BOT_MODE_ATTACK  = {0, 0},
    BOT_MODE_EVASIVE_MANEUVERS = {0, 0},
    BOT_MODE_LANING = {15, 16}
  },

  player_on_mid = {
    BOT_MODE_PUSH_TOWER_TOP = {-5, 0},
    BOT_MODE_PUSH_TOWER_MID = {5, 0},
    BOT_MODE_PUSH_TOWER_BOT = {-5, 0},
    BOT_MODE_RETREAT = {0, 0},
    BOT_MODE_TEAM_ROAM = {0, 0},
    BOT_MODE_ATTACK  = {0, 0},
    BOT_MODE_EVASIVE_MANEUVERS = {0, 0},
    BOT_MODE_LANING = {15, 16}
  },

  player_on_bot = {
    BOT_MODE_PUSH_TOWER_TOP = {-5, 0},
    BOT_MODE_PUSH_TOWER_MID = {-5, 0},
    BOT_MODE_PUSH_TOWER_BOT = {5, 0},
    BOT_MODE_RETREAT = {0, 0},
    BOT_MODE_TEAM_ROAM = {0, 0},
    BOT_MODE_ATTACK  = {0, 0},
    BOT_MODE_EVASIVE_MANEUVERS = {0, 0},
    BOT_MODE_LANING = {15, 16}
  },

  has_tp_scroll_or_travel_boots = {
    BOT_MODE_PUSH_TOWER_TOP = {5, -5},
    BOT_MODE_PUSH_TOWER_MID = {5, -5},
    BOT_MODE_PUSH_TOWER_BOT = {5, -5},
    BOT_MODE_RETREAT = {0, 0},
    BOT_MODE_TEAM_ROAM = {10, -10},
    BOT_MODE_ATTACK  = {0, 0},
    BOT_MODE_EVASIVE_MANEUVERS = {0, 0},
    BOT_MODE_LANING = {15, 16}
  },

  has_buyback = {
    BOT_MODE_PUSH_TOWER_TOP = {0, -5},
    BOT_MODE_PUSH_TOWER_MID = {0, -5},
    BOT_MODE_PUSH_TOWER_BOT = {0, -5},
    BOT_MODE_RETREAT = {0, 0},
    BOT_MODE_TEAM_ROAM = {0, -5},
    BOT_MODE_ATTACK  = {0, 0},
    BOT_MODE_EVASIVE_MANEUVERS = {0, 0},
    BOT_MODE_LANING = {15, 16}
  },

  is_shrine_healing_and_no_enemy = {
    BOT_MODE_PUSH_TOWER_TOP = {0, 0},
    BOT_MODE_PUSH_TOWER_MID = {0, 0},
    BOT_MODE_PUSH_TOWER_BOT = {0, 0},
    BOT_MODE_RETREAT = {76, 0},
    BOT_MODE_TEAM_ROAM = {0, 0},
    BOT_MODE_ATTACK  = {-30, 0},
    BOT_MODE_EVASIVE_MANEUVERS = {0, 0},
    BOT_MODE_LANING = {15, 16}
  },

  is_shrine_healing_and_enemies_near = {
    BOT_MODE_PUSH_TOWER_TOP = {0, 0},
    BOT_MODE_PUSH_TOWER_MID = {0, 0},
    BOT_MODE_PUSH_TOWER_BOT = {0, 0},
    BOT_MODE_RETREAT = {-85, 0},
    BOT_MODE_TEAM_ROAM = {0, 0},
    BOT_MODE_ATTACK  = {0, 0},
    BOT_MODE_EVASIVE_MANEUVERS = {0, 0},
    BOT_MODE_LANING = {15, 16}
  },

  has_not_full_hp_mp_and_near_fountain = {
    BOT_MODE_PUSH_TOWER_TOP = {-10, 0},
    BOT_MODE_PUSH_TOWER_MID = {-10, 0},
    BOT_MODE_PUSH_TOWER_BOT = {-10, 0},
    BOT_MODE_RETREAT = {76, 0},
    BOT_MODE_TEAM_ROAM = {-10, 0},
    BOT_MODE_ATTACK  = {0, 0},
    BOT_MODE_EVASIVE_MANEUVERS = {0, 0},
    BOT_MODE_LANING = {15, 16}
  },

  roam_target_is_near = {
    BOT_MODE_PUSH_TOWER_TOP = {0, 0},
    BOT_MODE_PUSH_TOWER_MID = {0, 0},
    BOT_MODE_PUSH_TOWER_BOT = {0, 0},
    BOT_MODE_RETREAT = {0, 0},
    BOT_MODE_TEAM_ROAM = {10, -50},
    BOT_MODE_ATTACK  = {0, 0},
    BOT_MODE_EVASIVE_MANEUVERS = {0, 0},
    BOT_MODE_LANING = {15, 16}
  },

  is_weaker_enemy_hero_near = {
    BOT_MODE_PUSH_TOWER_TOP = {0, 0},
    BOT_MODE_PUSH_TOWER_MID = {0, 0},
    BOT_MODE_PUSH_TOWER_BOT = {0, 0},
    BOT_MODE_RETREAT = {0, 0},
    BOT_MODE_TEAM_ROAM = {0, 0},
    BOT_MODE_ATTACK  = {55, 0},
    BOT_MODE_EVASIVE_MANEUVERS = {0, 0},
    BOT_MODE_LANING = {15, 16}
  },

  is_focused_by_enemies = {
    BOT_MODE_PUSH_TOWER_TOP = {-30, 0},
    BOT_MODE_PUSH_TOWER_MID = {-30, 0},
    BOT_MODE_PUSH_TOWER_BOT = {-30, 0},
    BOT_MODE_RETREAT = {0, 0},
    BOT_MODE_TEAM_ROAM = {-10, 0},
    BOT_MODE_ATTACK  = {-30, 0},
    BOT_MODE_EVASIVE_MANEUVERS = {76, 0},
    BOT_MODE_LANING = {15, 16}
  },

  has_level_six = {
    BOT_MODE_PUSH_TOWER_TOP = {-10, 0},
    BOT_MODE_PUSH_TOWER_MID = {-10, 0},
    BOT_MODE_PUSH_TOWER_BOT = {-10, 0},
    BOT_MODE_RETREAT = {0, 0},
    BOT_MODE_TEAM_ROAM = {-10, 0},
    BOT_MODE_ATTACK  = {-30, 0},
    BOT_MODE_EVASIVE_MANEUVERS = {0, 0},
    BOT_MODE_LANING = {15, 16}
  },

}

return M
