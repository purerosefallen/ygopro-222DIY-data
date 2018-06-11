--苍之御龙骑士王
function c11115018.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0x115e),aux.NonTuner(c11115018.sfilter),1)
	c:EnableReviveLimit()
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(aux.synlimit)
	c:RegisterEffect(e1)
	--cannot be target
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetValue(1)
	c:RegisterEffect(e2)
	--activate limit
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e3:SetCode(EVENT_CHAINING)
	e3:SetRange(LOCATION_MZONE)
	e3:SetOperation(c11115018.aclimit1)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e4:SetCode(EFFECT_CANNOT_ACTIVATE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetTargetRange(1,0)
	e4:SetCondition(c11115018.econ1)
	e4:SetValue(c11115018.elimit)
	c:RegisterEffect(e4)
	local e5=e3:Clone()
	e5:SetOperation(c11115018.aclimit2)
	c:RegisterEffect(e5)
	local e6=e4:Clone()
	e6:SetCondition(c11115018.econ2)
	e6:SetTargetRange(0,1)
	c:RegisterEffect(e6)
	--extra to grave
	local e8=Effect.CreateEffect(c)
	e8:SetDescription(aux.Stringid(11115017,0))
	e8:SetCategory(CATEGORY_TOGRAVE)
	e8:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e8:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e8:SetCode(EVENT_LEAVE_FIELD)
	e8:SetCondition(c11115018.gycon)
	e8:SetTarget(c11115018.gytg)
	e8:SetOperation(c11115018.gyop)
	c:RegisterEffect(e8)
	--spsummon count limit
	local e9=e3:Clone()
	e9:SetCode(EVENT_SPSUMMON_SUCCESS)
	e9:SetOperation(c11115018.aclimit3)
	c:RegisterEffect(e9)
	local e10=Effect.CreateEffect(c)
	e10:SetType(EFFECT_TYPE_FIELD)
	e10:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e10:SetRange(LOCATION_MZONE)
	e10:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e10:SetTargetRange(1,0)
    e10:SetCondition(c11115018.econ3)
	c:RegisterEffect(e10)
	local e11=e10:Clone()
	e11:SetTargetRange(0,1)
	e11:SetCondition(c11115018.econ4)
	c:RegisterEffect(e11)
	local e12=e3:Clone()
	e12:SetOperation(c11115018.aclimit4)
	c:RegisterEffect(e12)
	local e13=e4:Clone()
	e13:SetCondition(c11115018.econ5)
	e13:SetValue(c11115018.elimit2)
	c:RegisterEffect(e13)
	local e14=e4:Clone()
	e14:SetTargetRange(0,1)
	e14:SetCondition(c11115018.econ6)
	e14:SetValue(c11115018.elimit2)
	c:RegisterEffect(e14)
	local e15=e3:Clone()
	e15:SetCode(EVENT_CHAIN_NEGATED)
	e15:SetOperation(c11115018.aclimit5)
	c:RegisterEffect(e15)
	local e16=e3:Clone()
	e16:SetCode(EVENT_CHAIN_SOLVED)
	e16:SetOperation(c11115018.aclimit6)
	c:RegisterEffect(e16)
	local e17=e3:Clone()
	e17:SetCode(EVENT_SPSUMMON)
	e17:SetOperation(c11115018.aclimit3)
	c:RegisterEffect(e17)
end
function c11115018.sfilter(c)
	return c:IsSetCard(0xa15e) and c:IsType(TYPE_SYNCHRO)
end
function c11115018.aclimit1(e,tp,eg,ep,ev,re,r,rp)
	if ep~=tp or not re:IsActiveType(TYPE_MONSTER) then return end
	e:GetHandler():RegisterFlagEffect(11115018,RESET_EVENT+0x3ff0000+RESET_PHASE+PHASE_END,0,1)
end
function c11115018.aclimit2(e,tp,eg,ep,ev,re,r,rp)
	if ep==tp or not re:IsActiveType(TYPE_MONSTER) then return end
	e:GetHandler():RegisterFlagEffect(111150180,RESET_EVENT+0x3ff0000+RESET_PHASE+PHASE_END,0,1)
end
function c11115018.aclimit3(e,tp,eg,ep,ev,re,r,rp)
    if eg:IsContains(e:GetHandler()) then return end
	local tc=eg:GetFirst()
	local p=tc:GetSummonPlayer()
    if p==tp then 
	    e:GetHandler():RegisterFlagEffect(11115021,RESET_EVENT+0x3ff0000+RESET_PHASE+PHASE_END,0,1)
	else
	    e:GetHandler():RegisterFlagEffect(111150210,RESET_EVENT+0x3ff0000+RESET_PHASE+PHASE_END,0,1)
	end
end
function c11115018.aclimit4(e,tp,eg,ep,ev,re,r,rp)
	if not re:IsHasCategory(CATEGORY_SPECIAL_SUMMON) then return end
    if ep==tp then
	    e:GetHandler():RegisterFlagEffect(11115022,RESET_EVENT+0x3ff0000+RESET_PHASE+PHASE_END,0,1)
	else
	    e:GetHandler():RegisterFlagEffect(111150220,RESET_EVENT+0x3ff0000+RESET_PHASE+PHASE_END,0,1)
	end
end
function c11115018.aclimit5(e,tp,eg,ep,ev,re,r,rp)
	if not re:IsHasCategory(CATEGORY_SPECIAL_SUMMON) then return end
	if ep==tp then
	    e:GetHandler():ResetFlagEffect(11115022)
	else
	    e:GetHandler():ResetFlagEffect(111150220)
	end
end
function c11115018.aclimit6(e,tp,eg,ep,ev,re,r,rp)
	if not re:IsHasCategory(CATEGORY_SPECIAL_SUMMON) then return end
	if ep==tp then
	    e:GetHandler():RegisterFlagEffect(11115021,RESET_EVENT+0x3ff0000+RESET_PHASE+PHASE_END,0,1)
	else
	    e:GetHandler():RegisterFlagEffect(111150210,RESET_EVENT+0x3ff0000+RESET_PHASE+PHASE_END,0,1)
	end
end
function c11115018.econ1(e)
	return e:GetHandler():GetFlagEffect(11115018)~=0
end
function c11115018.econ2(e)
	return e:GetHandler():GetFlagEffect(111150180)~=0
end
function c11115018.econ3(e)
	return e:GetHandler():GetFlagEffect(11115021)~=0
end
function c11115018.econ4(e)
	return e:GetHandler():GetFlagEffect(111150210)~=0
end
function c11115018.econ5(e)
	return e:GetHandler():GetFlagEffect(11115022)~=0
end
function c11115018.econ6(e)
	return e:GetHandler():GetFlagEffect(111150220)~=0
end
function c11115018.elimit(e,re,tp)
	return re:IsActiveType(TYPE_MONSTER) and not re:GetHandler():IsImmuneToEffect(e)
end
function c11115018.elimit2(e,re,tp)
	return re:IsHasCategory(CATEGORY_SPECIAL_SUMMON)
end
function c11115018.gycon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return (c:IsReason(REASON_BATTLE) or (c:GetReasonPlayer()~=tp and c:IsReason(REASON_EFFECT)))
	    and c:IsPreviousPosition(POS_FACEUP)
end
function c11115018.tgfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsAbleToGrave()
end
function c11115018.gytg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c11115018.tgfilter,tp,LOCATION_EXTRA,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_EXTRA)
end
function c11115018.gyop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c11115018.tgfilter,tp,LOCATION_EXTRA,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoGrave(g,REASON_EFFECT)
	end
end