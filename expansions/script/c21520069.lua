--玲珑导师-勇气导师
function c21520069.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0x495),aux.NonTuner(Card.IsRace,RACE_SPELLCASTER),1)
	c:EnableReviveLimit()
--[[	--special summon from grave
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(21520069,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCountLimit(1,21520069+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c21520069.sptg)
	e1:SetOperation(c21520069.spop)
	c:RegisterEffect(e1)--]]
	--atk up 
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(21520069,0))
	e1:SetCategory(CATEGORY_ATKCHANGE)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCountLimit(1,21520069+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c21520069.auptg)
	e1:SetOperation(c21520069.aupop)
	c:RegisterEffect(e1)
	--atk
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(21520069,1))
	e2:SetCategory(CATEGORY_ATKCHANGE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetHintTiming(TIMING_SPSUMMON+TIMING_DAMAGE_STEP+TIMING_DAMAGE_CAL)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,21520069+EFFECT_COUNT_CODE_OATH)
	e2:SetCost(c21520069.cost)
	e2:SetOperation(c21520069.atkop)
	c:RegisterEffect(e2)
	--Revive
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(21520069,2))
	e3:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_FIELD)
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetCode(EVENT_PHASE+PHASE_END)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetCountLimit(1)
	e3:SetTarget(c21520069.sumtg)
	e3:SetOperation(c21520069.sumop)
	c:RegisterEffect(e3)
end
--[[function c21520069.spfilter(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:IsSetCard(0x495)
end
function c21520069.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then 
		local g=Duel.GetMatchingGroup(c21520069.spfilter,tp,LOCATION_GRAVE,0,nil,e,tp)
		return g:CheckWithSumEqual(Card.GetLevel,6,2,2) and Duel.GetLocationCount(tp,LOCATION_MZONE)>1 end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,2,tp,LOCATION_GRAVE)
end
function c21520069.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(c21520069.spfilter,tp,LOCATION_GRAVE,0,nil,e,tp)
	if g:CheckWithSumEqual(Card.GetLevel,6,2,2) and Duel.GetLocationCount(tp,LOCATION_MZONE)>1 then 
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg=g:SelectWithSumEqual(tp,Card.GetLevel,6,2,2)
		local tc=sg:GetFirst()
		while tc do
			Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP)
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_CANNOT_BE_SYNCHRO_MATERIAL)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e1:SetValue(1)
			e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
			tc:RegisterEffect(e1)
			local e2=Effect.CreateEffect(c)
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetCode(EFFECT_CANNOT_TRIGGER)
			e2:SetReset(RESET_EVENT+0x1fe0000)
			tc:RegisterEffect(e2)
			tc=sg:GetNext()
		end
		Duel.SpecialSummonComplete()
	end
end--]]
function c21520069.aupfilter(c,e,tp)
	return c:IsFaceup() and c:IsSetCard(0x495) and c:IsType(TYPE_MONSTER)
end
function c21520069.auptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
end
function c21520069.aupop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(c21520069.aupfilter,tp,LOCATION_GRAVE,0,nil)
	local ag=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_MZONE,0,nil):Filter(Card.IsRace,nil,RACE_SPELLCASTER)
	if g:GetClassCount(Card.GetCode)>0 and ag:GetCount()>0 then 
		local tc=ag:GetFirst()
		while tc do
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_UPDATE_ATTACK)
			e1:SetValue(g:GetClassCount(Card.GetCode)*600)
			e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
			tc:RegisterEffect(e1)
			tc=ag:GetNext()
		end
	end
end
function c21520069.atkfilter(e,c)
	return c:IsRace(RACE_SPELLCASTER) and c:IsFaceup()
end
function c21520069.atkval(e,c)
	local label=e:GetLabel()
	return c:GetAttack()*label
end
function c21520069.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ct=Duel.GetMatchingGroupCount(Card.IsFaceup,tp,0,LOCATION_MZONE,nil)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SET_ATTACK_FINAL)
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetLabel(ct)
	e1:SetTarget(c21520069.atkfilter)
	e1:SetValue(c21520069.atkval)
	e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c21520069.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local b1=e:GetHandler():IsReleasable()
	if chk==0 then return b1 end
	Duel.Release(e:GetHandler(),REASON_COST)
	e:GetHandler():RegisterFlagEffect(21520069,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,0)
end
function c21520069.sumtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and c:GetFlagEffect(21520069)>0
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function c21520069.sumop(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsRelateToEffect(e) then
		Duel.SpecialSummon(e:GetHandler(),0,tp,tp,false,false,POS_FACEUP)
	end
end
