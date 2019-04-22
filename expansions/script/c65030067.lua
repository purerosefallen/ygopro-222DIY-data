--终景尽头的恶巢
function c65030067.initial_effect(c)
	 --synchro summon
	aux.AddSynchroProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0x6da2),aux.NonTuner(Card.IsSetCard,0x6da2),1)
	c:EnableReviveLimit()
	--effect gain
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(c65030067.regcon)
	e1:SetOperation(c65030067.regop)
	c:RegisterEffect(e1)
end
function c65030067.regcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_SYNCHRO)
end
function c65030067.regop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ct=c:GetMaterialCount()
	local ctt=c:GetMaterial():FilterCount(Card.IsType,nil,TYPE_SYNCHRO)
	if ct>=2 then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_UPDATE_DEFENSE)
		e1:SetRange(LOCATION_MZONE)
		e1:SetTargetRange(LOCATION_MZONE,0)
		e1:SetTarget(c65030067.e1tg)
		e1:SetValue(500)
		c:RegisterEffect(e1)
		c:RegisterFlagEffect(0,RESET_EVENT+EVENT_LEAVE_FIELD_P,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(65030067,0))
	end
	if ct>=3 then
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_FIELD)
		e2:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
		e2:SetRange(LOCATION_MZONE)
		e2:SetTargetRange(LOCATION_MZONE,0)
		e2:SetTarget(c65030067.e1tg)
		e2:SetValue(aux.tgoval)
		c:RegisterEffect(e2)
		c:RegisterFlagEffect(0,RESET_EVENT+EVENT_LEAVE_FIELD_P,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(65030067,1))
	end
	if ctt>=1 then
		--act limit
		local e3=Effect.CreateEffect(c)
		e3:SetCategory(CATEGORY_NEGATE)
		e3:SetType(EFFECT_TYPE_QUICK_O)
		e3:SetCode(EVENT_CHAINING)
		e3:SetRange(LOCATION_MZONE)
		e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
		e3:SetCountLimit(1)
		e3:SetCondition(c65030067.con)
		e3:SetCost(c65030067.cost)
		e3:SetTarget(c65030067.tg)
		e3:SetOperation(c65030067.op)
		c:RegisterEffect(e3)
		c:RegisterFlagEffect(0,RESET_EVENT+EVENT_LEAVE_FIELD_P,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(65030067,2))
	end
end
function c65030067.e1tg(e,c)
	return c:IsSetCard(0x6da2) and c:IsFaceup()
end
function c65030067.con(e,tp,eg,ep,ev,re,r,rp)
	return rp==1-tp and not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) and Duel.IsChainNegatable(ev)
end
function c65030067.costfil(c)
	return c:IsSetCard(0x6da2) and c:IsType(TYPE_SYNCHRO) and c:IsFaceup() and c:IsAbleToRemoveAsCost()
end
function c65030067.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(c65030067.costfil,tp,LOCATION_MZONE,0,1,c) end
	local tc=Duel.SelectMatchingCard(tp,c65030067.costfil,tp,LOCATION_MZONE,0,1,1,c):GetFirst()
	if Duel.Remove(tc,POS_FACEUP,REASON_COST+REASON_TEMPORARY)~=0 then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_PHASE+PHASE_END)
		e1:SetReset(RESET_PHASE+PHASE_END)
		e1:SetLabelObject(tc)
		e1:SetCountLimit(1)
		e1:SetOperation(c65030067.retop)
		Duel.RegisterEffect(e1,tp)
	end
end
function c65030067.retop(e,tp,eg,ep,ev,re,r,rp)
	Duel.ReturnToField(e:GetLabelObject())
end
function c65030067.tgfil(c,e,tp)
	return c:IsSetCard(0x6da2) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c65030067.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():GetFlagEffect(65030067)==0 end
	e:GetHandler():RegisterFlagEffect(65030067,RESET_CHAIN,0,1)
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
end
function c65030067.op(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateActivation(ev)
	if re:IsHasType(EFFECT_TYPE_ACTIVATE) then
		Duel.SendtoGrave(re:GetHandler(),REASON_RULE)
	end
end
