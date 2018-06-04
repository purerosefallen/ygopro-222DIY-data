--小恶魔 希尔提丝
function c12009014.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_PZONE)
	e2:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e2:SetValue(c12009014.efilter)
	c:RegisterEffect(e2)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(12009014,0))
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCountLimit(1,12009014)
	e1:SetCondition(c12009014.spcon)
	c:RegisterEffect(e1)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(12009014,1))
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_CHAINING)
	e1:SetCountLimit(1,12009014)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c12009014.recon)
	e1:SetTarget(c12009014.reptg)
	e1:SetOperation(c12009014.reop)
	c:RegisterEffect(e1)
end
function c12009014.efilter(e,te)
	return te:IsActiveType(TYPE_MONSTER)
end
function c12009014.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return (Duel.CheckLocation(1-tp,LOCATION_PZONE,0) or Duel.CheckLocation(1-tp,LOCATION_PZONE,1))
	end 
end
function c12009014.recon(e,tp,eg,ep,ev,re,r,rp)
	return ep==1-tp and  re:IsHasType(EFFECT_TYPE_ACTIVATE) and re:IsActiveType(TYPE_SPELL)
		and Duel.IsChainNegatable(ev)
end
function c12009014.reop(e,tp,eg,ep,ev,re,r,rp)
	 if not e:GetHandler():IsRelateToEffect(e) then return end
	 Duel.MoveToField(e:GetHandler(),tp,1-tp,LOCATION_SZONE,POS_FACEUP,true)
end
function c12009014.spcon(e,tp,eg,ep,ev,re,r,rp)
	local tp=e:GetHandler():GetControler()
	local tc1=Duel.GetFieldCard(tp,LOCATION_PZONE,0)
	local tc2=Duel.GetFieldCard(tp,LOCATION_PZONE,1)
	if not tc1 or not tc2 then return false end
	return ( tc1:GetLeftScale()==3 or tc1:GetLeftScale()==4 or tc1:GetLeftScale()==5 ) and
		  ( tc2:GetRightScale()==3 or tc2:GetRightScale()==4 or 
  tc2:GetRightScale()==5 )
end