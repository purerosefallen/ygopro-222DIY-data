--天使制裁者·高山纱代子
function c81013004.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,c81013004.mfilter,5,4,c81013004.ovfilter,aux.Stringid(81013004,0),4,c81013004.xyzop)
	c:EnableReviveLimit()
	--Change race
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CHANGE_RACE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(0,LOCATION_MZONE)
	e1:SetValue(RACE_FAIRY)
	c:RegisterEffect(e1)
	--immune
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EFFECT_IMMUNE_EFFECT)
	e2:SetValue(c81013004.efilter)
	c:RegisterEffect(e2)
	--attack up
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_ATKCHANGE)
	e3:SetDescription(aux.Stringid(81013004,0))
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,81013004)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetHintTiming(TIMING_DAMAGE_STEP)
	e3:SetCondition(c81013004.condi)
	e3:SetCost(c81013004.cost)
	e3:SetTarget(c81013004.target)
	e3:SetOperation(c81013004.operation)
	c:RegisterEffect(e3)
end
function c81013004.mfilter(c)
	return c:IsRace(RACE_WARRIOR)
end
function c81013004.ovfilter(c)
	return c:IsFaceup() and c:IsCode(81013002)
end
function c81013004.xyzop(e,tp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,81013004)==0 end
	Duel.RegisterFlagEffect(tp,81013004,RESET_PHASE+PHASE_END,0,1)
end
function c81013004.efilter(e,te)
	return te:IsActiveType(TYPE_MONSTER) and te:GetHandler():IsRace(RACE_FAIRY)
end
function c81013004.condi(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetOverlayGroup():IsExists(Card.IsCode,1,nil,81008008)
end
function c81013004.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c81013004.filter(c)
	return c:IsFaceup() and c:IsRace(RACE_FAIRY)
end
function c81013004.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c81013004.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c81013004.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c81013004.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	Duel.SetChainLimit(c81013004.chlimit)
end
function c81013004.chlimit(e,ep,tp)
	return tp==ep
end
function c81013004.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and c81013004.filter(tc) then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetCode(EFFECT_SET_ATTACK_FINAL)
		e1:SetValue(0)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
	end
end
