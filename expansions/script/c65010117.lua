--瓶之骑士 蓝星武神
function c65010117.initial_effect(c)
	c:SetSPSummonOnce(65010117)
	--link summon
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0x5da0),3)
	c:EnableReviveLimit()
	--cannot activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CANNOT_ACTIVATE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(0,1)
	e1:SetValue(c65010117.aclimit)
	c:RegisterEffect(e1)
	--spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_MAIN_END)
	e2:SetCountLimit(1)
	e2:SetCost(c65010117.cost)
	e2:SetTarget(c65010117.tg)
	e2:SetOperation(c65010117.op)
	c:RegisterEffect(e2)
end
function c65010117.aclimit(e,re,tp)
	return re:GetActivateLocation()==LOCATION_MZONE and not re:GetHandler():IsSetCard(0x5da0) 
end
function c65010117.refil(c,e,tp)
	local sp=c:GetControler()
	return c:IsReleasable() and Duel.IsExistingMatchingCard(c65010117.spfil,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE,0,1,nil,e,tp,sp)
end
function c65010117.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c65010117.refil,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil,e,tp) end
	local g=Duel.SelectMatchingCard(tp,Card.IsReleasable,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	local tc=g:GetFirst()
	e:SetLabelObject(tc)
	Duel.Release(tc,REASON_COST)
end
function c65010117.spfil(c,e,tp,sp)
	return c:IsSetCard(0x5da0) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP,sp)
end
function c65010117.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE)
end
function c65010117.op(e,tp,eg,ep,ev,re,r,rp)
	local sp=e:GetLabelObject():GetPreviousControler()
	if Duel.GetLocationCount(sp,LOCATION_MZONE)>0 then return end
	local g=Duel.SelectMatchingCard(tp,c65010117.spfil,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil,e,tp,sp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,sp,false,false,POS_FACEUP)
	end
end