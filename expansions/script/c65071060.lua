--彼方的裂片
function c65071060.initial_effect(c)
	--songs
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_REMOVE+CATEGORY_COIN)
	e2:SetType(EFFECT_TYPE_ACTIVATE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetTarget(c65071060.destg)
	e2:SetOperation(c65071060.desop)
	c:RegisterEffect(e2)
end
c65071060.toss_coin=true
function c65071060.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_COIN,nil,0,tp,3)
end
function c65071060.desop(e,tp,eg,ep,ev,re,r,rp)
	local c1,c2,c3=Duel.TossCoin(tp,3)
	if c1+c2+c3==0 then
		local g=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_HAND+LOCATION_ONFIELD+LOCATION_GRAVE,nil)
		Duel.Remove(g,POS_FACEDOWN,REASON_EFFECT)
	elseif c1+c2+c3==3 then
		local g=Duel.GetFieldGroup(aux.TRUE,tp,LOCATION_HAND+LOCATION_ONFIELD+LOCATION_GRAVE,0,nil)
		Duel.SendtoHand(g,1-tp,REASON_EFFECT)
	end
end
