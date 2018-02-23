--圣谕圣灵 桃乐丝
function c10102014.initial_effect(c)
	--link summon
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,c10102014.matfilter,1,1) 
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EFFECT_RELEASE_REPLACE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTarget(c10102014.reptg)
	e1:SetValue(c10102014.repval)
	e1:SetOperation(c10102014.repop)
	c:RegisterEffect(e1)
	--spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(10102014,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetHintTiming(0,TIMING_END_PHASE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,10102014)
	e2:SetCost(c10102014.spcost)
	e2:SetTarget(c10102014.sptg)
	e2:SetOperation(c10102014.spop)
	c:RegisterEffect(e2) 
	c10102014[c]=e2 
end
function c10102014.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsReleasable() end
	Duel.Release(e:GetHandler(),REASON_COST)
end
function c10102014.spfilter(c,e,tp)
	return c:IsSetCard(0x9330) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c10102014.thfilter(c,code)
	return c:IsAbleToHand() and c:IsCode(code)
end
function c10102014.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c10102014.spfilter,tp,LOCATION_HAND,0,1,nil,e,tp) and Duel.GetLocationCount(tp,LOCATION_MZONE)>=0 end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,0,tp,LOCATION_GRAVE+LOCATION_DECK)
end
function c10102014.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c10102014.spfilter,tp,LOCATION_HAND,0,1,1,nil,e,tp)
	if g:GetCount()>0 and Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)~=0 and Duel.IsExistingMatchingCard(aux.NecroValleyFilter(c10102014.thfilter),tp,LOCATION_GRAVE+LOCATION_DECK,0,1,nil,g:GetFirst():GetCode()) and Duel.SelectYesNo(tp,aux.Stringid(10102014,2)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local tg=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c10102014.thfilter),tp,LOCATION_GRAVE+LOCATION_DECK,0,1,1,nil,g:GetFirst():GetCode())
		Duel.SendtoHand(tg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tg)
	end
end
function c10102014.matfilter(c)
	return c:IsLinkSetCard(0x9330) and c:IsLevelBelow(5)
end
function c10102014.rfilter(c)
	return c:IsReleasableByEffect() and not c:IsReason(REASON_REPLACE) and not c:IsReason(REASON_RELEASE)
end
function c10102014.repfilter(c,tp)
	return c:IsControler(tp) and c:IsSetCard(0x9330) and c:IsReason(REASON_COST) and c:GetReasonEffect() and c:GetReasonEffect():IsHasType(0x7e0) and c:GetFlagEffect(10120114)==0 and c:IsFaceup() and c:IsLocation(LOCATION_MZONE)
end
function c10102014.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local cg=c:GetLinkedGroup()
	if chk==0 then
	   return cg:GetCount()>0 and not (cg:Equal(eg)) and cg:FilterCount(c10102014.rfilter,nil)>0 and c:GetFlagEffect(10102014)==0 and eg:GetCount()==1
	end
	if Duel.SelectEffectYesNo(tp,e:GetHandler()) then
	   c:RegisterFlagEffect(10102014,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,1)
	return true
	else return false
	end
end
function c10102014.sfilter(c)
	return (c:IsLocation(LOCATION_HAND) and not c:IsPublic()) or c:IsFacedown()
end
function c10102014.repop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,10102014)
	local cg=e:GetHandler():GetLinkedGroup()
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(10102014,0))
	local tc=cg:FilterSelect(tp,c10102014.rfilter,1,1,nil):GetFirst()
	tc:RegisterFlagEffect(10102014,RESET_EVENT+0x1fc0000+RESET_CHAIN,0,1)
	Duel.Release(tc,REASON_EFFECT+REASON_RELEASE)
end
function c10102014.repval(e,c)
	return c10102014.repfilter(c,e:GetHandlerPlayer())
end