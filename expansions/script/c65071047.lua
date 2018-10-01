--别碰我
function c65071047.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_TO_GRAVE)
	e1:SetCondition(c65071047.spcon)
	e1:SetOperation(c65071047.spop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_REMOVE)
	c:RegisterEffect(e2)
end
function c65071047.spcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsReason(REASON_EFFECT) and rp~=tp and c:GetPreviousControler()==tp
		and c:IsPreviousLocation(LOCATION_ONFIELD) and c:IsPreviousPosition(POS_FACEDOWN)
end

function c65071047.spop(e,tp,eg,ep,ev,re,r,rp)
	local t1=Duel.IsExistingMatchingCard(aux.TRUE,tp,0,LOCATION_ONFIELD,1,nil)
	local t2=Duel.IsExistingMatchingCard(Card.IsCanBeSpecialSummoned,tp,LOCATION_DECK,0,1,nil,e,0,tp,false,false) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 
	local op=2
	if t1 and t2 then
		op=Duel.SelectOption(1-tp,aux.Stringid(93445075,0),aux.Stringid(93445075,1))
	elseif t1 then op=Duel.SelectOption(1-tp,aux.Stringid(93445075,0))
	elseif t2 then op=Duel.SelectOption(tp,aux.Stringid(93445075,1))
	else return end
	if op==0 then
		local g=Duel.GetFieldGroup(tp,0,LOCATION_ONFIELD)
		Duel.SendtoGrave(g,REASON_EFFECT)
	elseif op==1 then
		local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
		local g2=Duel.SelectMatchingCard(tp,Card.IsCanBeSpecialSummoned,tp,LOCATION_DECK,0,1,ft,nil,e,0,tp,false,false)
		if g2:GetCount()>0 then
			Duel.SpecialSummon(g2,0,tp,tp,false,false,POS_FACEUP)
		end
	end
end