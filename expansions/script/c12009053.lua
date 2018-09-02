--
function c12009053.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,nil,4,2,c12009053.ovfilter,aux.Stringid(12009053,0))
	c:EnableReviveLimit()
	 --atkup
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(12009053,1))
	e3:SetCategory(CATEGORY_ATKCHANGE)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_MZONE)
	e3:SetHintTiming(TIMING_DAMAGE_STEP)
	e3:SetCountLimit(1,12009053)
	e3:SetCost(c12009053.cost)
	e3:SetCondition(c12009053.atkcon)
	e3:SetTarget(c12009053.atktg)
	e3:SetOperation(c12009053.atkop)
	c:RegisterEffect(e3)
	--material
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(12009053,2))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,12009153)
	e2:SetTarget(c12009053.mattg)
	e2:SetOperation(c12009053.matop)
	c:RegisterEffect(e2)
end
function c12009053.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():GetFlagEffect(12011025)==0 and e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c12009053.ovfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_XYZ) and c:IsRank(3) and c:IsRace(RACE_MACHINE)
end
function c12009053.atkcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()~=PHASE_DAMAGE or not Duel.IsDamageCalculated()
end
function c12009053.atkfilter(c)
	return c:IsFaceup()
end
function c12009053.atktg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c12009053.atkfilter(chkc) end
	if chk==0 then return
		Duel.IsExistingTarget(c12009053.atkfilter,tp,LOCATION_MZONE,0,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c12009053.atkfilter,tp,LOCATION_MZONE,0,1,1,nil)
end
function c12009053.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(800)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
		local code=tc:GetOriginalCode()
		local e11=Effect.CreateEffect(c)
				e11:SetType(EFFECT_TYPE_SINGLE)
				e11:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
				e11:SetReset(RESET_EVENT+0x1ff0000)
				e11:SetCode(EFFECT_CHANGE_CODE)
				e11:SetValue(code)
				c:RegisterEffect(e11)
	end
end
function c12009053.xyzfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_XYZ)
end
function c12009053.mattg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) and c12009053.xyzfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c12009053.xyzfilter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c12009053.xyzfilter,tp,LOCATION_MZONE,0,1,1,nil)
end
function c12009053.matop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsFaceup() and tc:IsRelateToEffect(e) and not tc:IsImmuneToEffect(e) and e:GetHandler():IsRelateToEffect(e) then
			Duel.Overlay(tc,e:GetHandler())
	end
end
