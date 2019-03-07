--逐火之蛾的归宿
function c75646312.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_DESTROYED)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1,75646312+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c75646312.thtg)
	e1:SetOperation(c75646312.thop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCategory(CATEGORY_TOGRAVE)
	e2:SetCode(EVENT_CHAINING)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCondition(c75646312.con)
	e2:SetTarget(c75646312.tg)
	e2:SetOperation(c75646312.op)
	c:RegisterEffect(e2)
	c75646312.act_effect=e2
end
function c75646312.thfilter1(c,e,tp,rp)
	local cod=c:GetCode()
	return (c:IsReason(REASON_BATTLE) or (rp==1-tp and c:IsReason(REASON_EFFECT)))
		and c:IsPreviousSetCard(0x62c1) and c:IsType(TYPE_MONSTER)
		and c:IsPreviousLocation(LOCATION_MZONE) and c:GetPreviousControler()==tp
		and c:IsLocation(LOCATION_GRAVE+LOCATION_REMOVED) and c:IsCanBeEffectTarget(e)
		and Duel.IsExistingMatchingCard(c75646312.thfilter2,tp,LOCATION_DECK,0,1,nil,cod)
end
function c75646312.thfilter2(c,cod)
	return not c:IsCode(cod) and c:IsSetCard(0x62c1) 
		and c:IsAbleToHand() and c:IsType(TYPE_MONSTER)
end
function c75646312.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return eg:IsContains(chkc) and c75646312.thfilter1(chkc,e,tp,rp) end
	if chk==0 then return eg:IsExists(c75646312.thfilter1,1,nil,e,tp,rp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=eg:FilterSelect(tp,c75646312.thfilter1,1,1,nil,e,tp,rp)
	Duel.SetTargetCard(g)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND+CATEGORY_SEARCH,nil,1,tp,LOCATION_DECK)
end
function c75646312.thop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if not tc:IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c75646312.thfilter2,tp,LOCATION_DECK,0,1,1,nil,tc:GetCode())
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c75646312.con(e,tp,eg,ep,ev,re,r,rp)
	return re:GetHandler():IsSetCard(0x62c1) and re:IsHasCategory(CATEGORY_TOHAND)
end
function c75646312.tg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local exc=nil
	if e:IsHasType(EFFECT_TYPE_ACTIVATE) then exc=e:GetHandler() end
	if chkc then return chkc:IsOnField() and chkc:IsAbleToGrave() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsAbleToGrave,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,exc) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectTarget(tp,Card.IsAbleToGrave,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,exc)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,g,1,0,0)
end
function c75646312.op(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SendtoGrave(tc,REASON_EFFECT)
	end
end