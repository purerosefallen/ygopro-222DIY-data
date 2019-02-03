--辉煌的天邪逆鬼
function c65090065.initial_effect(c)
	--seija!
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_CHAINING)
	e1:SetRange(LOCATION_HAND)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1,65090065)
	e1:SetCost(c65090065.con)
	e1:SetTarget(c65090065.tg)
	e1:SetOperation(c65090065.op)
	c:RegisterEffect(e1)
	--search
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_REMOVE)
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e2:SetCondition(c65090065.thcon)
	e2:SetTarget(c65090065.thtg)
	e2:SetOperation(c65090065.thop)
	c:RegisterEffect(e2)
end
function c65090065.con(e,tp,eg,ep,ev,re,r,rp)
	return rp~=tp 
end
function c65090065.tg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) end
	if chk==0 then return Duel.IsExistingTarget(aux.TRUE,tp,0,LOCATION_MZONE,1,nil) and e:GetHandler():IsAbleToRemove() end
	local g=Duel.SelectTarget(tp,aux.TRUE,tp,0,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,e:GetHandler(),1,0,0)
end
function c65090065.seif(c,att)
	return c:IsSetCard(0x9da7) and c:IsType(TYPE_MONSTER) and c:IsAttribute(att) and c:IsAbleToRemove()
end
function c65090065.op(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_EFFECT)~=0 and tc:IsRelateToEffect(e) and tc:IsFaceup() then
		local att=tc:GetAttribute() 
		if Duel.IsExistingMatchingCard(c65090065.seif,tp,LOCATION_DECK,0,1,nil,att) and Duel.SelectYesNo(tp,aux.Stringid(65090065,0)) then
			local g=Duel.SelectMatchingCard(tp,c65090065.seif,tp,LOCATION_DECK,0,1,1,nil,att)
			Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
		end
	end
end

function c65090065.thcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsReason(REASON_EFFECT) and re:GetHandler():IsSetCard(0x9da7) and re:IsActiveType(TYPE_MONSTER)
end
function c65090065.filter(c)
	return c:IsSetCard(0x9da7) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToHand()
end
function c65090065.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c65090065.filter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c65090065.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c65090065.filter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_TO_HAND)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c65090065.cntg)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c65090065.cntg(e,c)
	return c:IsLocation(LOCATION_DECK) and c:IsType(TYPE_SPELL+TYPE_TRAP)
end
