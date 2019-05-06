--一页曲形-异类注视-
function c65020153.initial_effect(c)
	--change effect
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_POSITION+CATEGORY_NEGATE+CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_CHAINING)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCondition(c65020153.con)
	e1:SetTarget(c65020153.tg)
	e1:SetOperation(c65020153.op)
	c:RegisterEffect(e1)
	--tohand
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,65020153)
	e2:SetCondition(c65020153.thcon)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(c65020153.thtg)
	e2:SetOperation(c65020153.thop)
	c:RegisterEffect(e2)
end
function c65020153.con(e,tp,eg,ep,ev,re,r,rp)
	return ep~=tp and re:IsActiveType(TYPE_MONSTER)
end
function c65020153.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	 if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and chkc:IsFacedown() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsFacedown,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_POSCHANGE)
	local g=Duel.SelectTarget(tp,Card.IsFacedown,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_POSITION,g,1,0,0)
end
function c65020153.op(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFacedown() and Duel.ChangePosition(tc,POS_FACEUP_DEFENSE)~=0 and tc:IsSetCard(0x3da7) and Duel.IsChainNegatable(ev) then
		if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) then
			Duel.Destroy(re:GetHandler(),REASON_EFFECT)
		end
	end
end

function c65020153.thconfil(c)
	return c:IsSetCard(0x3da7) and c:GetSummonLocation()==LOCATION_EXTRA 
end
function c65020153.thcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c65020153.thconfil,1,nil)
end
function c65020153.thfil(c)
	return c:IsSetCard(0x3da7) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c65020153.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	 if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c65020153.thfil(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c65020153.thfil,tp,LOCATION_GRAVE,0,1,nil) end
	local g=Duel.SelectTarget(tp,c65020153.thfil,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function c65020153.thop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
	end
end