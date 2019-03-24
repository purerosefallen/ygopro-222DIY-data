
function c107898505.initial_effect(c)
	c:EnableReviveLimit()
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCost(c107898505.cost)
	e1:SetTarget(c107898505.target)
	e1:SetOperation(c107898505.operation)
	c:RegisterEffect(e1)
end
function c107898505.efilter(e,te)
	return not te:GetOwner():IsSetCard(0x575)
end
function c107898505.filter(c)
	return c:IsCode(107898101) and c:IsFaceup()
end
function c107898505.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():GetLevel()==1
	or Duel.IsCanRemoveCounter(tp,1,0,0x1,math.floor(e:GetHandler():GetLevel()/2),REASON_COST)
	and not e:GetHandler():IsPublic() end
	if e:GetHandler():GetLevel()>1 then
		Duel.RemoveCounter(tp,1,0,0x1,math.floor(e:GetHandler():GetLevel()/2),REASON_COST)
	end
end
function c107898505.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c107898505.filter(chkc) end
	if chk==0 then return e:GetHandler():IsAbleToRemove(tp) and Duel.IsExistingTarget(c107898505.filter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c107898505.filter,tp,LOCATION_MZONE,0,1,1,nil)
end
function c107898505.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if c:IsRelateToEffect(e) then
		Duel.Remove(e:GetHandler(),POS_FACEDOWN,REASON_EFFECT)
	end
	if tc:IsRelateToEffect(e) and tc:IsFaceup() and tc:IsControler(tp) then
		if not tc:IsType(TYPE_EFFECT) then
			local e0=Effect.CreateEffect(c)
			e0:SetType(EFFECT_TYPE_SINGLE)
			e0:SetCode(EFFECT_ADD_TYPE)
			e0:SetValue(TYPE_EFFECT)
			e0:SetReset(RESET_EVENT+0x1fe0000)
			tc:RegisterEffect(e0,true)
		end
		--draw
		local e1=Effect.CreateEffect(c)
		e1:SetDescription(aux.Stringid(107898505,1))
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e1:SetRange(LOCATION_MZONE)
		e1:SetCategory(CATEGORY_DRAW)
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
		e1:SetCode(EVENT_DRAW)
		e1:SetCost(c107898505.drcost)
		e1:SetTarget(c107898505.drtg)
		e1:SetOperation(c107898505.drop)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e1,true)
		tc:RegisterFlagEffect(tc:GetCode(),RESET_EVENT+0x1fe0000,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(107898505,0))
	end
end
function c107898505.drfilter(c)
	return c:IsSetCard(0x575f) and not c:IsPublic()
end
function c107898505.drcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return ep==tp and eg:IsExists(c107898505.drfilter,1,nil) end
	local g=eg:Filter(c107898505.drfilter,nil)
	e:SetLabel(g:GetCount())
	Duel.ConfirmCards(1-tp,g)
	Duel.ShuffleHand(tp)
end
function c107898505.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,e:GetLabel()*2) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(e:GetLabel()*2)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,e:GetLabel()*2)
end
function c107898505.drop(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsFacedown() or not e:GetHandler():IsRelateToEffect(e) then return end
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end
