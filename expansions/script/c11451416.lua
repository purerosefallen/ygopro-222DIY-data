--waking of dragon palace
function c11451416.initial_effect(c)
	--Activate
	local e1=aux.AddRitualProcGreater2(c,nil,nil,nil,c11451416.matfilter)
	e1:SetDescription(aux.Stringid(11451416,0))
	--effect2
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(11451416,1))
	e2:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,11451416)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e2:SetCondition(c11451416.condition)
	e2:SetCost(c11451416.cost)
	e2:SetTarget(c11451416.target)
	e2:SetOperation(c11451416.operation)
	c:RegisterEffect(e2)
end
function c11451416.matfilter(c)
	return c:IsAttribute(ATTRIBUTE_WATER)
end
function c11451416.filter(c)
	return c:IsPreviousSetCard(0x6978) and c:IsPreviousLocation(LOCATION_MZONE) and c:IsSummonType(SUMMON_TYPE_RITUAL)
end
function c11451416.filter1(c)
	return bit.band(c:GetType(),0x82)==0x82 and c:IsAbleToHand()
end
function c11451416.filter2(c)
	return c:IsSetCard(0x6978) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c11451416.condition(e,tp,eg,ep,ev,re,r,rp)
	return rp~=tp and eg:IsExists(c11451416.filter,1,nil)
end
function c11451416.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToDeckAsCost() end
	Duel.SendtoDeck(e:GetHandler(),nil,2,REASON_COST)
end
function c11451416.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c11451416.filter1,tp,LOCATION_DECK,0,1,nil)
		and Duel.IsExistingMatchingCard(c11451416.filter2,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,2,tp,LOCATION_DECK)
end
function c11451416.operation(e,tp,eg,ep,ev,re,r,rp)
	local g1=Duel.GetMatchingGroup(c11451416.filter1,tp,LOCATION_DECK,0,nil)
	local g2=Duel.GetMatchingGroup(c11451416.filter2,tp,LOCATION_DECK,0,nil)
	if g1:GetCount()>0 and g2:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g3=g1:Select(tp,1,1,nil)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g4=g2:Select(tp,1,1,nil)
		g3:Merge(g4)
		Duel.SendtoHand(g3,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g3)
	end
end