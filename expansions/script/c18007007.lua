--幻量子时间波船
if not pcall(function() require("expansions/script/c18007001") end) then require("script/c18007001") end
local m=18007007
local cm=_G["c"..m]
function cm.initial_effect(c)
	c:SetSPSummonOnce(m)
	local e1,e2=rspq.FusionSummonFun(c,m,true,false)
	local e3=rspq.LeaveFieldFun(c,m,true,true)
	local e4=rsef.SV_CHANGE(c,"code",18007005)
	e4:SetRange(LOCATION_MZONE+LOCATION_GRAVE)
end
cm.rssetcode="PhantomQuantum"
