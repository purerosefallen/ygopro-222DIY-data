--心之怪盗团-Queen
if not pcall(function() require("expansions/script/c15873611") end) then require("script/c15873611") end
local m=15873616
local cm=_G["c"..m]
function cm.initial_effect(c)
	rsphh.SetCode(c)
	c:SetUniqueOnField(1,0,m)
	local e1=rsphh.ImmueFun(c,ATTRIBUTE_EARTH)
	local e2=rsef.SV_UPDATE(c,"atk",cm.val)
	--extra attack
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_EXTRA_ATTACK)
	e3:SetValue(1)
	--c:RegisterEffect(e3)
end
function cm.val(e,c)
	return Duel.GetMatchingGroupCount(rscf.FilterFaceUp(rsphh.mset),e:GetHandlerPlayer(),LOCATION_MZONE,0,nil)*300
end
