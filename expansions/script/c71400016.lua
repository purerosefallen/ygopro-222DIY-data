--妄想梦境-空中庭园
function c71400016.initial_effect(c)
	--Activate
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	e0:SetCountLimit(1,71400016+EFFECT_COUNT_CODE_OATH)
	c:RegisterEffect(e0)
	--to hand
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(71400016,0))
	e1:SetCategory(CATEGORY_DESTROY+CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_FZONE)
	e1:SetCountLimit(1)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetTarget(c71400016.target)
	e1:SetOperation(c71400016.operation)
	c:RegisterEffect(e1)
	--self limitation
	local esl=Effect.CreateEffect(c)
	esl:SetDescription(aux.Stringid(71400016,1))
	esl:SetType(EFFECT_TYPE_QUICK_F)
	esl:SetCode(EVENT_CHAINING)
	esl:SetRange(LOCATION_FZONE)
	esl:SetCondition(c71400016.slcon)
	esl:SetOperation(c71400016.slop)
	c:RegisterEffect(esl)
	--field activation
	local efa=Effect.CreateEffect(c)
	efa:SetDescription(aux.Stringid(71400016,2))
	efa:SetCategory(EFFECT_TYPE_ACTIVATE)
	efa:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	efa:SetCode(EVENT_LEAVE_FIELD)
	efa:SetRange(LOCATION_FZONE)
	efa:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	efa:SetCondition(c71400016.facon)
	efa:SetTarget(c71400016.fatg)
	efa:SetOperation(c71400016.faop)
	c:RegisterEffect(efa)
end
function c71400016.filter(c)
	return c:IsSetCard(0x714) and c:IsAbleToHand()
end
function c71400016.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c71400016.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c71400016.filter,tp,LOCATION_GRAVE,0,1,nil) and Duel.IsExistingMatchingCard(nil,tp,LOCATION_ONFIELD,0,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectTarget(tp,c71400016.filter,tp,LOCATION_GRAVE,0,1,1,nil)
	local mg=Duel.GetMatchingGroup(nil,tp,LOCATION_ONFIELD,0,e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,tp,LOCATION_GRAVE)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,mg,1,tp,LOCATION_ONFIELD)
end
function c71400016.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectMatchingCard(tp,nil,tp,LOCATION_ONFIELD,0,1,1,c)
	if g:GetCount()>0 and tc:IsRelateToEffect(e) and Duel.Destroy(g,REASON_EFFECT)~=0 and Duel.SendtoHand(tc,nil,REASON_EFFECT)~=0 then
		Duel.ConfirmCards(1-tp,tc)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e1:SetCode(EFFECT_CANNOT_ACTIVATE)
		e1:SetTargetRange(1,0)
		e1:SetValue(c71400016.aclimit)
		e1:SetLabelObject(tc)
		e1:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e1,tp)
	end
end
function c71400016.aclimit(e,re,tp)
	local tc=e:GetLabelObject()
	return re:GetHandler():IsCode(tc:GetCode()) and not re:GetHandler():IsImmuneToEffect(e)
end
function c71400016.slcon(e,tp,eg,ep,ev,re,r,rp)
	local ec=re:GetHandler()
	return re:IsActiveType(TYPE_MONSTER) or re:IsHasType(EFFECT_TYPE_ACTIVATE) and rp==tp and not ec:IsSetCard(0x714)
end
function c71400016.slop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetValue(c71400016.selflimit)
	e1:SetTargetRange(1,0)
	Duel.RegisterEffect(e1,tp)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetCode(EFFECT_CANNOT_SUMMON)
	e2:SetReset(RESET_PHASE+PHASE_END)
	e2:SetValue(c71400016.selflimit)
	e2:SetTargetRange(1,0)
	Duel.RegisterEffect(e2,tp)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetCode(EFFECT_CANNOT_MSET)
	e3:SetReset(RESET_PHASE+PHASE_END)
	e3:SetValue(c71400016.selflimit)
	e3:SetTargetRange(1,0)
	Duel.RegisterEffect(e3,tp)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e4:SetCode(EFFECT_CANNOT_ACTIVATE)
	e4:SetReset(RESET_PHASE+PHASE_END)
	e4:SetValue(c71400016.selflimit)
	e4:SetTargetRange(1,0)
	Duel.RegisterEffect(e4,tp)
end
function c71400016.selflimit(e,re,tp)
	local c=re:GetHandler()
	return c:IsSetCard(0x714) and not c:IsImmuneToEffect(e)
end
function c71400016.fatg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c71400016.fafilter,tp,LOCATION_DECK+LOCATION_HAND,0,1,nil,tp) end
end
function c71400016.fafilter(c,tp)
	return c:IsType(TYPE_FIELD) and c:GetActivateEffect():IsActivatable(tp) and c:IsSetCard(0xb714) and not c:IsCode(71400016)
end
function c71400016.facon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsReason(REASON_EFFECT) and not c:IsLocation(LOCATION_DECK)
		and c:IsPreviousPosition(POS_FACEUP)
end
function c71400016.faop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(71400016,3))
	local tc=Duel.SelectMatchingCard(tp,c71400016.fafilter,tp,LOCATION_DECK+LOCATION_HAND,0,1,1,nil,tp):GetFirst()
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
		Duel.RaiseEvent(tc,c71400016,te,0,tp,tp,Duel.GetCurrentChain())
	end
end