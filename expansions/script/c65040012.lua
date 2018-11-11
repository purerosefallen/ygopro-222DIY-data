--逆海长龙
function c65040012.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure(c,nil,aux.NonTuner(nil),1)
	c:EnableReviveLimit()
	--pierce
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_PIERCE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(LOCATION_MZONE,0)
	c:RegisterEffect(e1)
	--destroy
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DESTROY+CATEGORY_POSITION)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_MAIN_END)
	e2:SetCondition(c65040012.descon)
	e2:SetTarget(c65040012.destg)
	e2:SetOperation(c65040012.desop)
	c:RegisterEffect(e2)
end
function c65040012.descon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2
end
function c65040012.posfilter(c)
	return c:IsFaceup() and c:IsCanTurnSet()
end
function c65040012.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c65040012.posfilter,tp,0,LOCATION_MZONE,1,nil) end
	local g=Duel.GetMatchingGroup(c65040012.posfilter,tp,0,LOCATION_MZONE,nil)
	Duel.SetOperationInfo(0,CATEGORY_POSITION,g,g:GetCount(),0,0)
end
function c65040012.desop(e,tp,eg,ep,ev,re,r,rp)
	local g2=Duel.GetMatchingGroup(c65040012.posfilter,tp,0,LOCATION_MZONE,nil)
	if g2:GetCount()>0 then
		Duel.ChangePosition(g2,POS_FACEDOWN_DEFENSE)
		Duel.Damage(1-tp,1000,REASON_EFFECT)
	end
end