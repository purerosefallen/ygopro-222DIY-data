--钢铁天使-源生之翼
function c10173097.initial_effect(c)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e1:SetDescription(aux.Stringid(10173097,0))
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetCountLimit(1,10173097)
	e1:SetRange(LOCATION_MZONE+LOCATION_HAND)
	e1:SetCost(c10173097.cost)
	e1:SetTarget(c10173097.target)
	e1:SetOperation(c10173097.operation)
	c:RegisterEffect(e1)	
end
function c10173097.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsReleasable() end
	Duel.Release(e:GetHandler(),REASON_COST)
end
function c10173097.filter(c)
	return c:IsCode(10173081,10173074) and c:IsAbleToHand()
end
function c10173097.filter1(c)
	return c:IsSummonType(SUMMON_TYPE_SPECIAL) and c:GetSummonLocation()==LOCATION_EXTRA 
end

function c10173097.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c10173097.filter,tp,LOCATION_DECK,0,1,nil) end
	if Duel.IsExistingMatchingCard(c10173097.cfilter1,tp,0,LOCATION_MZONE,3,nil) or Duel.IsExistingMatchingCard(Card.IsType,tp,0,LOCATION_ONFIELD,3,nil,TYPE_SPELL+TYPE_TRAP) then
	   e:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_NEGATE)
	else
	   e:SetProperty(0)
	end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c10173097.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c10173097.filter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
