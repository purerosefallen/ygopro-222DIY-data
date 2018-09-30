--星之骑士拟身 复制
function c65090016.initial_effect(c)
	--fusion material
	c:SetSPSummonOnce(65090016)
	c:EnableReviveLimit()
	aux.AddFusionProcCodeFun(c,65090001,aux.FilterBoolFunction(Card.IsSetCard,0x6da6),1,true,true)
	--copy
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_MZONE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetCost(c65090016.cost)
	e1:SetTarget(c65090016.target)
	e1:SetOperation(c65090016.activate)
	c:RegisterEffect(e1)
end
function c65090016.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsReleasable() end
	Duel.Release(e:GetHandler(),REASON_COST)
end
function c65090016.filter(c,e,tp)
	local att=c:GetAttribute()
	local race=c:GetRace()
	return c:IsFaceup() and Duel.IsExistingMatchingCard(c65090016.fufil,tp,LOCATION_EXTRA,0,1,nil,e,tp,att,race)
end
function c65090016.fufil(c,e,tp,att,race)
	return c:IsType(TYPE_FUSION) and c:IsLevelBelow(8)
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION,tp,false,false) and c:CheckFusionMaterial() and (c:IsAttribute(att) or c:IsRace(race)) and c:IsSetCard(0x3da6)
end
function c65090016.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c65090016.filter(chkc,e,tp) and chkc~=e:GetHandler() end
	if chk==0 then return Duel.GetLocationCountFromEx(tp,tp,e:GetHandler())>0
		and Duel.IsExistingTarget(c65090016.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,e:GetHandler(),e,tp) end
	local g=Duel.SelectTarget(tp,c65090016.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,e:GetHandler(),e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c65090016.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCountFromEx(tp)<=0 then return end
	local mc=Duel.GetFirstTarget()
	local att=mc:GetAttribute()
	local race=mc:GetRace()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c65090016.fufil,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,att,race)
	local tc=g:GetFirst()
	if not tc then return end
	tc:SetMaterial(nil)
	if Duel.SpecialSummon(tc,SUMMON_TYPE_FUSION,tp,tp,false,false,POS_FACEUP)~=0 then
		tc:CompleteProcedure()
		local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e2:SetCode(EVENT_PHASE+PHASE_END)
		e2:SetCountLimit(1)
		e2:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
		e2:SetLabelObject(tc)
		e2:SetCondition(c65090016.descon)
		e2:SetOperation(c65090016.desop)
		Duel.RegisterEffect(e2,tp)
	end
end
function c65090016.descon(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	if tc:GetFlagEffect(65090016)~=0 then
		return true
	else
		e:Reset()
		return false
	end
end
function c65090016.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	Duel.SendtoDeck(tc,nil,2,REASON_EFFECT)
end