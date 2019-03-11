--改造的拟魂
if not pcall(function() require("expansions/script/c18005001") end) then require("script/c18005001") end
local m=18005011
local cm=_G["c"..m]
cm.rssetcode="PseudoSoul"
function cm.initial_effect(c)
	local e1=rsef.ACT(c)  
	local e2=rsef.FV_LIMIT(c,"dis",nil,cm.distg,{LOCATION_MZONE,LOCATION_MZONE },rsps.trapcon)
	local e4=rsps.TrapRemoveFun(c)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_SET_ATTACK_FINAL)
	e3:SetRange(LOCATION_SZONE)
	e3:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e3:SetTarget(cm.distg)
	e3:SetCondition(rsps.trapcon)
	e3:SetValue(0)
	c:RegisterEffect(e3)
end
function cm.distg(e,c)
	return c:IsSummonType(SUMMON_TYPE_SPECIAL)
end