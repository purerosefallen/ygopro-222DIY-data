--IDOL金曲 禁忌的二人
function c14804856.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,14804856+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(c14804856.condition)
	e1:SetTarget(c14804856.target)
	e1:SetOperation(c14804856.activate)
	c:RegisterEffect(e1)
	--indes
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetValue(1)
	e2:SetTarget(c14804856.imtg)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_PRE_BATTLE_DAMAGE)
	e3:SetRange(LOCATION_SZONE)
	e3:SetValue(c14804856.damval)
	c:RegisterEffect(e3)
	
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetCode(EFFECT_REMAIN_FIELD)
	c:RegisterEffect(e5)
end
function c14804856.cfilter(c)
	return c:IsSetCard(0x4848)
end
function c14804856.condition(e,tp,eg,ep,ev,re,r,rp)
	return  Duel.IsExistingMatchingCard(c14804856.cfilter,tp,LOCATION_MZONE,0,2,nil)
end
function c14804856.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(1-tp,LOCATION_MZONE)>0 end
	e:GetHandler():SetTurnCounter(0)
	--destroy
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetCode(EVENT_PHASE+PHASE_END)
	e1:SetCountLimit(1)
	e1:SetRange(LOCATION_SZONE)
	e1:SetCondition(c14804856.descon)
	e1:SetOperation(c14804856.desop)
	e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END+RESET_OPPO_TURN,3)
	e:GetHandler():RegisterEffect(e1)
	e:GetHandler():RegisterFlagEffect(14804856,RESET_PHASE+PHASE_END+RESET_OPPO_TURN,0,1)
	c14804856[e:GetHandler()]=e1
end
function c14804856.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,0,LOCATION_MZONE,nil)
	local tc=g:GetFirst()
	while tc do
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_SET_DEFENSE_FINAL)
		e1:SetValue(0)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e1)
		tc=g:GetNext()
	end
end
function c14804856.descon(e,tp,eg,ep,ev,re,r,rp)
	return tp~=Duel.GetTurnPlayer()
end
function c14804856.desop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ct=c:GetTurnCounter()
   ct=ct+1
   c:SetTurnCounter(ct)
	if ct==1 then
		Duel.SendtoGrave(c,REASON_RULE)
		c:ResetFlagEffect(14804856)
	end
end

function c14804856.imtg(e,c)
	return c:IsSetCard(0x4848)
end

function c14804856.damval(e,re,val,r,rp,rc)
	return Duel.ChangeBattleDamage(tp,0)
end