--貪欲なスコーピオン
local m=17090013
local cm=_G["c"..m]
function cm.initial_effect(c)
	c:EnableReviveLimit()
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(cm.spcon)
	c:RegisterEffect(e1)
	--splimit
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_NEGATE)
	e2:SetRange(LOCATION_PZONE)
	e2:SetTargetRange(1,0)
	e2:SetTarget(cm.splimit)
	c:RegisterEffect(e2)
	--actlimit
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetCode(EFFECT_CANNOT_ACTIVATE)
	e3:SetRange(LOCATION_PZONE)
	e3:SetTargetRange(0,1)
	e3:SetValue(cm.aclimit)
	e3:SetCondition(cm.limcon)
	c:RegisterEffect(e3)
	--direct attack
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_DIRECT_ATTACK)
	c:RegisterEffect(e4)
	--destroy
    local e5=Effect.CreateEffect(c)
    e5:SetCategory(CATEGORY_DESTROY)
    e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
    e5:SetCode(EVENT_BATTLED)
    e5:SetTarget(cm.target)
    e5:SetOperation(cm.operation)
    c:RegisterEffect(e5)
	--recover
	local e6=Effect.CreateEffect(c)
	e6:SetCategory(CATEGORY_RECOVER)
	e6:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e6:SetCode(EVENT_DAMAGE_STEP_END)
	e6:SetCondition(cm.rccon)
	e6:SetOperation(cm.rcop)
	c:RegisterEffect(e6)
	if not cm.global_flag then
		cm.global_flag=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_SPSUMMON_SUCCESS)
		ge1:SetOperation(cm.regop)
		Duel.RegisterEffect(ge1,0)
	end
end
function cm.regop(e,tp,eg,ep,ev,re,r,rp)
	for tc in aux.Next(eg) do
		if tc:IsCode(17090009) then
			Duel.RegisterFlagEffect(tc:GetSummonPlayer(),114514,0,0,0)
		end
	end
end
function cm.splimit(e,c,tp,sumtp,sumpos)
	return not c:IsSetCard(0x1709)
end
function cm.cfilter(c)
	return c:IsFaceup() and c:IsCode(17090009)
end
function cm.aclimit(e,re,tp)
	return not re:GetHandler():IsImmuneToEffect(e)
end
function cm.actcon(e)
	return Duel.GetAttacker()==e:GetHandler() or Duel.GetAttackTarget()==e:GetHandler()
end
function cm.atkfilter(c,tp)
	return c:IsFaceup() and c:IsControler(tp)
end
function cm.limcon(e,tp,eg,ep,ev,re,r,rp)
	local tp=e:GetHandlerPlayer()
	local a=Duel.GetAttacker()
	local d=Duel.GetAttackTarget()
	return Duel.IsExistingMatchingCard(cm.cfilter,e:GetHandlerPlayer(),LOCATION_ONFIELD,0,1,nil)
	and (a and cm.cfilter(a,tp)) or (d and cm.atkfilter(d,tp))
end
function cm.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetFlagEffect(tp,114514)>0
	and Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local tg=e:GetHandler():GetBattleTarget()
	if chk==0 then return tg and tg:IsRelateToBattle() end
	Duel.SetOperationInfo(0,CATEGORY_POSITION,tg,1,0,0)
end
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
	local bc=e:GetHandler():GetBattleTarget()
	if bc:IsRelateToBattle() and bc:IsFaceup() then
		Duel.Destroy(bc,REASON_EFFECT)
	end
end
function cm.rccon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler()==Duel.GetAttacker() and e:GetHandler():IsRelateToBattle()
end
function cm.rcop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Recover(tp,c:GetAttack(),REASON_EFFECT)
end