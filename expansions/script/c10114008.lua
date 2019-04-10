--夜鸦·TGR-Ⅱ
if not pcall(function() require("expansions/script/c10114001") end) then require("script/c10114001") end
local m=10114008
local cm=_G["c"..m]
function cm.initial_effect(c)
	nrrsv.NightRavenSpecialSummonRule(c,7)
	nrrsv.NightRavenSpecialSummonEffect(c,nil,cm.lvtg,cm.lvop)
end
function cm.lvtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.Hint(HINT_SELECTMSG,tp,567)
	local lv=Duel.AnnounceNumber(tp,4,5,6,7)
	Duel.SetTargetParam(lv)
end
function cm.lvop(e,tp,eg,ep,ev,re,r,rp)
	local lv=Duel.GetChainInfo(0,CHAININFO_TARGET_PARAM)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CHANGE_LEVEL)
	e1:SetReset(RESET_PHASE+PHASE_END,2)
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x3331))
	e1:SetValue(lv)
	Duel.RegisterEffect(e1,tp)
end
