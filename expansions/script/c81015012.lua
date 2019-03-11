--思想者·北上丽花
function c81015012.initial_effect(c)
	--summon with no tribute
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(81015012,0))
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SUMMON_PROC)
	e1:SetCondition(c81015012.ntcon)
	e1:SetValue(1)
	c:RegisterEffect(e1)
	--spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,81015012)
	e2:SetCondition(c81015012.condition)
	e2:SetCost(c81015012.spcost)
	e2:SetTarget(c81015012.sptg)
	e2:SetOperation(c81015012.spop)
	c:RegisterEffect(e2)
	Duel.AddCustomActivityCounter(81015012,ACTIVITY_SPSUMMON,c81015012.counterfilter)
end
function c81015012.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x81a)
end
function c81015012.ntcon(e,c,minc)
	if c==nil then return true end
	return minc==0 and c:IsLevelAbove(5) and Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c81015012.cfilter,c:GetControler(),LOCATION_MZONE,0,1,nil)
end
function c81015012.sfilter(c)
	return c:GetSequence()<5
end
function c81015012.condition(e,tp,eg,ep,ev,re,r,rp)
	return not Duel.IsExistingMatchingCard(c81015012.sfilter,tp,LOCATION_SZONE,0,1,nil)
end
function c81015012.counterfilter(c)
	return c:IsSetCard(0x81a)
end
function c81015012.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsReleasable()
		and Duel.GetCustomActivityCount(81015012,tp,ACTIVITY_SPSUMMON)==0 end
	Duel.Release(e:GetHandler(),REASON_COST)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c81015012.splimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end 
function c81015012.splimit(e,c,sump,sumtype,sumpos,targetp,se)
	return not c:IsSetCard(0x81a)
end
function c81015012.spfilter(c,e,tp)
	return c:IsSetCard(0x81a) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c81015012.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>-1
		and Duel.IsExistingMatchingCard(c81015012.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end 
function c81015012.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c81015012.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end