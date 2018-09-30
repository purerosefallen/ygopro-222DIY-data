--星之骑士拟身 幽灵
function c65090048.initial_effect(c)
	--fusion material
	c:SetSPSummonOnce(65090048)
	c:EnableReviveLimit()
	aux.AddFusionProcCodeFun(c,65090001,aux.FilterBoolFunction(Card.IsRace,RACE_ZOMBIE),1,true,true)
	--control
	local e0=Effect.CreateEffect(c)
	e0:SetCategory(CATEGORY_CONTROL)
	e0:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e0:SetType(EFFECT_TYPE_IGNITION)
	e0:SetRange(LOCATION_MZONE)
	e0:SetCountLimit(1)
	e0:SetTarget(c65090048.target)
	e0:SetOperation(c65090048.operation)
	c:RegisterEffect(e0)
	--cannot target
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(0,LOCATION_MZONE)
	e1:SetCode(EFFECT_CANNOT_SELECT_BATTLE_TARGET)
	e1:SetCondition(c65090048.atcon)
	e1:SetValue(c65090048.atlimit)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e2:SetCondition(c65090048.atcon)
	e2:SetValue(aux.tgoval)
	c:RegisterEffect(e2)
	--Destroy replace
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EFFECT_DESTROY_REPLACE)
	e3:SetTarget(c65090048.desreptg)
	e3:SetOperation(c65090048.desrepop)
	c:RegisterEffect(e3)
end
function c65090048.desfil(c)
	return c:IsAbleToGrave() and not c:IsStatus(STATUS_DESTROY_CONFIRMED)
end
function c65090048.desreptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(c65090048.desfil,tp,LOCATION_MZONE,0,1,c) and c:IsReason(REASON_EFFECT) end
	return Duel.SelectEffectYesNo(tp,c,96)
end
function c65090048.desrepop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.SelectMatchingCard(tp,c65090048.desfil,tp,LOCATION_MZONE,0,1,1,c)
	local tc=g:GetFirst()
	if tc then
	Duel.HintSelection(g)
	Duel.SendtoGrave(g,REASON_EFFECT+REASON_REPLACE)
	end
end
function c65090048.atconfil(c,e)
	return c:GetFlagEffect(65090048)~=0
end
function c65090048.atcon(e)
	local tp=e:GetHandlerPlayer()
	return Duel.IsExistingMatchingCard(c65090048.atconfil,tp,LOCATION_MZONE,0,1,nil,e)
end
function c65090048.atlimit(e,c)
	return c==e:GetHandler()
end
function c65090048.filter(c)
	return c:IsFaceup() and c:IsControlerCanBeChanged()
end
function c65090048.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) and c65090048.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c65090048.filter,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONTROL)
	local g=Duel.SelectTarget(tp,c65090048.filter,tp,0,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_CONTROL,g,1,0,0)
end
function c65090048.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() and c:IsRelateToEffect(e) then
		Duel.GetControl(tc,tp)
		tc:RegisterFlagEffect(65090048,RESET_EVENT+EVENT_CONTROL_CHANGED+EVENT_LEAVE_FIELD_P,0,1)
		local e0=Effect.CreateEffect(c)
		e0:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e0:SetRange(LOCATION_MZONE)
		e0:SetCode(EVENT_ADJUST)
		e0:SetLabelObject(tc)
		e0:SetReset(RESET_EVENT+RESET_CONTROL)
		e0:SetOperation(c65090048.op)
		tc:RegisterEffect(e0)
	end
end
function c65090048.op(e,tp,eg,ep,ev,re,r,rp)
	local phase=Duel.GetCurrentPhase()
	local c=e:GetLabelObject()
	if (phase==PHASE_DAMAGE and not Duel.IsDamageCalculated()) or phase==PHASE_DAMAGE_CAL then return end
	local ec=e:GetOwner()
	if not ec:IsLocation(LOCATION_MZONE) or not ec:IsFaceup() then
		Duel.GetControl(c,1-e:GetOwnerPlayer())
	end
end