--crab,soidier of dragon palace
function c11451412.initial_effect(c)
	c:EnableReviveLimit()
	--effect1
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(11451412,0))
	e1:SetCategory(CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_HAND)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_MAIN_END)
	e1:SetCountLimit(1,11451402)
	e1:SetCondition(c11451412.condition)
	e1:SetTarget(c11451412.target)
	e1:SetOperation(c11451412.operation)
	c:RegisterEffect(e1)
	--effect2
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(11451412,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCountLimit(1,11451412)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCondition(c11451412.condition2)
	e2:SetOperation(c11451412.operation2)
	c:RegisterEffect(e2)
end
function c11451412.mat_filter(c)
	return c:IsAttribute(ATTRIBUTE_WATER)
end
function c11451412.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()~=tp and (Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2) and not e:GetHandler():IsPublic() and Duel.IsExistingMatchingCard(c11451412.filter,tp,LOCATION_DECK,0,1,nil,tp)
end
function c11451412.filter(c,tp)
	return c:IsSetCard(0x6978) and bit.band(c:GetType(),0x82)==0x82 and c:IsAbleToGraveAsCost() and c:CheckActivateEffect(true,true,false)~=nil
end
function c11451412.filter2(c,e,tp)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x6978) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c11451412.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c11451412.filter,tp,LOCATION_DECK,0,1,1,nil,tp)
	local c=g:GetFirst():CheckActivateEffect(true,true,false)
	e:SetLabelObject(c)
	Duel.SendtoGrave(g,REASON_COST)
	e:SetCategory(c:GetCategory())
	e:SetProperty(c:GetProperty())
	local target=c:GetTarget()
	if target then target(e,tp,eg,ep,ev,re,r,rp,1) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,e:GetHandler(),1,0,0)
end
function c11451412.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetLabelObject()
	if not c then return end
	local operation=c:GetOperation()
	if operation then operation(e,tp,eg,ep,ev,re,r,rp) end
	Duel.BreakEffect()
	Duel.SendtoGrave(e:GetHandler(),REASON_EFFECT)
end
function c11451412.condition2(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_RITUAL)
end
function c11451412.operation2(e,tp,eg,ep,ev,re,r,rp)
	--effect phase end
	local e3=Effect.CreateEffect(e:GetHandler())
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_PHASE+PHASE_END)
	e3:SetCountLimit(1)
	e3:SetCondition(c11451412.condition3)
	e3:SetOperation(c11451412.operation3)
	e3:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e3,tp)
end
function c11451412.condition3(e,tp,eg,ep,ev,re,r,rp)
	local count1=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local count2=Duel.GetFieldGroupCount(tp,0,LOCATION_ONFIELD)
	local g=Duel.GetMatchingGroup(aux.NecroValleyFilter(c11451412.filter2),tp,LOCATION_GRAVE,0,nil,e,tp)
	return count1~=0 and count2~=0 and g:GetCount()~=0
end
function c11451412.operation3(e,tp,eg,ep,ev,re,r,rp)
	local count1=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local count2=Duel.GetFieldGroupCount(tp,0,LOCATION_ONFIELD)
	local g=Duel.GetMatchingGroup(aux.NecroValleyFilter(c11451412.filter2),tp,LOCATION_GRAVE,0,nil,e,tp)
	if Duel.IsPlayerAffectedByEffect(tp,59822133) then count1=1 end
	repeat
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g2=g:Select(tp,1,1,nil)
		local c=g2:GetFirst()
		Duel.SpecialSummonStep(c,0,tp,tp,false,false,POS_FACEUP)
		g:Remove(Card.IsCode,nil,c:GetCode())
		count1=count1-1
		count2=count2-1
	until count1==0 or count2==0 or g:GetCount()==0 or not Duel.SelectYesNo(tp,aux.Stringid(11451412,2))
	Duel.SpecialSummonComplete()
end