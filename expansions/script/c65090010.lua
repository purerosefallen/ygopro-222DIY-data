--星之骑士拟身 镜子
function c65090010.initial_effect(c)
	--fusion material
	c:SetSPSummonOnce(65090010)
	c:EnableReviveLimit()
	aux.AddFusionProcCodeFun(c,65090001,aux.FilterBoolFunction(Card.IsRace,RACE_SPELLCASTER),1,true,true)
	--target
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetTarget(c65090010.tg)
	e1:SetOperation(c65090010.op)
	c:RegisterEffect(e1)
end
function c65090010.tg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and not chkc==e:GetHandler() end
	if chk==0 then return Duel.IsExistingTarget(aux.TRUE,tp,LOCATION_MZONE,LOCATION_MZONE,1,e:GetHandler()) end
	local g=Duel.SelectTarget(tp,aux.TRUE,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,e:GetHandler())
end
function c65090010.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		--cannot select battle target
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetTargetRange(0,LOCATION_MZONE)
		e1:SetLabelObject(tc)
		e1:SetCode(EFFECT_CANNOT_SELECT_BATTLE_TARGET)
		e1:SetReset(RESET_PHASE+PHASE_END)
		e1:SetCondition(c65090010.atcon)
		e1:SetValue(c65090010.atlimit)
		Duel.RegisterEffect(e1,tp)
		--direct attack
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_FIELD)
		e2:SetCode(EFFECT_DIRECT_ATTACK)
		e2:SetLabelObject(tc)
		e2:SetTargetRange(LOCATION_MZONE,0)
		e2:SetReset(RESET_PHASE+PHASE_END)
		e2:SetCondition(c65090010.atcon)
		e2:SetTarget(c65090010.attg)
		Duel.RegisterEffect(e2,tp)
	end
end
function c65090010.atcon(e,c)
	local tc=e:GetLabelObject()
	return tc:IsLocation(LOCATION_MZONE)
end
function c65090010.atlimit(e,c)
	return c==e:GetHandler() and c:IsFaceup()
end
function c65090010.attg(e,c)
	return c==e:GetHandler() and c:IsFaceup()
end