--夺宝奇兵·克尔苏加德
function c10140017.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,nil,5,2)
	c:EnableReviveLimit() 
	--effect indestructable
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e1:SetValue(1)
	e1:SetCondition(c10140017.indcon)
	c:RegisterEffect(e1)
	--actlimit
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetCode(EFFECT_CANNOT_ACTIVATE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(0,1)
	e2:SetValue(c10140017.aclimit)
	e2:SetCondition(c10140017.actcon)
	c:RegisterEffect(e2)  
	--atk
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EFFECT_UPDATE_ATTACK)
	e3:SetValue(c10140017.atkval)
	c:RegisterEffect(e3)
end
function c10140017.indcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c10140017.cfilter,tp,LOCATION_ONFIELD,0,1,nil)
end
function c10140017.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x6333) and c:IsType(TYPE_SPELL+TYPE_TRAP)
end
function c10140017.atkval(e,c)
	return Duel.GetMatchingGroupCount(c10140017.cfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil)*700
end
function c10140017.aclimit(e,re,tp)
	return not re:GetHandler():IsImmuneToEffect(e)
end
function c10140017.actcon(e)
	return Duel.GetAttacker()==e:GetHandler() or Duel.GetAttackTarget()==e:GetHandler()
end
