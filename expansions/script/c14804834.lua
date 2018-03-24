--IDOL 会长
function c14804834.initial_effect(c)
	--link summon
	c:SetUniqueOnField(1,1,aux.FilterBoolFunction(Card.IsCode,14804834),LOCATION_MZONE)
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0x4848),3)
	c:EnableReviveLimit()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e1:SetTarget(c14804834.atktg)
	e1:SetValue(c14804834.atkval)
	c:RegisterEffect(e1)
	--boost
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetRange(LOCATION_ONFIELD)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetTarget(c14804834.atktg1)
	e2:SetValue(c14804834.atkval1)
	c:RegisterEffect(e2)
	--actlimit
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_ATTACK_ANNOUNCE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(c14804834.condition)
	e3:SetOperation(c14804834.actop)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EVENT_BE_BATTLE_TARGET)
	c:RegisterEffect(e4)
	--atkup
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(14804834,0))
	e5:SetCategory(CATEGORY_ATKCHANGE)
	e5:SetType(EFFECT_TYPE_IGNITION)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCountLimit(1)
	e5:SetTarget(c14804834.atktg2)
	e5:SetOperation(c14804834.atkop2)
	c:RegisterEffect(e5)
end
function c14804834.atktg(e,c)
	return not c:IsSetCard(0x4848)
end
function c14804834.vfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x4848)
end
function c14804834.atkval(e,c)
	return Duel.GetMatchingGroupCount(c14804834.vfilter,0,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)*-400
end
function c14804834.cfilter1(c)
	return c:IsSetCard(0x4848)
end
function c14804834.condition(e,tp,eg,ep,ev,re,r,rp)
	return  Duel.IsExistingMatchingCard(c14804834.cfilter1,tp,LOCATION_MZONE,0,4,nil)
end
function c14804834.actop(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CANNOT_ACTIVATE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(0,1)
	e1:SetValue(c14804834.aclimit)
	e1:SetReset(RESET_PHASE+PHASE_DAMAGE)
	Duel.RegisterEffect(e1,tp)
end
function c14804834.aclimit(e,re,tp)
	return re:IsActiveType(TYPE_TRAP+TYPE_SPELL+TYPE_MONSTER) and not re:GetHandler():IsImmuneToEffect(e)
end
function c14804834.atktg1(e,c)
	return c:IsSetCard(0x4848)
end
function c14804834.filter1(c)
	return c:IsFaceup() and c:IsSetCard(0x4848)
end
function c14804834.atkval1(e,c)
	return Duel.GetMatchingGroupCount(c14804834.filter1,c:GetControler(),LOCATION_ONFIELD,0,nil)*100
end
function c14804834.actop(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CANNOT_ACTIVATE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(0,1)
	e1:SetValue(c14804834.aclimit)
	e1:SetReset(RESET_PHASE+PHASE_DAMAGE)
	Duel.RegisterEffect(e1,tp)
end
function c14804834.aclimit(e,re,tp)
	return re:IsActiveType(TYPE_TRAP+TYPE_SPELL+TYPE_MONSTER) and not re:GetHandler():IsImmuneToEffect(e)
end
function c14804834.atkfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x4848)
end
function c14804834.atktg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c14804834.atkfilter,tp,LOCATION_MZONE,0,1,nil) end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_ATTACK)
	e1:SetProperty(EFFECT_FLAG_OATH)
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetTarget(c14804834.ftarget)
	e1:SetLabel(e:GetHandler():GetFieldID())
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c14804834.atkop2(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetHandler()
	if tc:IsFaceup() and tc:IsRelateToEffect(e) then
		local g=Duel.GetMatchingGroup(c14804834.atkfilter,tp,LOCATION_MZONE,0,nil)
		local atk=g:GetSum(Card.GetAttack)
		local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_UPDATE_ATTACK)
		e2:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END+RESET_OPPO_TURN)
		e2:SetValue(atk)
		tc:RegisterEffect(e2)
	end
end
function c14804834.ftarget(e,c)
	return e:GetLabel()~=c:GetFieldID()
end