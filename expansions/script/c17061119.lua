--
local m=17061119
local cm=_G["c"..m]
function cm.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure(c,nil,aux.NonTuner(nil),1)
	c:EnableReviveLimit()
	--direct attack
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_DIRECT_ATTACK)
	e1:SetCondition(cm.buffcon)
	c:RegisterEffect(e1)
end
function cm.buffcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetLP(tp)<=4000 and e:GetHandler():IsSummonType(SUMMON_TYPE_SYNCHRO)
end