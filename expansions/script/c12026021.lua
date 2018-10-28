--然而我也是异色的双瞳 拉结尔
function c12026021.initial_effect(c)
	--draw
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(12026021,0))
	e1:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCountLimit(1,12026021)
	e1:SetTarget(c12026021.drtg)
	e1:SetOperation(c12026021.drop)
	c:RegisterEffect(e1)

	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(12026021,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_HAND)
	e2:SetCountLimit(1,12026121)
	e2:SetCost(c12026021.cost)
	e2:SetTarget(c12026021.sptg1)
	e2:SetOperation(c12026021.spop1)
	c:RegisterEffect(e2)
end
function c12026021.describe_with_Raphael(c)
	local m=_G["c"..c:GetCode()]
	return m and m.lighting_with_Raphael
end
function c12026021.filter1(c)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x1fbd)
end
function c12026021.filter2(c)
	return c12026021.describe_with_Raphael(c) and c:IsType(TYPE_SPELL)
end
function c12026021.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	 if chk==0 then return Duel.IsExistingMatchingCard(c12026021.filter1,tp,LOCATION_DECK,0,1,nil) end
	 Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c12026021.drop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler() 
	local g1=Duel.GetMatchingGroup(c12026021.filter1,tp,LOCATION_DECK,0,nil)
	if Duel.IsExistingMatchingCard(Card.IsSetCard,tp,LOCATION_MZONE,0,1,c,0x1fbd) then 
	local g2=Duel.GetMatchingGroup(c12026021.filter2,tp,LOCATION_DECK,0,nil)
	g1:Merge(g2)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=g1:Select(tp,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c12026021.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsDiscardable() end
	Duel.SendtoGrave(e:GetHandler(),REASON_COST+REASON_DISCARD)
end
function c12026021.spfilter1(c,e,tp)
	return c:IsSetCard(0x1fbd) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c12026021.sptg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return chkc~=e:GetHandler() and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c12026021.spfilter1,tp,LOCATION_HAND,0,1,e:GetHandler(),e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
end
function c12026021.spop1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c12026021.spfilter1,tp,LOCATION_HAND,0,1,1,e:GetHandler(),e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
	local e12=Effect.CreateEffect(c)
	e12:SetType(EFFECT_TYPE_SINGLE)
	e12:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e12:SetCode(EFFECT_ADD_SETCODE)
	e12:SetRange(LOCATION_MZONE)
	e12:SetReset(RESET_EVENT+0x1fe0000)
	e12:SetValue(0xfbb)
	g:GetFirst():RegisterEffect(e12)
	Duel.BreakEffect()
	if Duel.IsExistingMatchingCard(c12026021.ckfilter,tp,LOCATION_MZONE,0,1,nil) then
		local fg=Duel.GetMatchingGroup(aux.NecroValleyFilter(c12026021.ffilter),tp,LOCATION_GRAVE,LOCATION_GRAVE,nil)
			if fg:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(12026021,2)) then
				  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
				local sg=fg:Select(tp,1,1,nil)
				Duel.SSet(tp,sg)
				Duel.ConfirmCards(1-tp,sg)
			end
	end
end
function c12026021.ffilter(c)
	return c12026021.describe_with_Raphael(c) and c:IsType(TYPE_SPELL)
end
function c12026021.ckfilter(c,tp)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x1fbd)
		and Duel.IsExistingMatchingCard(Card.IsSetCard,tp,LOCATION_MZONE,0,1,c,0xfbb)
end