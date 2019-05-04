--一切的开始·爱米莉
function c81012032.initial_effect(c)
	c:EnableReviveLimit()
	aux.EnablePendulumAttribute(c)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,81012032)
	e1:SetCondition(c81012032.tkcon)
	e1:SetCost(c81012032.cost)
	e1:SetTarget(c81012032.tktg)
	e1:SetOperation(c81012032.tkop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCondition(c81012032.tscon)
	e2:SetCountLimit(1,81012932)
	c:RegisterEffect(e2)
	Duel.AddCustomActivityCounter(81012032,ACTIVITY_SPSUMMON,c81012032.counterfilter)
end
function c81012032.counterfilter(c)
	return c:IsRace(RACE_PYRO)
end
function c81012032.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetCustomActivityCount(81012032,tp,ACTIVITY_SPSUMMON)==0 end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c81012032.splimit)
	Duel.RegisterEffect(e1,tp)
end
function c81012032.splimit(e,c,sump,sumtype,sumpos,targetp,se)
	return not c:IsRace(RACE_PYRO)
end
function c81012032.tkcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_RITUAL)
end
function c81012032.tscon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_PENDULUM)
end
function c81012032.tktg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return not Duel.IsPlayerAffectedByEffect(tp,59822133)
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>1
		and Duel.IsPlayerCanSpecialSummonMonster(tp,81012999,0,0x4011,1550,1050,4,RACE_PYRO,ATTRIBUTE_FIRE) end
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,2,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,2,0,0)
end
function c81012032.tkop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.IsPlayerAffectedByEffect(tp,59822133) then return end
	if Duel.GetLocationCount(tp,LOCATION_MZONE)>1
		and Duel.IsPlayerCanSpecialSummonMonster(tp,81012999,0,0x4011,1550,1050,4,RACE_PYRO,ATTRIBUTE_FIRE) then
		for i=1,2 do
			local token=Duel.CreateToken(tp,81012999)
			Duel.SpecialSummonStep(token,0,tp,tp,false,false,POS_FACEUP)
		end
		Duel.SpecialSummonComplete()
	end
end
