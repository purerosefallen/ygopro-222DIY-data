--终景见证·承
function c65030071.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,65030071+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c65030071.target)
	e1:SetOperation(c65030071.activate)
	c:RegisterEffect(e1)
end
function c65030071.filter(c,e,tp,spchk)
	return c:IsSetCard(0x6da2) and (c:IsAbleToHand() or (c:IsType(TYPE_MONSTER) and spchk and c:IsCanBeSpecialSummoned(e,0,tp,false,false)))
end
function c65030071.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local spchk=Duel.GetLocationCount(tp,LOCATION_MZONE)>0
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_GRAVE) and c65030071.filter(c,e,tp,spchk) end
	if chk==0 then return Duel.IsExistingTarget(c65030071.filter,tp,LOCATION_GRAVE,0,1,nil,e,tp,spchk) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectTarget(tp,c65030071.filter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp,spchk)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,0,0,0)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,0,tp,LOCATION_GRAVE)
end
function c65030071.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) then
		if tc:IsType(TYPE_MONSTER)
			and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and tc:IsCanBeSpecialSummoned(e,0,tp,false,false)
			and (not tc:IsAbleToHand() or Duel.SelectYesNo(tp,aux.Stringid(65030071,0))) then
			Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_CANNOT_ATTACK)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e1,true)
		else
			Duel.SendtoHand(tc,nil,REASON_EFFECT)
		end
	end
end