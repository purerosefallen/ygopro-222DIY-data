--夺宝奇兵·泽塔
function c10140009.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(10140009,0))
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c10140009.spcon)
	c:RegisterEffect(e1) 
	--xyzsummon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(10140009,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE+LOCATION_GRAVE)
	e2:SetHintTiming(TIMING_MAIN_END)
	e2:SetCountLimit(1,10140009)
	e2:SetCost(c10140009.xyzcost)
	e2:SetTarget(c10140009.xyztg)
	e2:SetOperation(c10140009.xyzop)
	c:RegisterEffect(e2)	
end
function c10140009.spfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x5333)
end
function c10140009.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c10140009.spfilter,tp,0,LOCATION_MZONE,1,nil)
end 
function c10140009.xyzfilter(c,mg)
	return c:IsXyzSummonable(mg,2,2) and c:IsType(TYPE_XYZ) 
end
function c10140009.xyzmfilter(c)
	return c:IsSetCard(0x5333) and c:IsFaceup() and not c:IsType(TYPE_TOKEN)
end
function c10140009.xyzcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost() end
	Duel.Remove(e:GetHandler(),POS_FACEUP_ATTACK,REASON_COST)
end
function c10140009.xyztg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(c10140009.xyzmfilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil) 
	if chk==0 then return g:GetCount()>=2 and Duel.IsExistingMatchingCard(c10140009.xyzfilter,tp,LOCATION_EXTRA,0,1,nil,g) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c10140009.xyzop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c10140009.xyzmfilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	if g:GetCount()<2 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local xyz=Duel.SelectMatchingCard(tp,c10140009.xyzfilter,tp,LOCATION_EXTRA,0,1,1,nil,g):GetFirst()
	if xyz then
	   Duel.XyzSummon(tp,xyz,g,2,2)
	end
end