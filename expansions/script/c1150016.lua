--古老的薰香
function c1150016.initial_effect(c)
--
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,1150016+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c1150016.tg1)
	e1:SetOperation(c1150016.op1)
	c:RegisterEffect(e1)   
--
end
--
function c1150016.tg1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return true end
	local sg=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_MZONE,nil)
	if sg:GetCount()>2 then
	   Duel.SetChainLimit(c1150016.limit1)
	end
end
function c1150016.limit1(e,ep,tp)
	return not (tp~=ep and e:IsActiveType(TYPE_MONSTER))
end
--
function c1150016.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
--
	local e1_1=Effect.CreateEffect(c)
	e1_1:SetType(EFFECT_TYPE_FIELD)
	e1_1:SetCode(EFFECT_IMMUNE_EFFECT)
	e1_1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	e1_1:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e1_1:SetReset(RESET_PHASE+PHASE_END)
	e1_1:SetTarget(c1150016.tg1_1)
	e1_1:SetValue(c1150016.val1_1)
	Duel.RegisterEffect(e1_1,tp)
--
	local e1_3=Effect.CreateEffect(c)
	e1_3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e1_3:SetCode(EVENT_BE_BATTLE_TARGET)
	e1_3:SetRange(LOCATION_MZONE)
	e1_3:SetOperation(c1150016.op1_3)
	local e1_2=Effect.CreateEffect(c)
	e1_2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
	e1_2:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e1_2:SetReset(RESET_PHASE+PHASE_END)
	e1_2:SetTarget(c1150016.tg1_2)
	e1_2:SetLabelObject(e1_3)
	Duel.RegisterEffect(e1_2,tp)
--
end
--
function c1150016.tg1_1(e,c)
	return c:IsType(TYPE_MONSTER)
end
function c1150016.val1_1(e,te)
	return te:GetOwner()~=e:GetOwner()
end
--
function c1150016.tg1_2(e,c)
	return c:IsType(TYPE_MONSTER)
end
function c1150016.op1_3(e,tp,eg,ep,ev,re,r,rp)
	local at=Duel.GetAttacker()
	if at:IsFaceup() then 
		Duel.Recover(e:GetHandler():GetControler(),at:GetAttack(),REASON_EFFECT)
	end
end
--
