--異端なる冥獣
local m=17090015
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
	--reflect damage
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_REFLECT_DAMAGE)
	e3:SetRange(LOCATION_PZONE)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetTargetRange(1,0)
	e3:SetCondition(cm.limcon)
	e3:SetValue(cm.refcon)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EFFECT_REFLECT_BATTLE_DAMAGE)
	e4:SetValue(1)
	c:RegisterEffect(e4)
	--summon success
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e5:SetCode(EVENT_SPSUMMON_SUCCESS)
	e5:SetOperation(cm.sumsuc)
	c:RegisterEffect(e5)
	--atk limit
    local e6=Effect.CreateEffect(c)
    e6:SetType(EFFECT_TYPE_FIELD)
    e6:SetRange(LOCATION_MZONE)
    e6:SetTargetRange(0,LOCATION_MZONE)
    e6:SetCode(EFFECT_CANNOT_SELECT_BATTLE_TARGET)
    e6:SetValue(cm.atlimit)
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
function cm.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetFlagEffect(tp,114514)>0
	and Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0
end
function cm.cfilter(c)
	return c:IsFaceup() and c:IsCode(17090009)
end
function cm.limcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(cm.cfilter,e:GetHandlerPlayer(),LOCATION_ONFIELD,0,1,nil)
end
function cm.refcon(e,re,val,r,rp,rc)
	return bit.band(r,REASON_EFFECT)~=0
end
function cm.sumsuc(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_MZONE,LOCATION_MZONE,c)
	if g:GetCount()>0 then
		local ct=Duel.Destroy(g,REASON_EFFECT)
		Duel.Damage(tp,ct*1000,REASON_EFFECT)
	end
end
function cm.atlimit(e,c)
    return c~=e:GetHandler()
end