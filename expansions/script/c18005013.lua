--徘徊的拟魂
if not pcall(function() require("expansions/script/c18005001") end) then require("script/c18005001") end
local m=18005013
local cm=_G["c"..m]
cm.rssetcode="PseudoSoul"
function cm.initial_effect(c)
	local e1=rsef.ACT(c)  
	local e3=rsps.TrapRemoveFun(c)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_SET_AVAILABLE+EFFECT_FLAG_IGNORE_RANGE+EFFECT_FLAG_IGNORE_IMMUNE)
	e2:SetCode(EFFECT_TO_GRAVE_REDIRECT)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTarget(cm.tg)
	e2:SetTargetRange(0xff,0xff)
	e2:SetCondition(rsps.trapcon)
	e2:SetValue(LOCATION_REMOVED)
	c:RegisterEffect(e2)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(81674782)
	e4:SetRange(LOCATION_SZONE)
	e4:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	e4:SetTargetRange(0xff,0xff)
	e4:SetTarget(cm.checktg)
	c:RegisterEffect(e4)
end
function cm.tg(e,c)
	return not c:IsLocation(0x80) and not c:IsType(TYPE_SPELL+TYPE_TRAP)
end
function cm.checktg(e,c)
	return not c:IsPublic()
end