--夏川瞳美
function c81011007.initial_effect(c)
	--link summon
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,nil,3,3)
	--direct attack
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_DIRECT_ATTACK)
	e1:SetCondition(c81011007.dircon)
	c:RegisterEffect(e1)
	--battle damage to effect damage
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_BATTLE_DAMAGE_TO_EFFECT)
	c:RegisterEffect(e2)
	--actlimit
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetCode(EFFECT_CANNOT_ACTIVATE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTargetRange(0,1)
	e3:SetValue(c81011007.aclimit)
	e3:SetCondition(c81011007.actcon)
	c:RegisterEffect(e3)
end
function c81011007.dircon(e)
	return e:GetHandler():GetColumnGroupCount()==0
end
function c81011007.aclimit(e,re,tp)
	return not re:GetHandler():IsImmuneToEffect(e)
end
function c81011007.actcon(e)
	return Duel.GetAttacker()==e:GetHandler() or Duel.GetAttackTarget()==e:GetHandler()
end
