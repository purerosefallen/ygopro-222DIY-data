--人格面具-义经
if not pcall(function() require("expansions/script/c15873611") end) then require("script/c15873611") end
local m=15873642
local cm=_G["c"..m]
function cm.initial_effect(c)
	rsphh.SetCode(c,true)
	local e2=rsef.SV_INDESTRUCTABLE(c,"battle")
	local e3=rsphh.ImmueFun(c,ATTRIBUTE_LIGHT)
	local e4=rsphh.EndPhaseFun(c,15873611)
	--attack all
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_ATTACK_ALL)
	e1:SetValue(1)
	c:RegisterEffect(e1) 
end
