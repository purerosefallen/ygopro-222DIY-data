--神匠的试炼
function c10126014.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(10126014,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,0x1c0)
	e1:SetCountLimit(1,10126014)
	e1:SetTarget(c10126014.target)
	e1:SetOperation(c10126014.operation)
	c:RegisterEffect(e1)
	--tribute
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(10126014,1))
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetHintTiming(0,0x1c0)
	e2:SetCountLimit(1,10126014)
	e2:SetCost(c10126014.tcost)
	e2:SetOperation(c10126014.top)
	c:RegisterEffect(e2)
end
function c10126014.tcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost() end
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
end
function c10126014.top(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EFFECT_RELEASE_REPLACE)
	e1:SetTarget(c10126014.reptg)
	e1:SetValue(c10126014.repval)
	e1:SetOperation(c10126014.repop)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c10126014.repfilter(c,tp)
	local rc,re=c:GetReasonCard(),c:GetReasonEffect()
	return c:IsLocation(LOCATION_HAND+LOCATION_ONFIELD) and ((c:IsReason(REASON_COST) and re and re:IsHasType(0x7e0) and re:GetHandler():IsSetCard(0x1335) and re:GetHandler():IsControler(tp)) or (c:IsReason(REASON_SUMMON+REASON_SPSUMMON) and rc and rc:IsSetCard(0x1335) and rc:IsControler(tp))) and c:GetFlagEffect(10126014)==0
end
function c10126014.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local count=eg:FilterCount(c10126014.repfilter,nil,tp)
		return Duel.IsExistingMatchingCard(Card.IsReleasable,tp,LOCATION_EXTRA+LOCATION_DECK,0,count,nil) and Duel.GetFlagEffect(tp,10126014)==0
	end
	if Duel.SelectYesNo(tp,aux.Stringid(10126014,3)) then
	   Duel.RegisterFlagEffect(tp,10126014,RESET_PHASE+PHASE_END,0,1)
	   local g=eg:Filter(c10126014.repfilter,nil,tp)
	   g:KeepAlive()
	   e:SetLabelObject(g)
	return true
	else return false
	end
end
function c10126014.sfilter(c)
	return c:IsLocation(LOCATION_HAND) and not c:IsPublic()
end
function c10126014.repop(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetLabelObject()
	local hg=g:Filter(c10126014.sfilter,nil)
	if hg:GetCount()>0 then
	   Duel.ConfirmCards(1-tp,hg)
	   Duel.ShuffleHand(tp)
	end
	local count=g:GetCount()
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(10126014,4))
	local rg=Duel.SelectMatchingCard(tp,Card.IsReleasable,tp,LOCATION_EXTRA+LOCATION_DECK,0,count,count,nil)
	for tc in aux.Next(rg) do
		tc:RegisterFlagEffect(10126014,RESET_EVENT+0x1fc0000+RESET_CHAIN,0,1)
	end
	--Duel.Release(rg,REASON_EFFECT)
	Duel.SendtoGrave(rg,REASON_EFFECT+REASON_RELEASE)
	e:Reset()
end
function c10126014.repval(e,c)
	return c10126014.repfilter(c,e:GetHandlerPlayer())
end
function c10126014.filter(c,e,tp)
	return c:IsSetCard(0x1335) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c10126014.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c10126014.filter,tp,LOCATION_GRAVE+LOCATION_HAND,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE+LOCATION_HAND)
end
function c10126014.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local tc=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c10126014.filter),tp,LOCATION_GRAVE+LOCATION_HAND,0,1,1,nil,e,tp):GetFirst()
	if tc and Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)~=0 and c:IsRelateToEffect(e) and Duel.SelectYesNo(tp,aux.Stringid(10126014,2)) then 
		Duel.Equip(tp,c,tc)
		c:CancelToGrave()
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_EQUIP_LIMIT)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetValue(1)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		c:RegisterEffect(e1)
	end
end