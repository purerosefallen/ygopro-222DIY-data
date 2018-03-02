--夜鸦·TGR-Ⅲ
if not pcall(function() require("expansions/script/c10114001") end) then require("script/c10114001") end
local m=10114009
local cm=_G["c"..m]
function cm.initial_effect(c)
	nrrsv.NightRavenSpecialSummonRule(c,7)
	nrrsv.NightRavenSpecialSummonEffect(c,nil,nil,cm.indop)
end
function cm.indop(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_INDESTRUCTABLE_COUNT)
	e1:SetTargetRange(LOCATION_ONFIELD,0)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x3331))
	e1:SetValue(cm.indct)
	Duel.RegisterEffect(e1,tp)
end
function cm.indct(e,re,r,rp)
	if bit.band(r,REASON_BATTLE+REASON_EFFECT)~=0 then
		return 1
	else return 0 end
end