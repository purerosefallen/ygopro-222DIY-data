--S.T. 命运编织者
function c22270162.initial_effect(c)
	--link summon
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkRace,RACE_MACHINE),2,2)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(22270162,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,222701621)
	e1:SetTarget(c22270162.sptg)
	e1:SetOperation(c22270162.spop)
	c:RegisterEffect(e1)
	--spsummon2
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(22270162,1))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_GRAVE)
	e1:SetCountLimit(1,222701622)
	e1:SetCost(c22270162.spcost2)
	e1:SetTarget(c22270162.sptg2)
	e1:SetOperation(c22270162.spop2)
	c:RegisterEffect(e1)
end
c22270162.named_with_ShouMetsu_ToShi=1
function c22270162.IsShouMetsuToShi(c)
	local m=_G["c"..c:GetCode()]
	return m and m.named_with_ShouMetsu_ToShi
end
function c22270162.spfilter(c,e,tp,zone,code)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP,tp,zone) and c:IsCode(code)
end
function c22270162.disfilter(c,e,tp,zone)
	return c:IsDestructable() and c:IsRace(RACE_MACHINE) and Duel.IsExistingMatchingCard(c22270162.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp,zone,c:GetCode()) and c:IsLevelBelow(5)
end
function c22270162.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return zone~=0 and Duel.IsExistingMatchingCard(c22270162.disfilter,tp,LOCATION_HAND,0,1,nil,e,tp,zone) end

	Duel.Destroy(tc,REASON_COST)
	e:SetLabel(tc:GetCode())
end
function c22270162.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local zone=e:GetHandler():GetLinkedZone(tp)
	if chk==0 then
		return zone~=0 and Duel.IsExistingMatchingCard(c22270162.disfilter,tp,LOCATION_HAND,0,1,nil,e,tp,zone) end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,1,tp,LOCATION_HAND)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c22270162.spop(e,tp,eg,ep,ev,re,r,rp)
	local zone=e:GetHandler():GetLinkedZone(tp)
	local tc=Duel.SelectMatchingCard(tp,c22270162.disfilter,tp,LOCATION_HAND,0,1,1,nil,e,tp,zone):GetFirst()
	if (not tc) or Duel.Destroy(tc,REASON_EFFECT)<1 then return end
	local code=tc:GetCode()
	if zone==0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c22270162.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp,zone,code)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP,zone)
	end
end
function c22270162.rfilter(c,e)
	local tc=e:GetHandler()
	local g=Duel.GetFieldGroup(tp,LOCATION_GRAVE,0):Filter(Card.IsAbleToRemoveAsCost,nil):Filter(Card.IsRace,nil,RACE_MACHINE):Filter(Card.IsCode,nil,c:GetCode())
	if g:IsContains(c) then g:RemoveCard(c) end
	if g:IsContains(tc) then g:RemoveCard(tc) end
	return g:GetCount()>0
end
function c22270162.spcost2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return  Duel.IsExistingMatchingCard(c22270162.rfilter,tp,LOCATION_GRAVE,0,1,e:GetHandler(),e) end
	local rc=Duel.SelectMatchingCard(tp,c22270162.rfilter,tp,LOCATION_GRAVE,0,1,1,e:GetHandler(),e):GetFirst()
	local g=Duel.GetFieldGroup(tp,LOCATION_GRAVE,0):Filter(Card.IsAbleToRemoveAsCost,nil):Filter(Card.IsRace,nil,RACE_MACHINE):Filter(Card.IsCode,nil,rc:GetCode())
	if g:IsContains(e:GetHandler()) then g:RemoveCard(e:GetHandler()) end
	local rg=g:RandomSelect(tp,2)
	Duel.Remove(rg,POS_FACEUP,REASON_COST)
end
function c22270162.sptg2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c22270162.spop2(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsRelateToEffect(e) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
		if Duel.SpecialSummon(e:GetHandler(),0,tp,tp,false,false,POS_FACEUP)>0 then
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_CHANGE_LINK_MARKER_KOISHI)
			e1:SetReset(RESET_EVENT+0x47e0000)
			e1:SetValue(0x028)
			e:GetHandler():RegisterEffect(e1,true)
		end
	end
end