local function log(msg)
    --DEFAULT_CHAT_FRAME:AddMessage("DEPAG: " .. msg, 1, 1, 0.5);
end

local UpdateInterval = 1.0;
local TimeSinceLastUpdate = GetTime();
local SecElapsed = 0;
local lastActionbarPage = 0;

-- the default bar number between 1 and 6. (1 is the main bar)
local defaultActionbarPage = 1;
-- delay in second before it swtich back to th default bar
local Delay = 4;

function SetPagetoDefault()
    log("reset to default page")
    CURRENT_ACTIONBAR_PAGE = defaultActionbarPage;
    ChangeActionBarPage();
end

local AnchorSwap = CreateFrame("Frame");
AnchorSwap:RegisterEvent("PLAYER_LEAVE_COMBAT");
AnchorSwap:RegisterEvent("ACTIONBAR_PAGE_CHANGED");

AnchorSwap:SetScript("OnEvent", function()
    if event == "PLAYER_LEAVE_COMBAT" then
        log("out of combat");
        SetPagetoDefault();
    elseif event == "ACTIONBAR_PAGE_CHANGED" then
        SecElapsed = 0;
    end

end)

-- if u want to disable switch to default after a delay
-- u can comment out this part
AnchorSwap:SetScript("OnUpdate", function(self, elapsed)
    if (GetTime() - TimeSinceLastUpdate > UpdateInterval) then
        TimeSinceLastUpdate = GetTime();
        if (CURRENT_ACTIONBAR_PAGE ~= defaultActionbarPage) then
            log("sec counter: " .. SecElapsed)
            SecElapsed = SecElapsed + 1;
        end
        if (SecElapsed > Delay) then
            SetPagetoDefault();
            SecElapsed = 0;
        end
    end
end)

-- if u want disable the switch to default after a action key press
-- u can comment out this part below
savedUseAction = UseAction
function newUseAction(slot, checkCursor, onSelf)
    log(CURRENT_ACTIONBAR_PAGE);
    if (CURRENT_ACTIONBAR_PAGE ~= 1) then SetPagetoDefault(); end
    savedUseAction(slot, checkCursor, onSelf)
end
UseAction = newUseAction

