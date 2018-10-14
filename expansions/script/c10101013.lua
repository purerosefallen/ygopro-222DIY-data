--苍翼之子 时雨
function c10101013.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,nil,3,3,c10101013.lcheck)
	c:EnableReviveLimit()
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(10101013,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetRange(LOCATION_MZONE)
	e1:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_REMOVE)
	e1:SetCountLimit(1)
	e1:SetTarget(c10101013.sptg2)
	e1:SetOperation(c10101013.spop2)
	c:RegisterEffect(e1)
	--SpecialSummon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(10101013,3))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_REMOVE)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e2:SetTarget(c10101013.sptg)
	e2:SetOperation(c10101013.spop)
	c:RegisterEffect(e2)
	--banish
	local ge1=Effect.CreateEffect(c)
	ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	ge1:SetCode(EFFECT_SEND_REPLACE)
	ge1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	ge1:SetTarget(c10101013.reptg)
	ge1:SetValue(c10101013.repval)
	Duel.RegisterEffect(ge1,0)
	local g=Group.CreateGroup()
	g:KeepAlive()
	ge1:SetLabelObject(g)
end
function c10101013.sptg2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return eg:IsContains(chkc) and c10101013.cfilter(chkc,e,tp) end
	if chk==0 then return eg:IsExists(c10101013.cfilter,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=eg:FilterSelect(tp,c10101013.cfilter,1,1,nil,e,tp)
	Duel.SetTargetCard(g)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function c10101013.spop2(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c10101013.spfilter2,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil,e,tp,tc:GetCode())
	if g:GetCount()>0 then
		local tc=g:GetFirst()
		if tc and tc:IsAbleToHand() and (not tc:IsCanBeSpecialSummoned(e,0,tp,false,false) or Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 or not Duel.SelectYesNo(tp,aux.Stringid(10101013,0))) then
			Duel.SendtoHand(tc,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,tc)
		else
			Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
		end
	end
end
function c10101013.cfilter(c,e,tp)
	return c:IsFaceup() and c:IsCanBeEffectTarget(e) and Duel.IsExistingMatchingCard(c10101013.spfilter2,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil,e,tp,c:GetCode())
end
function c10101013.spfilter2(c,e,tp,code)
	return c:IsCode(code) and ((c:IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0) or c:IsAbleToHand())
end
function c10101013.spfilter(c,e,tp)
	return c:IsSetCard(0x6330) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c10101013.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return not Duel.IsPlayerAffectedByEffect(tp,59822133)
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>1
		and Duel.IsExistingMatchingCard(c10101013.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp)
		and Duel.IsExistingMatchingCard(c10101013.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,2,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function c10101013.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.IsPlayerAffectedByEffect(tp,59822133) then return end
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<2 then return end
	local g1=Duel.GetMatchingGroup(c10101013.spfilter,tp,LOCATION_DECK,0,nil,e,tp)
	local g2=Duel.GetMatchingGroup(aux.NecroValleyFilter(c10101013.spfilter),tp,LOCATION_GRAVE,0,nil,e,tp)
	if g1:GetCount()==0 or g2:GetCount()==0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sg1=g1:Select(tp,1,1,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sg2=g2:Select(tp,1,1,nil)
	sg1:Merge(sg2)
	Duel.SpecialSummon(sg1,0,tp,tp,false,false,POS_FACEUP)
end
function c10101013.lcheck(g,lc)
	return g:IsExists(Card.IsSetCard,1,nil,0x6330)
end
function c10101013.repfilter(c,rc)
	return c:GetDestination()==LOCATION_GRAVE and c:IsReason(REASON_MATERIAL) and c:IsReason(REASON_LINK) and c:GetReasonCard()==rc
end
function c10101013.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetOwner()
	local p=c:GetControler()
	if chk==0 then
	   return eg:IsExists(c10101013.repfilter,1,nil,c)
	end
	if not Duel.SelectYesNo(p,aux.Stringid(10101013,1)) then return false end
	local g=e:GetLabelObject()
	g:Clear()
	Duel.Hint(HINT_SELECTMSG,p,HINTMSG_REMOVE)
	local rg=eg:FilterSelect(p,c10101013.repfilter,1,2,nil,c)
	if Duel.Remove(rg,POS_FACEUP,REASON_MATERIAL+REASON_LINK)~=0 then
	   local pg=Duel.GetOperatedGroup()
	   g:Merge(pg)
	end
	return true
end
function c10101013.repval(e,c)
	return e:GetLabelObject():IsContains(c)
end
