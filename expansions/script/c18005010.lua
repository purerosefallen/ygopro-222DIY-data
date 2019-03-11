--封锁的拟魂.
if not pcall(function() require("expansions/script/c18005001") end) then require("script/c18005001") end
local m=18005010
local cm=_G["c"..m]
cm.rssetcode="PseudoSoul"
function cm.initial_effect(c)
	local e1=rsef.ACT(c)  
	local e3=rsps.TrapRemoveFun(c)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetTargetRange(1,1)
	e2:SetCondition(rsps.trapcon)
	c:RegisterEffect(e2)
end
