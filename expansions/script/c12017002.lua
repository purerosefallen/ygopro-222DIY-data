--忍妖 玉雪
function c12017002.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(12017002,0))
	e1:SetCategory(CATEGORY_HANDES+CATEGORY_REMOVE+CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_GRAVE+LOCATION_HAND)
	e1:SetCost(c12017002.discost)
	e1:SetTarget(c12017002.distg)
	e1:SetOperation(c12017002.disop)
	c:RegisterEffect(e1)
	--search
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(12017002,3))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_REMOVE)
	e2:SetRange(LOCATION_REMOVED)
	e2:SetCondition(c12017002.thcon)
	e2:SetTarget(c12017002.thtg)
	e2:SetOperation(c12017002.thop)
	c:RegisterEffect(e2)  
end
function c12017002.discost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,2,nil) or (Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)==0 and Duel.GetFlagEffect(tp,12017002)==0 ) and e:GetHandler():IsAbleToRemoveAsCost() end
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
	if Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)==0 then Duel.RegisterFlagEffect(tp,12017002,RESET_EVENT+RESET_PHASE+PHASE_END,0,1)
	else
	Duel.DiscardHand(tp,Card.IsDiscardable,2,2,REASON_COST+REASON_DISCARD)
	end
end
function c12017002.tgfilter(c)
	return c:IsRace(RACE_ZOMBIE) and c:IsAbleToGrave()
end
function c12017002.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c12017002.tgfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
end
function c12017002.disop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c12017002.tgfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoGrave(g,REASON_EFFECT)
	end
end
function c12017002.cfilter(c,tp)
	return c:GetPreviousControler()==tp
		and c:IsSetCard(0xfb4)  
end
function c12017002.filter1(c,e,tp)
	return c:IsRace(RACE_ZOMBIE) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c12017002.filter2(c,tp)
	return c:IsRace(RACE_ZOMBIE) and c:IsAbleToHand()
end
function c12017002.thcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c12017002.cfilter,1,nil,tp) and Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)==0  and not re:GetHandler():IsCode(12017002)
end
function c12017002.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local b1=(Duel.GetFlagEffect(tp,12017002+100)==0 and c:IsAbleToDeck() and Duel.IsExistingMatchingCard(c12017002.filter1,tp,LOCATION_REMOVED,0,1,c,e,tp) and Duel.GetMZoneCount(tp)>0)
	local b2=(c:IsAbleToGrave() 
		and Duel.IsExistingMatchingCard(c12017002.cfilter2,tp,LOCATION_REMOVED,0,1,c) and Duel.GetFlagEffect(tp,12017002+200)==0) 
	if chk==0 then return b1 or b2 end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,c,1,0,0)
	local g=Duel.GetMatchingGroup(c12017002.filter2,tp,LOCATION_REMOVED,0,c)
	local g1=Duel.GetMatchingGroup(c12017002.filter1,tp,LOCATION_REMOVED,0,c,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g1,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function c12017002.thop(e,tp,eg,ep,ev,re,r,rp)
  local c=e:GetHandler()
	local b1=(Duel.GetFlagEffect(tp,12017002+100)==0 and c:IsAbleToDeck() and Duel.IsExistingMatchingCard(c12017002.filter1,tp,LOCATION_REMOVED,0,1,c,e,tp) and Duel.GetMZoneCount(tp)>0)
	local b2=(c:IsAbleToGrave() 
		and Duel.IsExistingMatchingCard(c12017002.cfilter2,tp,LOCATION_REMOVED,0,1,c) and Duel.GetFlagEffect(tp,12017002+200)==0) 
	local op=0
	if b1 and b2 then op=Duel.SelectOption(tp,aux.Stringid(12017002,1),aux.Stringid(12017002,2))
	elseif b1 then op=Duel.SelectOption(tp,aux.Stringid(12017002,1))
	elseif b2 then op=Duel.SelectOption(tp,aux.Stringid(12017002,2))+1
	else return end
	if op==0 then
		if c:IsRelateToEffect(e) then
		if Duel.SendtoDeck(c,nil,2,REASON_EFFECT)>=0  and Duel.GetMZoneCount(tp)>=0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,c12017002.filter1,tp,LOCATION_REMOVED,0,1,1,nil,e,tp)
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
		end
		end
		Duel.RegisterFlagEffect(tp,12017002+100,RESET_PHASE+PHASE_END,0,1)
	else
		if c:IsRelateToEffect(e) then
		if Duel.SendtoGrave(c,REASON_EFFECT)>=0  and Duel.GetMZoneCount(tp)>=0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,c12017002.filter2,tp,LOCATION_REMOVED,0,1,1,nil,e,tp)
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
		end
		end
	end
end