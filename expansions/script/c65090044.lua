--星之骑士拟身 万形
function c65090044.initial_effect(c)
	--fusion material
	c:SetSPSummonOnce(65090044)
	c:EnableReviveLimit()
	aux.AddFusionProcMix(c,true,false,65090001,aux.FilterBoolFunction(Card.IsRace,RACE_WARRIOR),aux.FilterBoolFunction(Card.IsAttribute,ATTRIBUTE_LIGHT))
	--copy
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(65090044,0))
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e2:SetCountLimit(1)
	e2:SetCost(c65090044.cost)
	e2:SetOperation(c65090044.operation)
	c:RegisterEffect(e2)
end
function c65090044.costfil(c)
	return c:IsAbleToGraveAsCost() and c:IsSetCard(0xda6) and c:IsType(TYPE_FUSION) 
end
function c65090044.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c65090044.costfil,tp,LOCATION_EXTRA,0,1,nil) end
	local tc=Duel.SelectMatchingCard(tp,c65090044.costfil,tp,LOCATION_EXTRA,0,1,1,nil):GetFirst()
	e:SetLabelObject(tc)
	Duel.SendtoGrave(tc,REASON_COST)
end
function c65090044.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=e:GetLabelObject()
	if c:IsRelateToEffect(e) and c:IsFaceup() then
		local code=tc:GetOriginalCode()
		local atk=tc:GetAttack()
		local def=tc:GetDefense()
		local reset_flag=RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END 
		c:CopyEffect(code,reset_flag)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(reset_flag)
		e1:SetCode(EFFECT_CHANGE_CODE)
		e1:SetValue(code)
		c:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e2:SetReset(reset_flag)
		e2:SetCode(EFFECT_SET_ATTACK_FINAL)
		e2:SetValue(atk)
		c:RegisterEffect(e2)
		local e3=e2:Clone()
		e3:SetCode(EFFECT_SET_DEFENSE_FINAL)
		e3:SetValue(def)
		c:RegisterEffect(e3)
	end
end