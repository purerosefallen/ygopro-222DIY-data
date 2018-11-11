--
local m=17061114
local cm=_G["c"..m]
function cm.initial_effect(c)
	--Activate damage
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DAMAGE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,PLAYER_ALL,800)
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Damage(tp,800,REASON_EFFECT,true)
	Duel.Damage(1-tp,1200,REASON_EFFECT,true)
	Duel.RDComplete()
end
