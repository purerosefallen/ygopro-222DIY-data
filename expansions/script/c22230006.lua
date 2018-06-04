--瓦尔哈拉的神枪手
function c22230006.initial_effect(c)
	--IMMUNE
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_IMMUNE_EFFECT)
	e1:SetValue(c22230006.efilter)
	c:RegisterEffect(e1)
   -- EFFECT_CANNOT_BE_MATERIAL
   -- local e2=Effect.CreateEffect(c)
   -- e2:SetType(EFFECT_TYPE_SINGLE)
   -- e2:SetCode(EFFECT_CANNOT_BE_FUSION_MATERIAL)
   -- e2:SetRange(LOCATION_MZONE)
   -- e2:SetValue(1)
   -- c:RegisterEffect(e2)
   -- local e3=e2:Clone()
   -- e3:SetCode(EFFECT_CANNOT_BE_SYNCHRO_MATERIAL)
   -- c:RegisterEffect(e3)
   -- local e4=e2:Clone()
   -- e4:SetCode(EFFECT_CANNOT_BE_XYZ_MATERIAL)
   -- c:RegisterEffect(e4)
   -- local e5=e2:Clone()
   -- e5:SetCode(EFFECT_CANNOT_BE_LINK_MATERIAL)
   -- c:RegisterEffect(e5)
	--pierce
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_SINGLE)
	e6:SetCode(EFFECT_PIERCE)
	c:RegisterEffect(e6)
	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e7:SetCode(EVENT_PRE_BATTLE_DAMAGE)
	e7:SetCondition(c22230006.damcon)
	e7:SetOperation(c22230006.damop)
	c:RegisterEffect(e7)
	local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_SINGLE)
	e8:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e8:SetRange(LOCATION_MZONE)
	e8:SetCode(EFFECT_UPDATE_ATTACK)
	e8:SetCondition(c22230006.damcon2)
	e8:SetValue(1000)
	c:RegisterEffect(e8)
end
c22230006.named_with_Valhalla=1
function c22230006.IsValhalla(c)
	local m=_G["c"..c:GetCode()]
	return m and m.named_with_Valhalla
end
function c22230006.efilter(e,te)
	return te:GetOwner()~=e:GetOwner() and te:GetOwnerPlayer()==e:GetOwnerPlayer()
end
function c22230006.damcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return ep==1-tp and c==Duel.GetAttacker() and Duel.GetAttackTarget() and Duel.GetAttackTarget():IsDefensePos()
end
function c22230006.damop(e,tp,eg,ep,ev,re,r,rp)
	Duel.ChangeBattleDamage(ep,ev*2)
end
function c22230006.damcon2(e)
	local ph=Duel.GetCurrentPhase()
	local c=e:GetHandler()
	local bc=c:GetBattleTarget()
	return (ph==PHASE_DAMAGE or ph==PHASE_DAMAGE_CAL) and bc and bc:IsAttackPos()
end