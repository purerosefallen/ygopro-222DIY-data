--谎言的虚假之影
function c66913800.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0x371),aux.NonTuner(Card.IsSetCard,0x371),1)
	c:EnableReviveLimit()
	--remove
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(66913800,0))
	e1:SetCategory(CATEGORY_REMOVE+CATEGORY_ATKCHANGE)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(c66913800.drcon)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetTarget(c66913800.rmtg)
	e1:SetOperation(c66913800.rmop)
	c:RegisterEffect(e1)  
	--remove
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_REMOVE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER_E)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,66913800)
	e2:SetCost(c66913800.descost)
	e2:SetTarget(c66913800.destg)
	e2:SetOperation(c66913800.desop)
	c:RegisterEffect(e2)  
end
function c66913800.drcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_SYNCHRO)
end
function c66913800.rmtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local rg=Duel.GetDecktopGroup(tp,10)
	if chk==0 then return rg:FilterCount(Card.IsAbleToRemove,nil)==10 end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,rg,10,0,0)
end
function c66913800.rmop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetDecktopGroup(tp,10)
	if g:GetCount()>0 and Duel.Remove(g,POS_FACEUP,REASON_EFFECT)~=0
		and c:IsFaceup() and c:IsRelateToEffect(e) then
		local og=Duel.GetOperatedGroup()
		local oc=og:FilterCount(Card.IsSetCard,nil,0x371)
		if oc==0 then return end
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(oc*100)
		e1:SetReset(RESET_EVENT+0x1ff0000)
		c:RegisterEffect(e1)
	end
end
function c66913800.cfilter(c)
	return  c:IsAbleToRemoveAsCost()
end
function c66913800.descost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c66913800.cfilter,tp,LOCATION_HAND,0,3,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c66913800.cfilter,tp,LOCATION_HAND,0,3,3,nil)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c66913800.filter(c)
	return  c:IsAbleToRemove()
end
function c66913800.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c66913800.filter,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,e:GetHandler()) end
	local g=Duel.GetMatchingGroup(c66913800.filter,tp,LOCATION_GRAVE,LOCATION_GRAVE,e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,g:GetCount(),0,0)
end
function c66913800.desop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c66913800.filter,tp,LOCATION_GRAVE,LOCATION_GRAVE,nil)
	Duel.Remove(g,nil,2,POS_FACEUP,REASON_EFFECT)
end


