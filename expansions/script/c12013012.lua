--火枪手
function c12013012.initial_effect(c)
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(12013012,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_TO_HAND)
	e2:SetCountLimit(1,12013112)
	e2:SetCondition(c12013012.spcon)
	e2:SetTarget(c12013012.sptg)
	e2:SetOperation(c12013012.spop)
	c:RegisterEffect(e2)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(12013012,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_GRAVE)
	e1:SetCountLimit(1,12013012)
	e1:SetCost(c12013012.cost)
	e1:SetTarget(c12013012.target)
	e1:SetOperation(c12013012.operation)
	c:RegisterEffect(e1)   
end
function c12013012.spcon(e,tp,eg,ep,ev,re,r,rp)
	return not e:GetHandler():IsReason(REASON_DRAW)
end
function c12013012.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c12013012.filter1(c,e,tp)
	return c:IsSetCard(0xfb6) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c12013012.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	Duel.BreakEffect()
	if Duel.IsExistingMatchingCard(c12013012.filter1,tp,LOCATION_HAND,0,1,nil,e,tp) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
	   if Duel.SelectYesNo(tp,aux.Stringid(12013012,3)) then
		   local g=Duel.SelectMatchingCard(tp,c12013012.filter1,tp,LOCATION_HAND,0,1,1,nil,e,tp)
			   if g:GetCount()>0 then
					  Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
			   end
	   end
	end
end
function c12013012.cfilter(c)
	return c:IsSetCard(0xfb6) and c:IsAbleToRemoveAsCost() and c:IsType(TYPE_MONSTER)
end
function c12013012.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c12013012.cfilter,tp,LOCATION_GRAVE,0,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c12013012.cfilter,tp,LOCATION_GRAVE,0,1,3,e:GetHandler())
	Duel.Remove(g,POS_FACEUP,REASON_COST)
	if g:GetCount()==3 then
	e:SetLabel(3) end
end
function c12013012.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c12013012.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
	if e:GetLabel()==3 then
	local mg=Duel.GetMatchingGroup(aux.NecroValleyFilter(c12013012.filter2),tp,LOCATION_GRAVE,0,nil)
		if mg:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(12013012,2)) then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
			local sg=mg:Select(tp,1,1,nil)
			Duel.SendtoHand(sg,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,sg)
		end
	end 
end
function c12013012.filter2(c)
	return c:IsSetCard(0xfb6) and c:IsType(TYPE_SPELL) and c:IsAbleToHand()
end
