--量子驱动组装
function c10130012.initial_effect(c)
	--effect
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(10130012,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,10130012+EFFECT_COUNT_CODE_OATH)
	e1:SetHintTiming(0,TIMING_BATTLE_PHASE+TIMING_END_PHASE)
	e1:SetCost(c10130012.cost)
	e1:SetTarget(c10130012.target)
	e1:SetOperation(c10130012.operation)
	c:RegisterEffect(e1)  
end
function c10130012.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(100)
	return true
end
function c10130012.spfilter(c,e,tp,tid)
	return c:IsSetCard(0xa336) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEDOWN_DEFENSE) and (not tid or (c:GetTurnID()==tid and c:IsPreviousLocation(LOCATION_ONFIELD)))
end
function c10130012.spcfilter(c,e,tp,tid,bool)
	if not Duel.IsExistingTarget(c10130012.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp,tid) then return false end
	if bool then return 
	   c:IsAbleToDeckAsCost() and ((c:IsLocation(LOCATION_MZONE) and Duel.GetLocationCount(tp,LOCATION_MZONE)>-1) or (c:IsLocation(LOCATION_HAND+LOCATION_SZONE) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0))
	else return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
	end
end
function c10130012.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_GRAVE) and c10130012.spfilter(chkc,e,tp,Duel.GetTurnCount()) end
	if chk==0 then 
	   local bool=false
	   if e:GetLabel()==100 then bool=true end
	   local b1=Duel.IsExistingMatchingCard(c10130012.spfilter,tp,LOCATION_HAND,0,1,nil,e,tp,false) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
	   local b2=Duel.IsExistingMatchingCard(c10130012.spcfilter,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,nil,e,tp,Duel.GetTurnCount(),bool)
	   local sel=0
	   if b1 then sel=sel+1 end
	   if b2 then sel=sel+2 end
	   e:SetValue(sel)
	   return sel~=0
	end
	local sel,turn,bool=e:GetValue(),Duel.GetTurnCount(),false
	if sel==3 then
		sel=Duel.SelectOption(tp,aux.Stringid(10130012,1),aux.Stringid(10130012,2))+1
	elseif sel==1 then
		Duel.SelectOption(tp,aux.Stringid(10130012,1))
	else
		Duel.SelectOption(tp,aux.Stringid(10130012,2))
	end
	e:SetValue(sel)
	if sel==1 then
		e:SetProperty(0)
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
	else
		if e:GetLabel()==100 then
		   e:SetLabel(0)
		   Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
		   local dg=Duel.SelectMatchingCard(tp,c10130012.spcfilter,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,1,nil,e,tp,turn,true)
		   Duel.SendtoDeck(dg,nil,2,REASON_COST)
		end
		e:SetProperty(EFFECT_FLAG_CARD_TARGET)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
		local sg=Duel.SelectTarget(tp,c10130012.spfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp,turn)
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,sg,sg:GetCount(),0,LOCATION_GRAVE)
	end
end
function c10130012.operation(e,tp,eg,ep,ev,re,r,rp)
	local sel,ct,c,tc=e:GetValue(),0,e:GetHandler()
	e:SetValue(0)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	if sel==1 then
	   Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	   tc=Duel.SelectMatchingCard(tp,c10130012.spfilter,tp,LOCATION_HAND,0,1,1,nil,e,tp):GetFirst()
	   if tc and Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEDOWN_DEFENSE)~=0 then ct=1 end
	else
	   tc=Duel.GetFirstTarget()
	   if tc:IsRelateToEffect(e) and Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEDOWN_DEFENSE)~=0 then ct=1 end
	end
	if ct==1 then
	   Duel.ConfirmCards(1-tp,tc)
	   local sg=Duel.GetMatchingGroup(c10130012.ssfilter,tp,LOCATION_MZONE,0,nil)
	   Duel.ShuffleSetCard(sg)
	   Duel.BreakEffect()
	   c:CancelToGrave()
	   Duel.ChangePosition(c,POS_FACEDOWN)
	   Duel.RaiseEvent(c,EVENT_SSET,e,REASON_EFFECT,tp,tp,0)
	end
end
function c10130012.ssfilter(c)
	return c:IsFacedown() and c:GetSequence()<5
end