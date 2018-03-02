--第10032次轮回
function c5012607.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,5012607)
	e1:SetCost(c5012607.cost)
	e1:SetTarget(c5012607.target)
	e1:SetOperation(c5012607.activate)
	c:RegisterEffect(e1)
	--act in hand
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e4:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	c:RegisterEffect(e4)
	--get
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(5012607,3))
	e5:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e5:SetType(EFFECT_TYPE_QUICK_O)
	e5:SetCode(EVENT_FREE_CHAIN)
	e5:SetRange(LOCATION_REMOVED)
	e5:SetCountLimit(1,5012607)
	e5:SetCondition(c5012607.condition)
	e5:SetCost(c5012607.spcost)
	e5:SetTarget(c5012607.sptg)
	e5:SetOperation(c5012607.spop)
	c:RegisterEffect(e5)
end
function c5012607.refilter(c)
	return (c:IsSetCard(0x250) or c:IsSetCard(0x25a)) and c:IsAbleToRemoveAsCost()
end
function c5012607.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c5012607.refilter,tp,LOCATION_ONFIELD+LOCATION_HAND,0,2,e:GetHandler()) end
	local g=Duel.SelectMatchingCard(tp,c5012607.refilter,tp,LOCATION_ONFIELD+LOCATION_HAND,0,2,2,e:GetHandler())
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c5012607.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	local g=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,g:GetCount(),0,0)
end
function c5012607.tdfilter(c)
	return c:IsAbleToHand() or c:IsAbleToDeck()
end
function c5012607.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	if g:GetCount()>0 and Duel.Remove(g,nil,REASON_EFFECT+REASON_TEMPORARY)>0 then
	local t1=Duel.GetMatchingGroupCount(nil,tp,LOCATION_REMOVED,0,nil)
	local t2=Duel.GetMatchingGroupCount(nil,tp,0,LOCATION_REMOVED,nil)
	if t1>t2 and Duel.IsExistingMatchingCard(c5012607.tdfilter,tp,LOCATION_REMOVED,0,1,nil) 
	and Duel.SelectYesNo(tp,aux.Stringid(5012607,0)) then
	local fc=Duel.SelectMatchingCard(tp,c5012607.tdfilter,tp,LOCATION_REMOVED,0,1,1,nil)
	if not fc:GetFirst():IsAbleToHand() or Duel.SelectYesNo(tp,aux.Stringid(5012607,1)) then
	Duel.SendtoDeck(fc,nil,2,REASON_EFFECT)
	else
	Duel.SendtoHand(fc,nil,REASON_EFFECT)
	end
	elseif t1==t2 then
	Duel.Draw(tp,2,REASON_EFFECT)
	Duel.Draw(1-tp,2,REASON_EFFECT)
	else
	local e0=Effect.CreateEffect(e:GetHandler())
	e0:SetType(EFFECT_TYPE_FIELD)
	e0:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e0:SetCode(EFFECT_CANNOT_ACTIVATE)
	e0:SetTargetRange(1,0)
	e0:SetValue(c5012607.aclimit)
	e0:SetReset(RESET_PHASE+PHASE_END,2)
	Duel.RegisterEffect(e0,tp)
	end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_PHASE+PHASE_END)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetLabelObject(g)
	e1:SetCountLimit(1)
	e1:SetOperation(c5012607.retop)
	Duel.RegisterEffect(e1,tp)
	g:KeepAlive()
   local e2=Effect.CreateEffect(e:GetHandler())
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CHANGE_DAMAGE)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetTargetRange(0,1)
	e2:SetValue(0)
	e2:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e2,tp)
	local e3=e2:Clone()
	e3:SetCode(EFFECT_NO_EFFECT_DAMAGE)
	e3:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e3,tp)
end
end
function c5012607.aclimit(e,re,tp)
	return not (re:GetHandler():IsSetCard(0x250) or re:GetHandler():IsSetCard(0x25a))
end
function c5012607.retop(e,tp,eg,ep,ev,re,r,rp)
   local g=e:GetLabelObject()
   local tc=g:GetFirst()
	while tc do
	if tc and tc:IsForbidden() or Duel.GetLocationCount(tp,LOCATION_MZONE)<=0  then 
	Duel.SendtoGrave(tc,REASON_RULE)
	else
	Duel.ReturnToField(tc)
	end 
	tc=g:GetNext()  
	end
	g:DeleteGroup()
end
function c5012607.cfilter(c)
	return c:IsFaceup() and (c:IsSetCard(0x250) or c:IsSetCard(0x25a))
end
function c5012607.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c5012607.cfilter,tp,LOCATION_ONFIELD,0,1,nil)
end
function c5012607.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsFaceup() end
	Duel.SendtoGrave(e:GetHandler(),POS_FACEUP,REASON_COST+REASON_RETURN)
end
function c5012607.spfilter(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,tp,true,true) and c:IsCode(5012613) and ((c:IsLocation(LOCATION_EXTRA) and Duel.GetLocationCountFromEx(tp)>0) or (not c:IsLocation(LOCATION_EXTRA) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0))
end
function c5012607.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c5012607.spfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED+LOCATION_EXTRA,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE+LOCATION_REMOVED+LOCATION_EXTRA)
end
function c5012607.spfilter2(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_SYNCHRO,tp,false,false,POS_FACEUP,1-tp) and c:IsCode(5012604) and ((c:IsLocation(LOCATION_EXTRA) and Duel.GetLocationCountFromEx(1-tp)>0) or (not c:IsLocation(LOCATION_EXTRA) and Duel.GetLocationCount(1-tp,LOCATION_MZONE)>0))
end
function c5012607.spop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c5012607.spfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED+LOCATION_EXTRA,0,1,1,nil,e,tp)
	if g:GetCount()>0 and Duel.SpecialSummon(g,0,tp,tp,true,true,POS_FACEUP)>0 and Duel.IsExistingMatchingCard(c5012607.spfilter2,tp,LOCATION_GRAVE+LOCATION_REMOVED+LOCATION_EXTRA,0,1,nil,e,tp) and
	Duel.SelectYesNo(tp,aux.Stringid(5012607,2)) then
	   local tg=Duel.SelectMatchingCard(tp,c5012607.spfilter2,tp,LOCATION_GRAVE+LOCATION_REMOVED+LOCATION_EXTRA,0,1,1,nil,e,tp)
	   Duel.SpecialSummon(tg,SUMMON_TYPE_SYNCHRO,tp,1-tp,false,false,POS_FACEUP)
	   tg:GetFirst():CompleteProcedure()
	end
end