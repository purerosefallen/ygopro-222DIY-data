--夜鸦·TGRX-Ⅲ
if not pcall(function() require("expansions/script/c10114001") end) then require("script/c10114001") end
local m=10114012
local cm=_G["c"..m]
function cm.initial_effect(c)
	nrrsv.NightRavenSpecialSummonRule(c,8)
	nrrsv.NightRavenSpecialSummonEffect(c,nil,nil,cm.disop)
end
function cm.disop(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_CHAIN_SOLVING)
	e1:SetCondition(cm.discon)
	e1:SetOperation(cm.disop)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function cm.discon(e,tp,eg,ep,ev,re,r,rp)
	return re:IsActiveType(TYPE_TRAP) and rp==1-tp
end
function cm.disop(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateEffect(ev)
end