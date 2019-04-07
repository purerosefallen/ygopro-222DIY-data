--分断的转折
function c65030088.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOGRAVE+CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_TO_DECK)
	e1:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1,65030088+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(c65030088.con)
	e1:SetTarget(c65030088.tg)
	e1:SetOperation(c65030088.op)
	c:RegisterEffect(e1)
end
c65030088.card_code_list={65030086}
function c65030088.egfil(c,tp)
	return aux.IsCodeListed(c,65030086) and c:IsPreviousPosition(POS_FACEUP) and c:GetPreviousControler()==tp and c:IsLocation(LOCATION_DECK)
end
function c65030088.con(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c65030088.egfil,1,nil,tp)
end
function c65030088.tg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and chkc:IsAbleToGrave() and not chkc==e:GetHandler() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsAbleToGrave,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,e:GetHandler()) and Duel.IsPlayerCanDraw(tp) end
	local g=Duel.SelectTarget(tp,Card.IsAbleToGrave,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,0,0,tp,1)
end
function c65030088.op(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
	if Duel.SendtoGrave(tc,REASON_EFFECT)~=0 then
		Duel.Draw(tp,1,REASON_EFFECT)
	end
	end
end