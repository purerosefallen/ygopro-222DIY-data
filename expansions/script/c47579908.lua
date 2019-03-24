--天司长 圣德芬
function c47579908.initial_effect(c)
	c:SetSPSummonOnce(47579908)
	--pendulum summon
	aux.EnablePendulumAttribute(c,false)
	--synchro summon
	aux.AddSynchroProcedure(c,aux.FilterBoolFunction(c47579908.synfilter),aux.NonTuner(c47579908.synfilter2),2)
	c:EnableReviveLimit() 
	--cannot special summon
	local e0=Effect.CreateEffect(c)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_SPSUMMON_CONDITION)
	e0:SetValue(aux.synlimit)
	c:RegisterEffect(e0) 
	--indes
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_IMMUNE_EFFECT)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(c47579908.inmcon)
	e1:SetValue(c47579908.efilter)
	c:RegisterEffect(e1)
	--Ain Soph Aur
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(47579908,0))
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_ATTACK_ANNOUNCE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,47579908+EFFECT_COUNT_CODE_OATH)
	e2:SetCondition(c47579908.batcon)
	e2:SetOperation(c47579908.batop)
	c:RegisterEffect(e2)
	--pendulum
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_LEAVE_FIELD)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCondition(c47579908.pencon)
	e3:SetTarget(c47579908.pentg)
	e3:SetOperation(c47579908.penop)
	c:RegisterEffect(e3)
	--immune
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_IMMUNE_EFFECT)
	e4:SetRange(LOCATION_PZONE)
	e4:SetTargetRange(LOCATION_MZONE,0)
	e4:SetTarget(aux.TargetBoolFunction(Card.IsRace,RACE_FAIRY))
	e4:SetValue(c47579908.efilter)
	c:RegisterEffect(e4)
	--spsummon bgm
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e5:SetCode(EVENT_SPSUMMON_SUCCESS)
	e5:SetOperation(c47579908.spsuc)
	c:RegisterEffect(e5)
	--pierce
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_SINGLE)
	e6:SetCode(EFFECT_PIERCE)
	e6:SetRange(LOCATION_MZONE)
	c:RegisterEffect(e6)
end
function c47579908.synfilter(c)
	return c:IsRace(RACE_FAIRY) and c:IsType(TYPE_SYNCHRO) and c:IsType(TYPE_TUNER)
end
function c47579908.synfilter2(c)
	return c:IsRace(RACE_FAIRY) and c:IsType(TYPE_SYNCHRO+TYPE_FUSION)
end
function c47579908.inmcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_SYNCHRO)
end
function c47579908.efilter(e,te)
	return te:GetOwner()~=e:GetOwner()
end
function c47579908.batcon(e,tp,eg,ep,ev,re,r,rp)
	return (e:GetHandler()==Duel.GetAttacker() and Duel.GetAttackTarget()~=nil) or e:GetHandler()==Duel.GetAttackTarget()
end
function c47579908.atkfilter(c)
	return c:IsFaceup() and c:IsRace(RACE_FAIRY) and not c:IsCode(47579908)
end
function c47579908.batop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(c47579908.atkfilter,tp,LOCATION_MZONE,0,nil)
	local atk=g:GetSum(Card.GetAttack)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END+RESET_OPPO_TURN)
	e1:SetValue(atk)
	c:RegisterEffect(e1)
	Duel.Hint(HINT_SOUND,0,aux.Stringid(47579908,2))
end
function c47579908.indestg(e,c)
	return c==e:GetHandler():GetBattleTarget()
end
function c47579908.pencon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsFaceup() and c:IsSummonType(SUMMON_TYPE_SYNCHRO)
end
function c47579908.filter(c,e,tp)
	return c:IsCode(47551000) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c47579908.pentg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCountFromEx(tp)>0
		and Duel.IsExistingMatchingCard(c47579908.filter,tp,LOCATION_EXTRA,0,1,nil,e,tp) and Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c47579908.penop(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.CheckLocation(tp,LOCATION_PZONE,0) and not Duel.CheckLocation(tp,LOCATION_PZONE,1) then return false end
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.MoveToField(c,tp,tp,LOCATION_SZONE,POS_FACEUP,true) then
	if Duel.GetLocationCountFromEx(tp)<=0 then return end
		local tg=Duel.GetFirstMatchingCard(c47579908.filter,tp,LOCATION_EXTRA,0,nil,e,tp)
		if tg then
			Duel.SpecialSummon(tg,0,tp,tp,false,false,POS_FACEUP)
		end   
	end
end
function c47579908.efilter(e,te)
	return te:GetOwnerPlayer()~=e:GetHandlerPlayer() and te:IsActiveType(TYPE_MONSTER)
end
function c47579908.spsuc(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_MUSIC,0,aux.Stringid(47579908,2))
end 