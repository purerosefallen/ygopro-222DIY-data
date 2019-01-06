--蜘蛛骚动
function c65080052.initial_effect(c)
	--act
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e0)
	--pos
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(65080052,1))
	e1:SetCategory(CATEGORY_POSITION+CATEGORY_SEARCH+CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_SZONE)
	e1:SetCountLimit(1,65080052)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetTarget(c65080052.target)
	e1:SetOperation(c65080052.operation)
	c:RegisterEffect(e1)
	--tograve
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(65080052,2))
	e2:SetCategory(CATEGORY_TOGRAVE+CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1,65080052)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetTarget(c65080052.target2)
	e2:SetOperation(c65080052.operation2)
	c:RegisterEffect(e2)
end
function c65080052.thfilter(c)
	return ((c:IsLevel(4) and c:IsAttribute(ATTRIBUTE_EARTH)) or (c:IsType(TYPE_TUNER) and c:IsAttribute(ATTRIBUTE_DARK))) and c:IsRace(RACE_INSECT) and c:IsAbleToHand()
end
function c65080052.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsAttackPos() and chkc:IsLocation(LOCATION_MZONE) end
	if chk==0 then return Duel.IsExistingTarget(Card.IsAttackPos,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) and Duel.IsExistingMatchingCard(c65080052.thfilter,tp,LOCATION_DECK,0,1,nil) end
	local g=Duel.SelectTarget(tp,Card.IsAttackPos,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_POSITION,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c65080052.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsAttackPos() and Duel.ChangePosition(tc,POS_FACEUP_DEFENSE)~=0 then
		local g=Duel.SelectMatchingCard(tp,c65080052.thfilter,tp,LOCATION_DECK,0,1,1,nil)
		if g:GetCount()>0 then
			Duel.SendtoHand(g,tp,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g)
		end
	end
end

function c65080052.spfilter(c,e,tp)
	return c:IsLevel(4) and c:IsAttribute(ATTRIBUTE_EARTH) and c:IsRace(RACE_INSECT) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_DEFENSE)
end
function c65080052.spfilter2(c,e,tp,code)
	return c:IsLevel(4) and c:IsAttribute(ATTRIBUTE_EARTH) and c:IsRace(RACE_INSECT) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_DEFENSE) and not c:IsCode(code)
end
function c65080052.tgfil(c,tp)
	return c:IsPosition(POS_FACEUP_DEFENSE) and Duel.GetMZoneCount(tp,c,tp)>0
end
function c65080052.target2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsPosition(POS_FACEUP_DEFENSE) and chkc:IsLocation(LOCATION_MZONE) end
	if chk==0 then return Duel.IsExistingTarget(c65080052.tgfil,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil,tp) and Duel.IsExistingMatchingCard(c65080052.spfilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil,e,tp) end
	local g=Duel.SelectTarget(tp,c65080052.tgfil,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil,tp)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_GRAVE)
end
function c65080052.operation2(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.SendtoGrave(tc,REASON_EFFECT)~=0  and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
		local g=Duel.SelectMatchingCard(tp,c65080052.spfilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,1,nil,e,tp)
		local tc=g:GetFirst()
		if tc then
			local code=tc:GetCode()
			if Duel.GetLocationCount(tp,LOCATION_MZONE)>1 and Duel.IsExistingMatchingCard(c65080052.spfilter2,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil,e,tp,code) and Duel.SelectYesNo(tp,aux.Stringid(65080052,0)) then
				local g2=Duel.SelectMatchingCard(tp,c65080052.spfilter2,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,1,nil,e,tp,code)
				g:Merge(g2)
			end
			Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP_DEFENSE)
		end
	end
end