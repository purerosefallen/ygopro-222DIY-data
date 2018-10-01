--薄暝
function c65071063.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(c65071063.cost)
	e1:SetTarget(c65071063.target)
	e1:SetOperation(c65071063.activate)
	c:RegisterEffect(e1)
	if not c65071063.global_check then
		c65071063.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_CHAINING)
		ge1:SetOperation(c65071063.checkop)
		Duel.RegisterEffect(ge1,0)
	end
end
function c65071063.checkop(e,tp,eg,ep,ev,re,r,rp)
	if re:IsHasType(EFFECT_TYPE_ACTIVATE) and re:IsActiveType(TYPE_SPELL+TYPE_TRAP) and not re:GetHandler()==e:GetHandler() then
		Duel.RegisterFlagEffect(rp,65071063,RESET_PHASE+PHASE_END,0,1)
	end
end
function c65071063.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(nil,tp,LOCATION_HAND,0,e:GetHandler())
	local g2=Duel.GetMatchingGroup(Card.IsFacedown,tp,LOCATION_SZONE,0,e:GetHandler())
	g:Merge(g2)
	if chk==0 then return Duel.GetFlagEffect(tp,65071063)==0
		and g:GetCount()>0 and g:GetCount()==g:FilterCount(Card.IsAbleToRemoveAsCost,nil) end
	Duel.Remove(g,POS_FACEUP,REASON_COST)
	--oath effects
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetCode(EFFECT_CANNOT_ACTIVATE)
	e1:SetTargetRange(1,0)
	e1:SetValue(c65071063.aclimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c65071063.aclimit(e,re,tp)
	return re:IsHasType(EFFECT_TYPE_ACTIVATE) and re:IsActiveType(TYPE_SPELL) and not re:GetHandler()==e:GetHandler()
end
function c65071063.filter(c)
	return c:IsType(TYPE_SPELL) and c:IsType(TYPE_QUICKPLAY) and c:IsAbleToHand()
end
function c65071063.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c65071063.filter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c65071063.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c65071063.filter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end