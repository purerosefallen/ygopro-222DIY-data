--终景招致的腐朽
function c65030066.initial_effect(c)
   --synchro summon
	aux.AddSynchroProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0x6da2),aux.NonTuner(Card.IsSetCard,0x6da2),1)
	c:EnableReviveLimit()
	--effect gain
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(c65030066.regcon)
	e1:SetOperation(c65030066.regop)
	c:RegisterEffect(e1)
end
function c65030066.regcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_SYNCHRO)
end
function c65030066.regop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ct=c:GetMaterialCount()
	local ctt=c:GetMaterial():FilterCount(Card.IsType,nil,TYPE_SYNCHRO)
	if ct>=2 then
		 --actlimit
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e1:SetCode(EFFECT_CANNOT_ACTIVATE)
		e1:SetRange(LOCATION_MZONE)
		e1:SetTargetRange(0,1)
		e1:SetValue(c65030066.aclimit)
		e1:SetCondition(c65030066.actcon)
		c:RegisterEffect(e1)
		c:RegisterFlagEffect(0,RESET_EVENT+EVENT_LEAVE_FIELD_P,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(65030066,0))
	end
	if ct>=3 then
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e2:SetCode(EVENT_ATTACK_ANNOUNCE)
		e2:SetRange(LOCATION_MZONE)
		e2:SetCondition(c65030066.discon)
		e2:SetOperation(c65030066.disop)
		c:RegisterEffect(e2)
		c:RegisterFlagEffect(0,RESET_EVENT+EVENT_LEAVE_FIELD_P,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(65030066,1))
	end
	if ctt>=1 then
		--act limit
		local e3=Effect.CreateEffect(c)
		e3:SetCategory(CATEGORY_REMOVE)
		e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
		e3:SetCode(EVENT_REMOVE)
		e3:SetRange(LOCATION_MZONE)
		e3:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
		e3:SetCondition(c65030066.con)
		e3:SetTarget(c65030066.tg)
		e3:SetOperation(c65030066.op)
		c:RegisterEffect(e3)
		c:RegisterFlagEffect(0,RESET_EVENT+EVENT_LEAVE_FIELD_P,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(65030066,2))
	end
end
function c65030066.aclimit(e,re,tp)
	return re:IsHasType(EFFECT_TYPE_ACTIVATE)
end
function c65030066.actfil(c,tp)
	return c:IsControler(tp) and c:IsFaceup() and c:IsSetCard(0x6da2)
end
function c65030066.actcon(e)
	local a=Duel.GetAttacker()
	local b=Duel.GetAttackTarget()
	return (a and c65030066.actfil(a,tp)) or (b and c65030066.actfil(b,tp))
end
function c65030066.cfilter(c,tp)
	return c:IsFaceup() and c:IsSetCard(0x6da2) and c:IsControler(tp)
end
function c65030066.discon(e,tp,eg,ep,ev,re,r,rp)
	local c=Duel.GetAttacker()
	if not c then return false end
	return c and Duel.GetAttackTarget() and c65030066.cfilter(c,tp)
end
function c65030066.disop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetAttackTarget()
	c:CreateRelation(tc,RESET_EVENT+RESETS_STANDARD)
	local atk=tc:GetAttack()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SET_ATTACK_FINAL)
	e1:SetCondition(c65030066.discon2)
	e1:SetValue(atk/2)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
	tc:RegisterEffect(e1)
end
function c65030066.discon2(e)
	return e:GetOwner():IsRelateToCard(e:GetHandler())
end
function c65030066.confil(c,tp)
	return c:IsPreviousLocation(LOCATION_MZONE) and c:GetPreviousControler()==tp and c:IsSetCard(0x6da2)
end
function c65030066.con(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c65030066.confil,1,nil,tp)
end
function c65030066.tgfil(c)
	return c:IsFaceup() and c:IsAbleToRemove()
end
function c65030066.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c65030066.tgfil,tp,0,LOCATION_GRAVE+LOCATION_EXTRA,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,1-tp,LOCATION_GRAVE+LOCATION_EXTRA)
end
function c65030066.op(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.SelectMatchingCard(tp,c65030066.tgfil,tp,0,LOCATION_GRAVE+LOCATION_EXTR,1,1,nil)
	if g:GetCount()>0 then
		Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
	end
end
