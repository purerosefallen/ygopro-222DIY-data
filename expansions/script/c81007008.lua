--夏日水着·三村加奈子
function c81007008.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,nil,5,3,c81007008.ovfilter,aux.Stringid(81007008,0),3,c81007008.xyzop)
	c:EnableReviveLimit()
	--remove
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_REMOVE)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,81007008)
	e2:SetCondition(c81007008.rmcon)
	e2:SetCost(c81007008.rmcost)
	e2:SetTarget(c81007008.rmtg)
	e2:SetOperation(c81007008.rmop)
	c:RegisterEffect(e2)
	--damage
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_CHAINING)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(c81007008.regcon)
	e1:SetOperation(c81007008.regop)
	c:RegisterEffect(e1)
end
function c81007008.ovfilter(c)
	return c:IsFaceup() and c:IsCode(81007008)
end
function c81007008.xyzop(e,tp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,81007008)==0 end
	Duel.RegisterFlagEffect(tp,81007008,RESET_PHASE+PHASE_END,0,1)
end
function c81007008.rmcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetOverlayGroup():IsExists(Card.IsRace,1,nil,RACE_FAIRY)
end
function c81007008.rmcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c81007008.rmtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and chkc:IsAbleToRemove() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsAbleToRemove,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectTarget(tp,Card.IsAbleToRemove,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,0,0)
end
function c81007008.rmop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)
	end
end
function c81007008.filter(c)
	return c:IsFaceup() and c:IsLocation(LOCATION_ONFIELD)
end
function c81007008.regcon(e,tp,eg,ep,ev,re,r,rp)
	if not re or not re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then return false end
	local g=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
	return g and g:IsExists(c81007008.filter,1,nil) and 1-tp==rp
end
function c81007008.regop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_CHAIN_SOLVING)
	e1:SetRange(LOCATION_SZONE)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetLabelObject(re)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET+RESET_CHAIN)
	e1:SetCondition(c81007008.damcon)
	e1:SetOperation(c81007008.damop)
	c:RegisterEffect(e1)
end
function c81007008.damcon(e,tp,eg,ep,ev,re,r,rp)
	return re==e:GetLabelObject()
end
function c81007008.damop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,81007008)
	Duel.Damage(1-tp,700,REASON_EFFECT)
end
