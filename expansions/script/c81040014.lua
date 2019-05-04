--周子·自在休憩
function c81040014.initial_effect(c)
	--Activate
	local e1=aux.AddRitualProcEqual2(c,c81040014.filter,LOCATION_HAND+LOCATION_REMOVED)
	e1:SetCountLimit(1,81040014)
	--tograve
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOGRAVE)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,81040914)
	e2:SetCondition(aux.exccon)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(c81040014.tgtg)
	e2:SetOperation(c81040014.tgop)
	c:RegisterEffect(e2)
end
function c81040014.filter(c)
	return c:IsSetCard(0x81c)
end
function c81040014.tgfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x81c) and c:IsType(TYPE_MONSTER)
end
function c81040014.tgtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_REMOVED) and chkc:IsControler(tp) and c81040014.tgfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c81040014.tgfilter,tp,LOCATION_REMOVED,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local sg=Duel.SelectTarget(tp,c81040014.tgfilter,tp,LOCATION_REMOVED,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,sg,1,0,0)
end
function c81040014.tgop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SendtoGrave(tc,REASON_EFFECT+REASON_RETURN)
	end
end
