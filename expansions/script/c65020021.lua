--外身心 吞食
function c65020021.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_TO_GRAVE)
	e1:SetCondition(c65020021.spcon)
	e1:SetTarget(c65020021.sptg)
	e1:SetOperation(c65020021.spop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_REMOVE)
	c:RegisterEffect(e2)
end
function c65020021.spcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsPreviousLocation(LOCATION_ONFIELD) and c:IsPreviousPosition(POS_FACEDOWN)
end
function c65020021.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local b1=c:GetReasonPlayer()==tp
	local b2=c:GetReasonPlayer()==1-tp
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local op=0
	if b2 then op=1 end
	e:SetLabel(op)
	if chk==0 then return (Duel.IsExistingMatchingCard(Card.IsCode,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE,0,1,nil,65020025) or Duel.IsExistingMatchingCard(Card.IsCode,tp,LOCATION_FZONE,0,1,nil,65020025)) and ((b1 and Duel.GetFlagEffect(tp,65020021)==0 and Duel.GetMatchingGroupCount(Card.IsAbleToRemove,tp,0,LOCATION_HAND,nil)>0 and Duel.GetMatchingGroupCount(Card.IsAbleToRemove,tp,0,LOCATION_GRAVE,nil)>0) or (b2 and Duel.GetMatchingGroupCount(Card.IsAbleToRemove,tp,0,LOCATION_HAND+LOCATION_GRAVE,nil)>0)) end
	if b1 then
		Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,1-tp,LOCATION_HAND)
		Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,1-tp,LOCATION_GRAVE)
	elseif b2 then
		Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,1-tp,LOCATION_HAND+LOCATION_GRAVE)
	end
end
function c65020021.spop(e,tp,eg,ep,ev,re,r,rp)
	local op=e:GetLabel()
	if op==0 then
		local g1=Duel.SelectMatchingCard(1-tp,Card.IsAbleToRemove,tp,0,LOCATION_HAND,1,1,nil)
		local g3=Duel.SelectMatchingCard(1-tp,Card.IsAbleToRemove,tp,0,LOCATION_GRAVE,1,1,nil)
		if g1:GetCount()>0 and g3:GetCount()>0 then
			g1:Merge(g3)
			Duel.HintSelection(g1)
			Duel.Remove(g1,POS_FACEUP,REASON_EFFECT)
		end
		Duel.RegisterFlagEffect(tp,65020021,RESET_PHASE+PHASE_END,0,1)
	elseif op==1 then
		local g22=Duel.GetFieldGroup(tp,0,LOCATION_HAND+LOCATION_GRAVE)
		Duel.ConfirmCards(tp,g22)
		local g2=g22:FilterSelect(tp,Card.IsAbleToRemove,1,2,nil)
		if g2:GetCount()>0 then
			Duel.HintSelection(g2)
			Duel.Remove(g2,POS_FACEDOWN,REASON_EFFECT)
		end
	end
	if Duel.GetMatchingGroupCount(Card.IsCode,tp,LOCATION_FZONE,0,1,nil,65020025)==0 and Duel.IsExistingMatchingCard(Card.IsCode,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE,0,1,nil,65020025) then
		local tc=Duel.SelectMatchingCard(Card.IsCode,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil,65020025):GetFirst()
		Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
	end
end