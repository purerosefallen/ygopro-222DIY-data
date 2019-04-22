--空鸽公主
function c81006008.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	c:EnableReviveLimit()
	--spsummon bgm
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e0:SetCode(EVENT_SPSUMMON_SUCCESS)
	e0:SetCondition(c81006008.sumcon)
	e0:SetOperation(c81006008.sumsuc)
	c:RegisterEffect(e0)
	--deck search
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_DECKDES)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCountLimit(1,81006008)
	e1:SetTarget(c81006008.target)
	e1:SetOperation(c81006008.operation)
	c:RegisterEffect(e1)
	--immune spell
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_IMMUNE_EFFECT)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetValue(c81006008.efilter)
	c:RegisterEffect(e2)
	--Atk up
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_UPDATE_ATTACK)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetValue(c81006008.atkval)
	c:RegisterEffect(e3)
	--
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_CHAINING)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1,81006908)
	e4:SetCondition(c81006008.negcon)
	e4:SetCost(c81006008.negcost)
	e4:SetTarget(c81006008.negtg)
	e4:SetOperation(c81006008.negop)
	c:RegisterEffect(e4)
end
function c81006008.sumcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_RITUAL) or e:GetHandler():IsSummonType(SUMMON_TYPE_PENDULUM)
end
function c81006008.sumsuc(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_MUSIC,0,aux.Stringid(81006008,0))
end
function c81006008.efilter(e,te)
	return (te:IsActiveType(TYPE_SPELL) or te:IsActiveType(TYPE_TRAP)) and te:GetOwnerPlayer()~=e:GetHandlerPlayer()
end
function c81006008.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local ct=Duel.GetMatchingGroupCount(nil,tp,LOCATION_PZONE,LOCATION_PZONE,nil)
		if ct==0 or Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)<ct then return false end
		local g=Duel.GetDecktopGroup(tp,ct)
		return g:FilterCount(Card.IsAbleToHand,nil)>0
	end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,0,LOCATION_DECK)
end
function c81006008.thfilter(c)
	return c:IsType(TYPE_RITUAL) and (c:IsType(TYPE_SPELL) or c:IsType(TYPE_PENDULUM)) and c:IsAbleToHand()
end
function c81006008.operation(e,tp,eg,ep,ev,re,r,rp)
	local ct=Duel.GetMatchingGroupCount(nil,tp,LOCATION_PZONE,LOCATION_PZONE,nil)
	if ct==0 then return end
	local g=Duel.GetDecktopGroup(tp,ct)
	Duel.ConfirmDecktop(tp,ct)
	tg=g:Filter(c81006008.thfilter,nil)
	if tg:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local tc=tg:Select(tp,1,1,nil):GetFirst()
		if tc:IsAbleToHand() then
			Duel.SendtoHand(tc,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,tc)
			Duel.ShuffleHand(tp)
		else
			Duel.SendtoGrave(tc,REASON_RULE)
		end
		g:RemoveCard(tc)
		Duel.SendtoGrave(g,REASON_EFFECT+REASON_REVEAL)
	end
	Duel.ShuffleDeck(tp)
end
function c81006008.atkval(e,c)
	return Duel.GetMatchingGroupCount(Card.IsType,c:GetControler(),LOCATION_GRAVE,LOCATION_GRAVE,nil,TYPE_RITUAL)*300
end
function c81006008.negcon(e,tp,eg,ep,ev,re,r,rp)
	return ep~=tp
end
function c81006008.thcfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsDiscardable()
end
function c81006008.negcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c81006008.thcfilter,tp,LOCATION_HAND,0,1,nil) end
	Duel.DiscardHand(tp,c81006008.thcfilter,1,1,REASON_COST+REASON_DISCARD)
end
function c81006008.negtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local g=Duel.GetMatchingGroup(nil,tp,LOCATION_PZONE,0,nil)
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c81006008.negop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectMatchingCard(tp,nil,tp,LOCATION_PZONE,0,1,1,nil)
	if #g>0 and Duel.Destroy(g,REASON_EFFECT)~=0 then
		Duel.NegateActivation(ev)
	end
end
