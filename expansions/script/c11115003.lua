--御龙的空域
function c11115003.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--extra summon
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_FZONE)
	e2:SetCode(EFFECT_EXTRA_SUMMON_COUNT)
	e2:SetTargetRange(LOCATION_HAND+LOCATION_MZONE,0)
	e2:SetTarget(c11115003.extg)
	c:RegisterEffect(e2)
	--spsummon
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(11115003,0))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOHAND)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_TO_GRAVE)
	e3:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e3:SetCountLimit(1,11115003)
	e3:SetCondition(c11115003.spcon)
	e3:SetTarget(c11115003.sptg)
	e3:SetOperation(c11115003.spop)
	c:RegisterEffect(e3)
end
function c11115003.thfilter(c)
	return c:IsSetCard(0x15e) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c11115003.activate(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local g=Duel.GetMatchingGroup(c11115003.thfilter,tp,LOCATION_DECK,0,nil)
	if g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(11115003,0)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local sg=g:Select(tp,1,1,nil)
		Duel.SendtoHand(sg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,sg)
	end
end
function c11115003.extg(e,c)
	return c:IsType(TYPE_TUNER) and c:IsSetCard(0x115e)
end
function c11115003.spcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsReason(REASON_EFFECT) and c:IsPreviousLocation(LOCATION_FZONE)
end
function c11115003.spfilter(c,e,tp,ft)
	return ((c:IsSetCard(0x115e) and c:IsType(TYPE_TUNER)) or (c:IsSetCard(0x215e) and not c:IsType(TYPE_SYNCHRO))) 
	    and (c:IsAbleToHand() or (ft>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false)))
end
function c11115003.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_GRAVE) and c11115003.spfilter(chkc,e,tp,ft) end
	if chk==0 then return Duel.IsExistingTarget(c11115003.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp,ft) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c11115003.spfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp,ft)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function c11115003.spop(e,tp,eg,ep,ev,re,r,rp)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and ft>0 and tc:IsCanBeSpecialSummoned(e,0,tp,false,false)
       and (not tc:IsAbleToHand() or Duel.SelectYesNo(tp,aux.Stringid(11115003,1))) then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	else
	    Duel.SendtoHand(tc,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tc)
	end
end