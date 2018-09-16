--外身心 群噬
function c65020022.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_REMOVE+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_TO_GRAVE)
	e1:SetCondition(c65020022.spcon)
	e1:SetTarget(c65020022.sptg)
	e1:SetOperation(c65020022.spop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_REMOVE)
	c:RegisterEffect(e2)
end
function c65020022.spcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsPreviousLocation(LOCATION_ONFIELD) and c:IsPreviousPosition(POS_FACEDOWN)
end
function c65020022.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local b1=c:GetReasonPlayer()==tp
	local b2=c:GetReasonPlayer()==1-tp
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local op=0
	if b2 then op=1 end
	e:SetLabel(op)
	if chk==0 then return (Duel.IsExistingMatchingCard(Card.IsCode,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE,0,1,nil,65020025) or Duel.IsExistingMatchingCard(Card.IsCode,tp,LOCATION_FZONE,0,1,nil,65020025)) and Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,0,LOCATION_EXTRA,1,nil) and ((b1 and Duel.GetFlagEffect(tp,65020022)==0) or b2) end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,1-tp,LOCATION_ONFIELD)
end
function c65020022.spop(e,tp,eg,ep,ev,re,r,rp)
	local op=e:GetLabel()
	if op==0 then
		local g1=Duel.SelectMatchingCard(1-tp,Card.IsAbleToRemove,tp,0,LOCATION_EXTRA,1,1,nil)
		if g1:GetCount()>0 then
			Duel.HintSelection(g1)
			Duel.Remove(g1,POS_FACEDOWN,REASON_EFFECT)
		end
		Duel.RegisterFlagEffect(tp,65020022,RESET_PHASE+PHASE_END,0,1)
	elseif op==1 then
		local g22=Duel.GetFieldGroup(tp,0,LOCATION_EXTRA)
		Duel.ConfirmCards(tp,g22)
		local g2=g22:FilterSelect(tp,Card.IsAbleToRemove,1,2,nil)
		if g2:GetCount()>0 then
			Duel.HintSelection(g2)
			if Duel.Remove(g2,POS_FACEDOWN,REASON_EFFECT)~=0 and Duel.GetLocationCountFromEx(tp)>0 and Duel.IsExistingMatchingCard(Card.IsCanBeSpecialSummoned,tp,0,LOCATION_EXTRA,1,nil,e,0,tp,true,false) and Duel.SelectYesNo(tp,aux.Stringid(65020022,0)) then
				local g4=Duel.SelectMatchingCard(tp,Card.IsCanBeSpecialSummoned,tp,0,LOCATION_EXTRA,1,1,nil,e,0,tp,true,false)
				Duel.SpecialSummon(g4,0,tp,tp,true,false,POS_FACEUP)
			end
		end
	end
	if Duel.GetMatchingGroupCount(Card.IsCode,tp,LOCATION_FZONE,0,1,nil,65020025)==0 and Duel.IsExistingMatchingCard(Card.IsCode,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE,0,1,nil,65020025) then
		local tc=Duel.SelectMatchingCard(Card.IsCode,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil,65020025):GetFirst()
		Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
	end
end

