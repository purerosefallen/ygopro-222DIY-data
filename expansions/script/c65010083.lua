--第八个是铜像
function c65010083.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_FZONE)
	e2:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e2:SetCode(EFFECT_CANNOT_CHANGE_POSITION)
	e2:SetTarget(c65010083.postg)
	e2:SetCondition(c65010083.poscon)
	c:RegisterEffect(e2)
	--battle target
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetRange(LOCATION_FZONE)
	e3:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e3:SetCode(EFFECT_CANNOT_SELECT_BATTLE_TARGET)
	e3:SetValue(c65010083.atlimit)
	c:RegisterEffect(e3)
	--act limit
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_CANNOT_ACTIVATE)
	e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e4:SetRange(LOCATION_FZONE)
	e4:SetTargetRange(1,1)
	e4:SetValue(c65010083.limval)
	c:RegisterEffect(e4)
end
function c65010083.postg(e,c)
	return c:GetBaseDefense()==0
end
function c65010083.poscon(e)
	return e:GetHandler():IsPosition(POS_FACEUP_ATTACK)
end
function c65010083.atlimit(e,c)
	return c:IsAttackPos() and c:GetBaseAttack()==0
end
function c65010083.limval(e,re,rp)
	local rc=re:GetHandler()
	local tp=rc:GetControler()
	return (rc:GetBaseAttack()==0 or rc:GetBaseDefense()==0) and re:IsActiveType(TYPE_MONSTER) and not rc:IsImmuneToEffect(e) and rc:IsLocation(LOCATION_HAND+LOCATION_GRAVE)
end