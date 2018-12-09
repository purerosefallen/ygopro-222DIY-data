--传说之魂 逐梦
function c33350012.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,c33350012.xyzfilter,1,3,nil,nil,99)
	c:EnableReviveLimit()  
	--actlimit
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetCode(EFFECT_CANNOT_ACTIVATE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(0,1)
	e2:SetValue(c33350012.aclimit)
	e2:SetCondition(c33350012.actcon)
	c:RegisterEffect(e2)   
	--cannot release
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_RELEASE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(0,1)
	e1:SetTarget(c33350012.rellimit)
	c:RegisterEffect(e1)
	--cannot direct attack
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCondition(c33350012.con)
	e3:SetCode(EFFECT_CANNOT_DIRECT_ATTACK)
	c:RegisterEffect(e3)
	--attack all
	local e4=Effect.CreateEffect(c)
	e4:SetCondition(c33350012.con)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_ATTACK_ALL)
	e4:SetValue(1)
	c:RegisterEffect(e4)
	--ATK Up
	local e5=Effect.CreateEffect(c)
	e5:SetCategory(CATEGORY_ATKCHANGE)
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e5:SetCode(EVENT_BATTLE_DESTROYING)
	e5:SetCondition(c33350012.con2)
	e5:SetOperation(c33350012.atkop)
	c:RegisterEffect(e5)
end
--c33350012.setname="TaleSouls"
function c33350012.con2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local bc=c:GetBattleTarget()
	if c33350012.con(e,tp,eg,ep,ev,re,r,rp) and aux.bdocon(e,tp,eg,ep,ev,re,r,rp) and bc:IsPreviousPosition(POS_FACEUP_ATTACK) and bc:IsAttackAbove(1) then
	   e:SetLabel(bc:GetAttack())
	   return true
	else return false 
	end
end
function c33350012.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsFaceup() then
		local atk=c:GetBaseAttack()+e:GetLabel()
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_SET_BASE_ATTACK)
		e1:SetValue(atk)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE)
		c:RegisterEffect(e1)
	end
end
function c33350012.con(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetOverlayGroup():IsExists(Card.IsCode,1,nil,33350002)
end
function c33350012.xyzfilter(c)
	return c.setname=="TaleSouls"
end
function c33350012.rellimit(e,c,tp,sumtp)
	return c==e:GetHandler()
end
function c33350012.aclimit(e,re,tp)
	return not re:GetHandler():IsImmuneToEffect(e)
end
function c33350012.actcon(e)
	return Duel.GetAttacker()==e:GetHandler() or Duel.GetAttackTarget()==e:GetHandler()
end

