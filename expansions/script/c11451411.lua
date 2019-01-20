--shrimp,patrol of dragon palace
function c11451411.initial_effect(c)
	c:EnableReviveLimit()
	--effect1
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(11451411,0))
	e1:SetCategory(CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,11451401)
	e1:SetCondition(c11451411.condition)
	e1:SetTarget(c11451411.target)
	e1:SetOperation(c11451411.operation)
	c:RegisterEffect(e1)
	--effect2
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(11451411,1))
	e2:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCountLimit(1,11451411)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCondition(c11451411.condition2)
	e2:SetTarget(c11451411.target2)
	e2:SetOperation(c11451411.operation2)
	c:RegisterEffect(e2)
end
function c11451411.mat_filter(c)
	return c:IsAttribute(ATTRIBUTE_WATER)
end
function c11451411.condition(e,tp,eg,ep,ev,re,r,rp)
	return tp~=Duel.GetTurnPlayer() and not e:GetHandler():IsPublic() and Duel.IsExistingMatchingCard(c11451411.filter,tp,LOCATION_DECK,0,1,nil,tp)
end
function c11451411.filter(c,tp)
	return c:IsSetCard(0x6978) and bit.band(c:GetType(),0x82)==0x82 and c:IsAbleToGraveAsCost() and c:CheckActivateEffect(true,true,false)~=nil
end
function c11451411.filter2(c)
	return c:IsSetCard(0x6978) and c:IsAbleToHand()
end
function c11451411.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c11451411.filter,tp,LOCATION_DECK,0,1,1,nil,tp)
	local c=g:GetFirst():CheckActivateEffect(true,true,false)
	e:SetLabelObject(c)
	Duel.SendtoGrave(g,REASON_COST)
	e:SetCategory(c:GetCategory())
	e:SetProperty(c:GetProperty())
	local target=c:GetTarget()
	if target then target(e,tp,eg,ep,ev,re,r,rp,1) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,e:GetHandler(),1,0,0)
end
function c11451411.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetLabelObject()
	if not c then return end
	local operation=c:GetOperation()
	if operation then operation(e,tp,eg,ep,ev,re,r,rp) end
	Duel.BreakEffect()
	Duel.SendtoGrave(e:GetHandler(),REASON_EFFECT)
end
function c11451411.condition2(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_RITUAL)
end
function c11451411.target2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsSetCard,tp,LOCATION_DECK,0,1,nil,0x6978) end
end
function c11451411.operation2(e,tp,eg,ep,ev,re,r,rp)
	--effect phase end
	local e3=Effect.CreateEffect(e:GetHandler())
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_PHASE+PHASE_END)
	e3:SetCountLimit(1)
	e3:SetCondition(c11451411.condition3)
	e3:SetOperation(c11451411.operation3)
	e3:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e3,tp)
end
function c11451411.condition3(e,tp,eg,ep,ev,re,r,rp)
	local count=Duel.GetFieldGroupCount(tp,0,LOCATION_MZONE)
	local g=Duel.GetMatchingGroup(c11451411.filter2,tp,LOCATION_DECK,0,nil)
	return count~=0 and g:GetCount()~=0
end
function c11451411.operation3(e,tp,eg,ep,ev,re,r,rp)
	local count=Duel.GetFieldGroupCount(tp,0,LOCATION_MZONE)
	local g=Duel.GetMatchingGroup(c11451411.filter2,tp,LOCATION_DECK,0,nil)
	local g2=Group.CreateGroup()
	repeat
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g3=g:Select(tp,1,1,nil)
		local c=g3:GetFirst()
		g2:AddCard(c)
		g:Remove(Card.IsCode,nil,c:GetCode())
		count=count-1
	until count==0 or g:GetCount()==0 or not Duel.SelectYesNo(tp,aux.Stringid(11451411,2))
	Duel.SendtoHand(g2,nil,REASON_EFFECT)
	Duel.ConfirmCards(1-tp,g2)
end