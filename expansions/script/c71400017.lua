--妄想梦境-门的世界
function c71400017.initial_effect(c)
	--Activate
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	e0:SetCountLimit(1,71400017+EFFECT_COUNT_CODE_OATH)
	c:RegisterEffect(e0)
	--search
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(71400017,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_FZONE)
	e1:SetCountLimit(1)
	e1:SetTarget(c71400017.target)
	e1:SetOperation(c71400017.operation)
	c:RegisterEffect(e1)
	--banish
	--currently null
	--self limitation
	local esl=Effect.CreateEffect(c)
	esl:SetDescription(aux.Stringid(71400017,1))
	esl:SetType(EFFECT_TYPE_QUICK_F)
	esl:SetCode(EVENT_CHAINING)
	esl:SetRange(LOCATION_FZONE)
	esl:SetCondition(c71400017.slcon)
	esl:SetOperation(c71400017.slop)
	c:RegisterEffect(esl)
	--field activation
	local efa=Effect.CreateEffect(c)
	efa:SetDescription(aux.Stringid(71400017,2))
	efa:SetCategory(EFFECT_TYPE_ACTIVATE)
	efa:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	efa:SetCode(EVENT_LEAVE_FIELD)
	efa:SetRange(LOCATION_FZONE)
	efa:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	efa:SetCondition(c71400017.facon)
	efa:SetTarget(c71400017.fatg)
	efa:SetOperation(c71400017.faop)
	c:RegisterEffect(efa)
end
function c71400017.filter1(c)
	return c:IsSetCard(0xa714) and c:IsType(TYPE_FIELD) and not c:IsCode(71400017) and c:IsAbleToHand()
end
function c71400017.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c71400017.filter1,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,0,tp,LOCATION_DECK)
end
function c71400017.operation(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local g=Duel.GetMatchingGroup(c71400017.filter1,tp,LOCATION_DECK,0,nil)
		if g:GetCount()<=0 then return end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local sg1=g:Select(tp,1,1,nil)
		g:Remove(Card.IsCode,nil,sg1:GetFirst():GetCode())
		if g:GetCount()>0 and Duel.SelectYesNo(tp,210) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
			local sg2=g:Select(tp,1,1,nil)
			sg1:Merge(sg2)
		end
	Duel.SendtoHand(sg1,nil,REASON_EFFECT)
	Duel.ConfirmCards(1-tp,sg1)
end
function c71400017.slcon(e,tp,eg,ep,ev,re,r,rp)
	local ec=re:GetHandler()
	return (re:IsActiveType(TYPE_MONSTER) or re:IsHasType(EFFECT_TYPE_ACTIVATE)) and rp==tp and not ec:IsSetCard(0x714)
end
function c71400017.slop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetValue(aux.TargetBoolFunction(Card.IsSetCard,0x714))
	e1:SetTargetRange(1,0)
	Duel.RegisterEffect(e1,tp)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetCode(EFFECT_CANNOT_SUMMON)
	e2:SetReset(RESET_PHASE+PHASE_END)
	e2:SetValue(aux.TargetBoolFunction(Card.IsSetCard,0x714))
	e2:SetTargetRange(1,0)
	Duel.RegisterEffect(e2,tp)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetCode(EFFECT_CANNOT_MSET)
	e3:SetReset(RESET_PHASE+PHASE_END)
	e3:SetValue(aux.TargetBoolFunction(Card.IsSetCard,0x714))
	e3:SetTargetRange(1,0)
	Duel.RegisterEffect(e3,tp)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e4:SetCode(EFFECT_CANNOT_ACTIVATE)
	e4:SetReset(RESET_PHASE+PHASE_END)
	e4:SetValue(c71400017.selflimit)
	e4:SetTargetRange(1,0)
	Duel.RegisterEffect(e4,tp)
end
function c71400017.selflimit(e,re,tp)
	local c=re:GetHandler()
	return c:IsSetCard(0x714) and not c:IsImmuneToEffect(e)
end
function c71400017.fatg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c71400017.fafilter,tp,LOCATION_DECK+LOCATION_HAND,0,1,nil,tp) end
end
function c71400017.fafilter(c,tp)
	return c:IsType(TYPE_FIELD) and c:GetActivateEffect():IsActivatable(tp) and c:IsSetCard(0xb714) and not c:IsCode(71400017)
end
function c71400017.facon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsReason(REASON_EFFECT) and not c:IsLocation(LOCATION_DECK)
		and c:IsPreviousPosition(POS_FACEUP)
end
function c71400017.faop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(71400017,3))
	local tc=Duel.SelectMatchingCard(tp,c71400017.fafilter,tp,LOCATION_DECK+LOCATION_HAND,0,1,1,nil,tp):GetFirst()
	if tc then
		local fc=Duel.GetFieldCard(tp,LOCATION_SZONE,5)
		if fc then
			Duel.SendtoGrave(fc,REASON_RULE)
			Duel.BreakEffect()
		end
		Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
		local te=tc:GetActivateEffect()
		local tep=tc:GetControler()
		local cost=te:GetCost()
		if cost then cost(te,tep,eg,ep,ev,re,r,rp,1) end
		Duel.RaiseEvent(tc,c71400017,te,0,tp,tp,Duel.GetCurrentChain())
	end
end