--忍妖 粉雪
function c12017000.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(12017000,0))
	e1:SetCategory(CATEGORY_HANDES+CATEGORY_REMOVE+CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_GRAVE+LOCATION_HAND)
	e1:SetCost(c12017000.discost)
	e1:SetTarget(c12017000.distg)
	e1:SetOperation(c12017000.disop)
	c:RegisterEffect(e1)
	--search
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(12017000,3))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_REMOVE)
	e2:SetRange(LOCATION_REMOVED)
	e2:SetCondition(c12017000.thcon)
	e2:SetTarget(c12017000.thtg)
	e2:SetOperation(c12017000.thop)
	c:RegisterEffect(e2)  
end
function c12017000.discost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,2,e:GetHandler()) or (Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)==0 and Duel.GetFlagEffect(tp,12017000)==0 ) and e:GetHandler():IsAbleToRemoveAsCost() end
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
	if Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)==0 then Duel.RegisterFlagEffect(tp,12017000,RESET_EVENT+RESET_PHASE+PHASE_END,0,1)
	else
	Duel.DiscardHand(tp,Card.IsDiscardable,2,2,REASON_COST+REASON_DISCARD)
	end
end
function c12017000.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,nil) end
	local g=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,LOCATION_GRAVE,LOCATION_GRAVE,nil)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,g,1,0,0)
end
function c12017000.disop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,Card.IsAbleToRemove,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,1,nil)
	if g:GetCount()>0 then
		Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local rg=Duel.SelectMatchingCard(tp,Card.IsAbleToGrave,tp,LOCATION_REMOVED,LOCATION_REMOVED,1,1,nil)
	if rg:GetCount()>0 then
		Duel.SendtoGrave(rg,REASON_EFFECT)
	end
end
function c12017000.cfilter(c,tp)
	return c:GetPreviousControler()==tp
		and c:IsSetCard(0xfb4)  
end
function c12017000.cfilter1(c,tp)
	return c:IsAttribute(ATTRIBUTE_DARK) and c:IsAbleToHand()
end
function c12017000.thcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c12017000.cfilter,1,nil,tp) and Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)==0  and not re:GetHandler():IsCode(12017000)
end
function c12017000.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local b1=(c:IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.GetFlagEffect(tp,12017000+100)==0 )
	local b2=(c:IsAbleToGrave() and Duel.IsExistingMatchingCard(c12017000.cfilter1,tp,LOCATION_GRAVE,0,1,nil)
		and Duel.GetFlagEffect(tp,12017000+200)==0 )
	if chk==0 then return b1 or b2 end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
	local g=Duel.GetMatchingGroup(c12017000.cfilter1,tp,LOCATION_GRAVE,0,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function c12017000.thop(e,tp,eg,ep,ev,re,r,rp)
   local c=e:GetHandler()
	local b1=(c:IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.GetFlagEffect(tp,12017000+100)==0 )
	local b2=(c:IsAbleToGrave() and Duel.IsExistingMatchingCard(c12017000.cfilter1,tp,LOCATION_GRAVE,0,1,nil)
		and Duel.GetFlagEffect(tp,12017000+200)==0 )
	local op=0
	if b1 and b2 then op=Duel.SelectOption(tp,aux.Stringid(12017000,1),aux.Stringid(12017000,2))
	elseif b1 then op=Duel.SelectOption(tp,aux.Stringid(12017000,1))
	elseif b2 then op=Duel.SelectOption(tp,aux.Stringid(12017000,2))+1
	else return end
	if op==0 then
		if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
		end
		Duel.RegisterFlagEffect(tp,12017000+100,RESET_PHASE+PHASE_END,0,1)
	else
		if not c:IsRelateToEffect(e) then return end
		if Duel.SendtoGrave(c,REASON_EFFECT)>=0 and Duel.IsExistingMatchingCard(c12017000.cfilter1,tp,LOCATION_GRAVE,0,1,nil) 
		then
		 Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local cg=Duel.SelectMatchingCard(tp,c12017000.cfilter1,tp,LOCATION_GRAVE,0,1,1,nil)
		if cg:GetCount()>0 then
		Duel.SendtoHand(cg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,cg)
		end
		Duel.RegisterFlagEffect(tp,12017000+200,RESET_PHASE+PHASE_END,0,1)
		end
	end
end