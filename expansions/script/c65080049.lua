--寂静蜘蛛
function c65080049.initial_effect(c)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOGRAVE+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP)
	e1:SetCode(EVENT_TO_GRAVE)
	e1:SetCountLimit(1,65080049)
	e1:SetCondition(c65080049.con)
	e1:SetTarget(c65080049.tg)
	e1:SetOperation(c65080049.op)
	c:RegisterEffect(e1)
end
function c65080049.con(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousLocation(LOCATION_ONFIELD)
end
function c65080049.tgfil(c,tp)
	return c:IsPosition(POS_FACEUP_DEFENSE) and Duel.GetMZoneCount(tp,c,tp)>1
end
function c65080049.spfil(c,e,tp)
	local code=c:GetCode()
	return c:IsLevel(4) and c:IsAttribute(ATTRIBUTE_EARTH) and c:IsRace(RACE_INSECT) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.IsExistingMatchingCard(c65080049.spfil2,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil,e,tp,code) and not c:IsCode(65080049)
end
function c65080049.spfil2(c,e,tp,code)
	return c:IsLevel(4) and c:IsAttribute(ATTRIBUTE_EARTH) and c:IsRace(RACE_INSECT) and not c:IsCode(code) and not c:IsCode(65080049)
end
function c65080049.tg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsPosition(POS_FACEUP_DEFENSE) and chkc:IsLocation(LOCATION_MZONE) end
	if chk==0 then return Duel.IsExistingTarget(c65080049.tgfil,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil,tp) and Duel.IsExistingMatchingCard(c65080049.spfil,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil,e,tp)  end
	local g=Duel.SelectTarget(tp,c65080049.tgfil,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil,tp)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,2,tp,LOCATION_HAND+LOCATION_GRAVE)
end
function c65080049.op(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		if Duel.SendtoGrave(tc,REASON_EFFECT)~=0 and Duel.IsExistingMatchingCard(c65080049.spfil,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil,e,tp) and Duel.GetLocationCount(tp,LOCATION_MZONE)>1 then
			local g=Duel.SelectMatchingCard(tp,c65080049.spfil,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,1,nil,e,tp)
			local code=g:GetFirst():GetCode()
			local g2=Duel.SelectMatchingCard(tp,c65080049.spfil2,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,1,nil,e,tp,code)
			g:Merge(g2)
			Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
		end
	end
end