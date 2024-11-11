local addonName, addon = ...

--[[
   Wait for all of addon loaded, player login, world playable, and a small delay before playing a sound.

   References:
   https://www.reddit.com/r/wowaddons/comments/1gf2so1/audible_login_alert/
   https://www.wowhead.com/sounds
   https://www.wowinterface.com/forums/showthread.php?t=55060
   https://cdn.wowinterface.com/forums/showthread.php?t=39536
]]--

local f = CreateFrame("Frame")

-- state variables to track which events have been seen
local login
local variables_loaded
local entering_world

-- configuration
local sound = SOUNDKIT.READY_CHECK -- ReadyCheck
local delayTime = 3

-- the meat of the business
local function onevent(self, event, arg1, ...)
   if (not login) and (event == "PLAYER_LOGIN") then
      login = true
      f:UnregisterEvent("PLAYER_LOGIN")
   elseif (not variables_loaded) and (event == "VARIABLES_LOADED") then
      variables_loaded = true
      f:UnregisterEvent("VARIABLES_LOADED")
   elseif (not entering_world) and (event == "PLAYER_ENTERING_WORLD") then
      entering_world = true
   else
      return -- shouldn't happen, unrecognized/unregistered event
   end
   -- once they're all true, play the sound and reset entering_world
   if login and variables_loaded and entering_world then
      entering_world = false -- reset for detecting next time
      C_Timer.After(0, function()
         C_Timer.After(delayTime, function()
            PlaySound(sound)
         end)
      end)
   end
end
     
f:SetScript("OnEvent", onevent)
f:RegisterEvent("PLAYER_LOGIN")
f:RegisterEvent("VARIABLES_LOADED")
f:RegisterEvent("PLAYER_ENTERING_WORLD")
