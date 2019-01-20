--yaksha,warrior of dragon palace
function c11451413.initial_effect(c)
	c:EnableReviveLimit()
	--effect1
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(11451413,0))
	e1:SetCategory(CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_HAND)
	e1:SetHintTiming(0,TIMING_BATTLE_START+TIMING_ATTACK+TIMING_BATTLE_END)
	e1:SetCountLimit(1,11451403)
	e1:SetCondition(c11451413.condition)
	e1:SetTarget(c11451413.target)
	e1:SetOperation(c11451413.operation)
	c:RegisterEffect(e1)
	--effect2
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(11451413,1))
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCountLimit(1,11451413)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCondition(c11451413.condition2)
	e2:SetOperation(c11451413.operation2)
	c:RegisterEffect(e2)
end
function c11451413.mat_filter(c)
	return c:IsAttribute(ATTRIBUTE_WATER)
end
function c11451413.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()~=tp and (Duel.GetCurrentPhase()>=PHASE_BATTLE_START and Duel.GetCurrentPhase()<=PHASE_BATTLE) and not e:GetHandler():IsPublic() and Duel.IsExistingMatchingCard(c11451413.filter,tp,LOCATION_DECK,0,1,nil,tp)
end
function c11451413.filter(c,tp)
	return c:IsSetCard(0x6978) and bit.band(c:GetType(),0x82)==0x82 and c:IsAbleToGraveAsCost() and c:CheckActivateEffect(true,true,false)~=nil
end
function c11451413.filter2(c)
	return c:IsFaceup() and c:IsSetCard(0x6978)
end
function c11451413.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c11451413.filter,tp,LOCATION_DECK,0,1,1,nil,tp)
	local c=g:GetFirst():CheckActivateEffect(true,true,false)
	e:SetLabelObject(c)
	Duel.SendtoGrave(g,REASON_COST)
	e:SetCategory(c:GetCategory())
	e:SetProperty(c:GetProperty())
	local target=c:GetTarget()
	if target then target(e,tp,eg,ep,ev,re,r,rp,1) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,e:GetHandler(),1,0,0)
end
function c11451413.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetLabelObject()
	if not c then return end
	local operation=c:GetOperation()
	if operation then operation(e,tp,eg,ep,ev,re,r,rp) end
	Duel.BreakEffect()
	if Duel.SendtoGrave(e:GetHandler(),REASON_EFFECT)~=0 then
		Duel.SkipPhase(1-tp,PHASE_BATTLE,RESET_PHASE+PHASE_BATTLE_STEP,1)
	end
end
function c11451413.condition2(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_RITUAL)
end
function c11451413.operation2(e,tp,eg,ep,ev,re,r,rp)
	--effect phase end
	local e3=Effect.CreateEffect(e:GetHandler())
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_PHASE+PHASE_END)
	e3:SetCountLimit(1)
	e3:SetCondition(c11451413.condition3)
	e3:SetOperation(c11451413.operation3)
	e3:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e3,tp)
end
function c11451413.condition3(e,tp,eg,ep,ev,re,r,rp)
	local count1=Duel.GetMatchingGroupCount(c11451413.filter2,tp,LOCATION_ONFIELD,0,nil)
	local count2=Duel.GetMatchingGroupCount(nil,tp,0,LOCATION_ONFIELD,nil)
	return count1~=0 and count2~=0
end
function c11451413.operation3(e,tp,eg,ep,ev,re,r,rp)
	local count=Duel.GetMatchingGroupCount(c11451413.filter2,tp,LOCATION_ONFIELD,0,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectMatchingCard(tp,nil,tp,0,LOCATION_ONFIELD,1,count,nil)
	if g:GetCount()>0 then
		Duel.HintSelection(g)
		Duel.Destroy(g,REASON_EFFECT)
	end
end