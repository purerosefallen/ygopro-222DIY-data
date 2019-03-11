function c81000001.initial_effect(c)
	c:SetUniqueOnField(1,0,81000001)
	--link summon
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,c81000001.matfilter,2)
	--immune
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_IMMUNE_EFFECT)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(c81000001.inmcon)
	e1:SetValue(c81000001.efilter)
	c:RegisterEffect(e1)
	--atk down
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(81000001,0))
	e2:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_DEFCHANGE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP)
	e2:SetHintTiming(TIMING_DAMAGE_STEP+TIMING_END_PHASE)
	e2:SetCountLimit(1,81000001)
	e2:SetCondition(c81000001.atkcon)
	e2:SetTarget(c81000001.atktg)
	e2:SetOperation(c81000001.atkop)
	c:RegisterEffect(e2)
	--Effect Draw
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_DRAW_COUNT)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(c81000001.imcon)
	e3:SetTargetRange(1,0)
	e3:SetValue(2)
	c:RegisterEffect(e3)
end
function c81000001.matfilter(c)
	return c:GetSummonLocation()==LOCATION_EXTRA
end
function c81000001.inmcon(e)
	return Duel.GetTurnPlayer()~=e:GetHandlerPlayer()
end
function c81000001.efilter(e,te)
	return te:GetOwner()~=e:GetOwner()
end
function c81000001.atkcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()~=PHASE_DAMAGE or not Duel.IsDamageCalculated()
end
function c81000001.atktg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsFaceup() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	Duel.SetChainLimit(c81000001.chlimit)
end
function c81000001.chlimit(e,ep,tp)
	return tp==ep
end
function c81000001.atkop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	local c=e:GetHandler()
	if tc:IsFaceup() and tc:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_SET_ATTACK_FINAL)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		e1:SetValue(100)
		tc:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_SET_DEFENSE_FINAL)
		tc:RegisterEffect(e2)
	end
end
function c81000001.imfilter(c)
	return c:IsType(TYPE_MONSTER)
end
function c81000001.imcon(e)
	return e:GetHandler():GetLinkedGroup():IsExists(c81000001.imfilter,1,nil)
end
