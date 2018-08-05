--元素·火符『Angi Radiance』
function c15415169.initial_effect(c)
	c:EnableCounterPermit(0x16f)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)	   
	--damage
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_DAMAGE)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCode(EVENT_BATTLE_DAMAGE)
	e3:SetCountLimit(2,15415169)
	e3:SetCondition(c15415169.damcon1)
	e3:SetOperation(c15415169.damop)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EVENT_DAMAGE)
	e4:SetCondition(c15415169.damcon2)
	c:RegisterEffect(e4)
end
function c15415169.damcon1(e,tp,eg,ep,ev,re,r,rp)
	return ep~=tp and Duel.GetLP(1-tp)>0
end
function c15415169.damcon2(e,tp,eg,ep,ev,re,r,rp)
	return ep~=tp and Duel.GetLP(1-tp)>0 and bit.band(r,REASON_BATTLE)==0 and re
		and re:IsActiveType(TYPE_MONSTER+TYPE_SPELL+TYPE_TRAP) 
end
function c15415169.damop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetCounter(tp,1,0,0x16f)*100
	Duel.Damage(1-tp,g,REASON_EFFECT)
end