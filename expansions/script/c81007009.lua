--TOZ·甜品店的Waitress
function c81007009.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcFunRep(c,c81007009.ffilter,3,false)
	--spsummon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(c81007009.splimit)
	c:RegisterEffect(e1)
	--special summon rule
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e2:SetRange(LOCATION_EXTRA)
	e2:SetCondition(c81007009.spcon)
	e2:SetTarget(c81007009.sptg)
	e2:SetOperation(c81007009.spop)
	c:RegisterEffect(e2)
	--unreleaseable nonsum
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EFFECT_UNRELEASABLE_NONSUM)
	e3:SetValue(1)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EFFECT_CANNOT_BE_FUSION_MATERIAL)
	c:RegisterEffect(e4)
	--special summon
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(81007009,1))
	e6:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e6:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e6:SetCode(EVENT_SPSUMMON_SUCCESS)
	e6:SetProperty(EFFECT_FLAG_DELAY)
	e6:SetRange(LOCATION_MZONE)
	e6:SetCountLimit(1,57282725)
	e6:SetCondition(c81007009.sscon)
	e6:SetTarget(c81007009.sstg)
	e6:SetOperation(c81007009.ssop)
	c:RegisterEffect(e6)
	--ritual material
	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_SINGLE)
	e7:SetCode(EFFECT_EXTRA_RITUAL_MATERIAL)
	e7:SetValue(c81007009.mtval)
	c:RegisterEffect(e7)
end
function c81007009.ffilter(c)
	return c:IsFusionType(TYPE_RITUAL) and c:IsType(TYPE_MONSTER)
end
function c81007009.splimit(e,se,sp,st)
	return not e:GetHandler():IsLocation(LOCATION_EXTRA) or aux.fuslimit(e,se,sp,st)
end
function c81007009.spfilter(c,fc)
	return c81007009.ffilter(c) and c:IsCanBeFusionMaterial(fc)
end
function c81007009.spcheck(g,tp)
	return Duel.GetLocationCountFromEx(tp,tp,g)>0
end
function c81007009.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local g=Duel.GetReleaseGroup(tp):Filter(c81007009.spfilter,nil,c)
	return g:CheckSubGroup(c81007009.spcheck,3,3,tp)
end
function c81007009.sptg(e,tp,eg,ep,ev,re,r,rp,check,c)
	local g=Duel.GetReleaseGroup(tp):Filter(c81007009.spfilter,nil,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local sg=g:SelectSubGroup(tp,c81007009.spcheck,true,3,3,tp)
	if sg then
		sg:KeepAlive()
		e:SetLabelObject(sg)
		return true
	else
		return false
	end
end
function c81007009.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local sg=e:GetLabelObject()
	c:SetMaterial(sg)
	Duel.Release(sg,REASON_COST+REASON_FUSION+REASON_MATERIAL)
	sg:DeleteGroup()
end
function c81007009.cnfilter(c,tp)
	return c:GetSummonPlayer()==tp and c:IsSummonType(SUMMON_TYPE_RITUAL)
end
function c81007009.sscon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c81007009.cnfilter,1,nil,1-tp)
end
function c81007009.ssfilter(c,e,tp)
	return c:IsSetCard(0x817) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c81007009.sstg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c81007009.ssfilter,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c81007009.ssop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c81007009.ssfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c81007009.mtval(e,c)
	return c:IsType(TYPE_PENDULUM)
end
