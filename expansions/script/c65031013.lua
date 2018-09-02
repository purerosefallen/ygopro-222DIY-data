--自我的律歌舞台
function c65031013.initial_effect(c)
	--Activate
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e0)
	--SearchCard
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_FZONE)
	e1:SetCountLimit(1)
	e1:SetCost(c65031013.cost)
	e1:SetTarget(c65031013.target)
	e1:SetOperation(c65031013.operation)
	c:RegisterEffect(e1)
	--draw
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_CHAIN_SOLVED)
	e2:SetRange(LOCATION_FZONE)
	e2:SetOperation(c65031013.drop)
	c:RegisterEffect(e2)
end
function c65031013.drop(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():GetFlagEffect(65031013)~=0 then return end
	if not re:IsHasType(EFFECT_TYPE_ACTIVATE) or not re:IsActiveType(TYPE_COUNTER) or not re:GetHandler():IsSetCard(0xada1) or ep~=tp then return end
	if e:GetHandler():GetFlagEffect(65031013)==0 then
	local op=Duel.SelectOption(tp,aux.Stringid(65031013,0),aux.Stringid(65031013,1),aux.Stringid(65031013,2))
	if op==0 then
		Duel.Hint(HINT_CARD,0,65031013)
		Duel.BreakEffect()
		Duel.Draw(tp,1,REASON_EFFECT)
		e:GetHandler():RegisterFlagEffect(65031013,RESET_EVENT+0x1ec0000+RESET_PHASE+PHASE_END,0,1)
	end
	if op==1 then
		Duel.Hint(HINT_CARD,0,65031013)
		Duel.BreakEffect()
		Duel.Draw(tp,2,REASON_EFFECT)
		Duel.BreakEffect()
		local g=Duel.SelectMatchingCard(tp,aux.TRUE,tp,LOCATION_HAND,0,2,2,nil)
		Duel.SendtoDeck(g,tp,1,REASON_EFFECT)
		e:GetHandler():RegisterFlagEffect(65031013,RESET_EVENT+0x1ec0000+RESET_PHASE+PHASE_END,0,1)
	end
	if op==2 then return end
	end
end

function c65031013.costfil(c)
	return c:IsDiscardable() and not c:IsType(TYPE_COUNTER)
end

function c65031013.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c65031013.costfil,tp,LOCATION_HAND,0,1,nil) end
	Duel.DiscardHand(tp,c65031013.costfil,1,1,REASON_COST+REASON_DISCARD)
end
function c65031013.filter(c)
	return c:IsSetCard(0xada1) and c:IsType(TYPE_COUNTER) and c:IsAbleToHand()
end
function c65031013.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c65031013.filter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c65031013.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c65031013.filter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end