--晚饭时间
function c81009055.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TODECK)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_ATTACK_ANNOUNCE)
	e1:SetCountLimit(1,81009055+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(c81009055.condition)
	e1:SetTarget(c81009055.target)
	e1:SetOperation(c81009055.operation)
	c:RegisterEffect(e1)
end
function c81009055.condition(e,tp,eg,ep,ev,re,r,rp)
	return eg:GetFirst():IsControler(1-tp) and Duel.GetAttackTarget()==nil
end
function c81009055.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,LOCATION_MZONE,LOCATION_MZONE)>0 end
	local rec=Duel.GetFieldGroupCount(tp,LOCATION_MZONE,LOCATION_MZONE)*800
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(rec)
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,rec)
end
function c81009055.operation(e,tp,eg,ep,ev,re,r,rp)
	local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
	local rec=Duel.GetFieldGroupCount(tp,LOCATION_MZONE,LOCATION_MZONE)*800
	Duel.Recover(p,rec,REASON_EFFECT)
end
