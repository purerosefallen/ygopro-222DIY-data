--双色的怀柔
function c12008024.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(c12008024.condition)
	e1:SetTarget(c12008024.target)
	e1:SetOperation(c12008024.activate)
	c:RegisterEffect(e1)
end
function c12008024.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetActivityCount(tp,ACTIVITY_BATTLE_PHASE)==0 and not Duel.CheckPhaseActivity()
end
function c12008024.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,LOCATION_HAND,0,1,nil) and  Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,0,LOCATION_HAND,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,tp,LOCATION_HAND)
end
function c12008024.activate(e,tp,eg,ep,ev,re,r,rp,c)
	local c=e:GetHandler()
	g=Duel.GetFieldGroup(tp,LOCATION_HAND,LOCATION_HAND)
	if g:GetCount()<=0 or Duel.Remove(g,POS_FACEUP,REASON_EFFECT+REASON_TEMPORARY)<=0 then return end
	local og=Duel.GetOperatedGroup()
	local oc=og:GetFirst()
	while oc do
		  oc:RegisterFlagEffect(12008024,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,1)
		oc=og:GetNext()
	end
	og:KeepAlive()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_PHASE+PHASE_END)
	e1:SetReset(RESET_PHASE+PHASE_END,1)
	e1:SetCountLimit(1)
	e1:SetLabelObject(og)
	e1:SetOperation(c12008024.retop)
	Duel.RegisterEffect(e1,tp)
end
function c12008024.retfilter(c)
	return c:GetFlagEffect(12008024)~=0
end
function c12008024.retop(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetLabelObject()
	local sg=g:Filter(c12008024.retfilter,nil)
	if sg:GetCount()<=0 then return end
	local thg=sg:Filter(Card.IsPreviousLocation,nil,LOCATION_HAND)
	if thg:GetCount()>0 then
	   Duel.SendtoHand(thg,nil,REASON_EFFECT)
	   sg:Sub(thg)
	end
	local tc=sg:GetFirst()
	while tc do
		Duel.ReturnToField(tc)
		tc=sg:GetNext()
	end
end