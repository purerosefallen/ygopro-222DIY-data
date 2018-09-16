--外身心 增殖
function c65020019.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_TO_GRAVE)
	e1:SetCondition(c65020019.spcon)
	e1:SetTarget(c65020019.sptg)
	e1:SetOperation(c65020019.spop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_REMOVE)
	c:RegisterEffect(e2)
end
function c65020019.spcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsPreviousLocation(LOCATION_ONFIELD) and c:IsPreviousPosition(POS_FACEDOWN)
end
function c65020019.spfil(c,e,tp)
	return c:IsSetCard(0x3da5) and c:IsType(TYPE_MONSTER) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c65020019.spfil2(c,e,tp)
	return c:IsSetCard(0xda5) and c:IsType(TYPE_MONSTER) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c65020019.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local b1=c:GetReasonPlayer()==tp
	local b2=c:GetReasonPlayer()==1-tp
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local op=0
	if b2 then op=1 end
	e:SetLabel(op)
	if chk==0 then return (Duel.IsExistingMatchingCard(Card.IsCode,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE,0,1,nil,65020025) or Duel.IsExistingMatchingCard(Card.IsCode,tp,LOCATION_FZONE,0,1,nil,65020025)) and ft>0 and ((b1 and Duel.GetFlagEffect(tp,65020019)==0 and Duel.IsExistingMatchingCard(c65020019.spfil,tp,LOCATION_HAND+LOCATION_DECK,0,1,nil,e,tp)) or (b2 and Duel.IsExistingMatchingCard(c65020019.spfil2,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE,0,1,nil,e,tp))) end
	if b1 then
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_DECK)
	elseif b2 then
		e:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_DRAW)
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE)
		Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,2)
	end
end
function c65020019.spop(e,tp,eg,ep,ev,re,r,rp)
	local op=e:GetLabel()
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if op==0 then
		if ft>0 then
		local g1=Duel.SelectMatchingCard(tp,c65020019.spfil,tp,LOCATION_HAND+LOCATION_DECK,0,1,1,nil,e,tp)
		if g1:GetCount()>0 then
			Duel.SpecialSummon(g1,0,tp,tp,false,false,POS_FACEUP)
		end
		end
		Duel.RegisterFlagEffect(tp,65020019,RESET_PHASE+PHASE_END,0,1)
	elseif op==1 then
		if ft>0 then
		local g2=Duel.SelectMatchingCard(tp,c65020019.spfil2,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil,e,tp)
		if g2:GetCount()>0 then
			if Duel.SpecialSummon(g2,0,tp,tp,false,false,POS_FACEUP)~=0 and Duel.IsPlayerCanDraw(tp,2) and Duel.SelectYesNo(tp,aux.Stringid(65020019,0)) then
				Duel.BreakEffect()
				Duel.Draw(tp,2,REASON_EFFECT)
			end
		end
		end
	end
	if Duel.GetMatchingGroupCount(Card.IsCode,tp,LOCATION_FZONE,0,1,nil,65020025)==0 and Duel.IsExistingMatchingCard(Card.IsCode,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE,0,1,nil,65020025) then
		local tc=Duel.SelectMatchingCard(Card.IsCode,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil,65020025):GetFirst()
		Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
	end
end