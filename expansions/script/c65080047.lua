--秘咒蜘蛛
function c65080047.initial_effect(c)
	--tograve
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_POSITION+CATEGORY_SEARCH+CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1,65080053)
	e1:SetTarget(c65080047.target)
	e1:SetOperation(c65080047.operation)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2)
	--spsummon
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_HAND+LOCATION_GRAVE)
	e3:SetCountLimit(1,65080047)
	e3:SetCondition(c65080047.con)
	e3:SetTarget(c65080047.tg)
	e3:SetOperation(c65080047.op)
	c:RegisterEffect(e3)
end
function c65080047.thfil(c)
	return c:IsLevel(4) and c:IsAttribute(ATTRIBUTE_EARTH) and c:IsRace(RACE_INSECT) and c:IsAbleToHand()
end
function c65080047.changefil(c)
	return c:IsAttackPos() and c:IsCanChangePosition()
end
function c65080047.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return c65080047.changefil(chkc) and chkc:IsControler(1-tp) and chkc:IsLocation(LOCATION_MZONE) end
	if chk==0 then return Duel.IsExistingTarget(c65080047.changefil,tp,0,LOCATION_MZONE,1,nil) and Duel.IsExistingMatchingCard(c65080047.thfil,tp,LOCATION_DECK,0,1,nil) end
	local g=Duel.SelectTarget(tp,Card.IsAttackPos,tp,0,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_POSITION,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c65080047.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsAttackPos() and tc:IsCanChangePosition() then
		if Duel.ChangePosition(tc,POS_FACEUP_DEFENSE)~=0 and Duel.IsExistingMatchingCard(c65080047.thfil,tp,LOCATION_DECK,0,1,nil) then
			local g=Duel.SelectMatchingCard(tp,c65080047.thfil,tp,LOCATION_DECK,0,1,1,nil)
			Duel.SendtoHand(g,tp,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g)
		end
	end
end

function c65080047.con(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(Card.IsPosition,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil,POS_FACEUP_DEFENSE)
end
function c65080047.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,tp,0)
end
function c65080047.op(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and e:GetHandler():IsRelateToEffect(e) then
		Duel.SpecialSummon(e:GetHandler(),0,tp,tp,false,false,POS_FACEUP)
	end
end