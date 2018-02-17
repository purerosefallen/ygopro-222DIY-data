--幻层驱动 联动骨架
function c10130008.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(10130008,0))
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetCountLimit(1,10130008)
	e1:SetRange(LOCATION_GRAVE)
	e1:SetCost(c10130008.actcost)
	e1:SetTarget(c10130008.acttg)
	e1:SetOperation(c10130008.actop)
	c:RegisterEffect(e1)
	--set
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(10130008,1))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetRange(LOCATION_MZONE)
	e3:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetCountLimit(1,10130008)
	e3:SetHintTiming(0,TIMING_END_PHASE)
	e3:SetCost(c10130008.spcost)
	e3:SetTarget(c10130008.sptg)
	e3:SetOperation(c10130008.spop)
	c:RegisterEffect(e3)  
end
function c10130008.costfilter(c)
	return c:IsSetCard(0xa336) and c:IsAbleToDeckAsCost()
end
function c10130008.actcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToDeckAsCost()
		and Duel.IsExistingMatchingCard(c10130008.costfilter,tp,LOCATION_GRAVE,0,1,c) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c10130008.costfilter,tp,LOCATION_GRAVE,0,1,1,c)
	g:AddCard(c)
	Duel.SendtoDeck(g,nil,2,REASON_COST)
end
function c10130008.actfilter(c,tp)
	return c:IsSetCard(0xa336) and bit.band(c:GetType(),0x20004)==0x20004 and c:GetActivateEffect():IsActivatable(tp)
end
function c10130008.acttg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c10130008.actfilter,tp,LOCATION_DECK,0,1,nil,tp) end
end
function c10130008.actop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(10130008,3))
	local tc=Duel.SelectMatchingCard(tp,c10130008.actfilter,tp,LOCATION_DECK,0,1,1,nil,tp):GetFirst()
	if tc then
	   Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
	   local te=tc:GetActivateEffect()
	   local tep=tc:GetControler()
	   local cost=te:GetCost()
	   if cost then cost(te,tep,eg,ep,ev,re,r,rp,1) end
	end
end
function c10130008.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsReleasable() and c:IsFacedown() end
	Duel.Release(c,REASON_COST)
end
function c10130008.spfilter(c,e,tp)
	return c:IsSetCard(0xa336) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEDOWN_DEFENSE) and not c:IsCode(10130008)
end
function c10130008.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return not Duel.IsPlayerAffectedByEffect(tp,59822133) and Duel.GetLocationCount(tp,LOCATION_MZONE)>=1
		and Duel.IsExistingMatchingCard(c10130008.spfilter,tp,LOCATION_HAND,0,1,nil,e,tp)
		and Duel.IsExistingMatchingCard(c10130008.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,2,tp,LOCATION_HAND+LOCATION_DECK)
end
function c10130008.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.IsPlayerAffectedByEffect(tp,59822133) or Duel.GetLocationCount(tp,LOCATION_MZONE)<2 then return end
	local g1=Duel.GetMatchingGroup(c10130008.spfilter,tp,LOCATION_HAND,0,nil,e,tp)
	local g2=Duel.GetMatchingGroup(c10130008.spfilter,tp,LOCATION_DECK,0,nil,e,tp)
	if g1:GetCount()==0 or g2:GetCount()==0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sg1=g1:Select(tp,1,1,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sg2=g2:Select(tp,1,1,nil)
	sg1:Merge(sg2)
	if Duel.SpecialSummon(sg1,0,tp,tp,false,false,POS_FACEDOWN_DEFENSE)~=0 then
	   local og=Duel.GetOperatedGroup()
	   Duel.ConfirmCards(1-tp,og)
	   if Duel.SelectYesNo(tp,aux.Stringid(10130008,2)) then
		  Duel.BreakEffect()
		  local sg=Duel.GetMatchingGroup(c10130008.ssfilter,tp,LOCATION_MZONE,0,nil)
		  Duel.ShuffleSetCard(sg)
	   end
	end
end
function c10130008.ssfilter(c)
	return c:IsFacedown() and c:GetSequence()<5
end