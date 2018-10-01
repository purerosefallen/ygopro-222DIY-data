--新星之声
function c65071093.initial_effect(c)
	--multi attack
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,65071093+EFFECT_COUNT_CODE_OATH)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCondition(c65071093.condition)
	e1:SetTarget(c65071093.target)
	e1:SetOperation(c65071093.operation)
	c:RegisterEffect(e1)
	--add to hand
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCountLimit(1,65071193)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCondition(c65071093.thcon)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(c65071093.thtg)
	e2:SetOperation(c65071093.thop)
	c:RegisterEffect(e2)
end

function c65071093.thcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()~=tp and Duel.GetFieldGroupCount(tp,0,LOCATION_HAND)==0 
end

function c65071093.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(1-tp) and chkc:IsAbleToHand() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsAbleToHand,tp,0,LOCATION_GRAVE,1,nil) end
	local g=Duel.SelectTarget(tp,Card.IsAbleToHand,tp,0,LOCATION_GRAVE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,1-tp,LOCATION_GRAVE)
end
function c65071093.thop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SendtoHand(tc,tp,REASON_EFFECT)
	end
end

function c65071093.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsAbleToEnterBP()
end

function c65071093.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingTarget(Card.IsFaceup,tp,LOCATION_MZONE,0,1,nil) end
	local g=Duel.SelectTarget(tp,Card.IsFaceup,tp,LOCATION_MZONE,0,1,1,nil)
end
function c65071093.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	local num=Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)
	if tc:IsRelateToEffect(e) and tc:IsFaceup() then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_EXTRA_ATTACK)
		e1:SetValue(num)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_OATH)
		e2:SetCode(EFFECT_CANNOT_DIRECT_ATTACK)
		e2:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e2)
	end
end