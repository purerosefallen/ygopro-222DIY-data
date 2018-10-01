--时终间的伫立者
function c65011006.initial_effect(c)
	--tograve
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SEARCH+CATEGORY_TOGRAVE+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_TO_GRAVE)
	e1:SetCountLimit(1,65011006)
	e1:SetCondition(c65011006.thcon)
	e1:SetTarget(c65011006.thtg)
	e1:SetOperation(c65011006.thop)
	c:RegisterEffect(e1)
	--discard
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TODECK+CATEGORY_DRAW)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_HAND)
	e2:SetCountLimit(1,65011006)
	e2:SetCost(c65011006.discost)
	e2:SetTarget(c65011006.distg)
	e2:SetOperation(c65011006.disop)
	c:RegisterEffect(e2)
end
function c65011006.thcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsReason(REASON_EFFECT)
end
function c65011006.thfilter(c)
	return c:IsSetCard(0xda2) and c:IsAbleToGrave()
end
function c65011006.spfilter(c,e,tp)
	return c:IsSetCard(0xda2) and c:IsType(TYPE_MONSTER) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c65011006.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c65011006.thfilter,tp,LOCATION_HAND,0,1,nil) and Duel.IsExistingMatchingCard(c65011006.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_HAND)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c65011006.thop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c65011006.thfilter,tp,LOCATION_HAND,0,1,1,nil)
	if g:GetCount()>0 then
		if Duel.SendtoGrave(g,REASON_EFFECT)~=0 then
			local sg=Duel.SelectMatchingCard(tp,c65011006.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
			if sg:GetCount()>0 then
				Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
			end
		end
	end
end

function c65011006.discost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsDiscardable() end
	Duel.SendtoGrave(e:GetHandler(),REASON_COST+REASON_DISCARD)
end
function c65011006.disfilter(c,e,tp)
	return c:IsSetCard(0xda2) and c:IsAbleToDeck()
end
function c65011006.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c65011006.disfilter,tp,LOCATION_GRAVE,0,3,nil) and Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,3,tp,LOCATION_GRAVE)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c65011006.disop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,c65011006.disfilter,tp,LOCATION_GRAVE,0,3,3,nil,e,tp)
	if g:GetCount()>0 then
		Duel.HintSelection(g)
		Duel.SendtoDeck(g,nil,2,REASON_EFFECT)
		Duel.ShuffleDeck(tp)
		Duel.Draw(tp,1,REASON_EFFECT)
	end
end