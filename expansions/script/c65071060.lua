--彼方的裂片
function c65071060.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_COIN+CATEGORY_ATKCHANGE+CATEGORY_DEFCHANGE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(c65071060.condition)
	e1:SetTarget(c65071060.target)
	e1:SetOperation(c65071060.activate)
	c:RegisterEffect(e1)
	--songs
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_REMOVE+CATEGORY_COIN)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(c65071060.destg)
	e2:SetOperation(c65071060.desop)
	c:RegisterEffect(e2)
end
c65071060.toss_coin=true
function c65071060.condition(e,tp,eg,ep,ev,re,r,rp,chk)
	return Duel.IsExistingMatchingCard(Card.IsFaceup,tp,0,LOCATION_MZONE,1,nil) 
end
function c65071060.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsFaceup,tp,0,LOCATION_MZONE,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_COIN,nil,0,tp,3)
end
function c65071060.activate(e,tp,eg,ep,ev,re,r,rp)
	local c1,c2,c3=Duel.TossCoin(tp,3)
	local ct=c1+c2+c3
	local atk=ct*200
	local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,0,LOCATION_MZONE,nil)
	if g:GetCount()==0 or atk==0 then return end
	local tc=g:GetFirst()
	while tc do
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		e1:SetValue(-atk)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_UPDATE_DEFENSE)
		e2:SetReset(RESET_EVENT+0x1fe0000)
		e2:SetValue(-atk)
		tc:RegisterEffect(e2)
		tc=g:GetNext()
	end
end
function c65071060.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_COIN,nil,0,tp,3)
end
function c65071060.desop(e,tp,eg,ep,ev,re,r,rp)
	local c1,c2,c3=Duel.TossCoin(tp,3)
	if c1+c2+c3==3 then
		local g=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_HAND+LOCATION_ONFIELD+LOCATION_GRAVE,nil)
		Duel.Remove(g,POS_FACEDOWN,REASON_EFFECT)
	elseif c1+c2+c3==0 then
		local g=Duel.GetFieldGroup(aux.TRUE,tp,LOCATION_HAND+LOCATION_ONFIELD+LOCATION_GRAVE,0,nil)
		Duel.SendtoHand(g,1-tp,REASON_EFFECT)
	end
end