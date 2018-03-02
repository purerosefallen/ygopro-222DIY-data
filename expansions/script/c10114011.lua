--夜鸦·TGRX-Ⅱ
if not pcall(function() require("expansions/script/c10114001") end) then require("script/c10114001") end
local m=10114011
local cm=_G["c"..m]
function cm.initial_effect(c)
	nrrsv.NightRavenSpecialSummonRule(c,8)
	nrrsv.NightRavenSpecialSummonEffect(c,CATEGORY_DESTROY,nil,cm.limitop)
end
function cm.limitop(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_COST)
	e1:SetTargetRange(0,0xff)
	e1:SetCost(cm.ccost)
	e1:SetOperation(cm.acop)
	Duel.RegisterEffect(e1,tp) 
end
function cm.ccost(e,c,tp)
	return Duel.CheckLPCost(tp,300)
end
function cm.acop(e,tp,eg,ep,ev,re,r,rp)
	Duel.PayLPCost(tp,300)
end