--古记影狐 莫里
function c76121010.initial_effect(c)
	--link summon
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkSetCard,0xea1),2,2)
	--copy effect
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(76121010,0))
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetTarget(c76121010.cptg)
	e1:SetOperation(c76121010.cpop)
	c:RegisterEffect(e1)
	--spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,76121010)
	e2:SetCost(c76121010.spcost)
	e2:SetTarget(c76121010.sptg)
	e2:SetOperation(c76121010.spop)
	c:RegisterEffect(e2)
end
function c76121010.filter(c,e,tp,eg,ep,ev,re,r,rp)
	local te=c[c]
	if te and c:IsOriginalSetCard(0xea1) and c:IsType(TYPE_MONSTER) and c:IsLevelBelow(3) then 
		local tg=te:GetTarget()
		if tg and not tg(e,tp,eg,ep,ev,re,r,rp,0,nil,c) then return false end
		return true
	else return false end
end
function c76121010.cptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then
		local te=e:GetLabelObject()
		local tg=te:GetTarget()
		return tg and tg(e,tp,eg,ep,ev,re,r,rp,0,chkc)
	end
	if chk==0 then return Duel.IsExistingTarget(c76121010.filter,tp,LOCATION_ONFIELD+LOCATION_GRAVE,0,1,nil,e,tp,eg,ep,ev,re,r,rp) end
	e:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e:SetCategory(0)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SelectTarget(tp,c76121010.filter,tp,LOCATION_ONFIELD+LOCATION_GRAVE,0,1,1,nil,e,tp,eg,ep,ev,re,r,rp)
	local tc=g:GetFirst()
	local te=tc[tc]
	Duel.ClearTargetCard()
	e:SetCategory(te:GetCategory())
	e:SetProperty(te:GetProperty())
	e:SetLabel(te:GetLabel())
	e:SetLabelObject(te:GetLabelObject())
	local tg=te:GetTarget()
	if tg then tg(e,tp,eg,ep,ev,re,r,rp,1) end
	te:SetLabel(e:GetLabel())
	te:SetLabelObject(e:GetLabelObject())
	e:SetLabelObject(te)
end
function c76121010.cpop(e,tp,eg,ep,ev,re,r,rp)
	local te=e:GetLabelObject()
	if te:GetHandler():IsRelateToEffect(e) then
		e:SetLabel(te:GetLabel())
		e:SetLabelObject(te:GetLabelObject())
		local op=te:GetOperation()
		if op then op(e,tp,eg,ep,ev,re,r,rp) end
		te:SetLabel(e:GetLabel())
		te:SetLabelObject(e:GetLabelObject())
	end
end
function c76121010.cfilter(c,tp)
	return c:IsType(TYPE_SYNCHRO) and Duel.GetMZoneCount(tp,c)>0
end
function c76121010.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckReleaseGroup(tp,c76121010.cfilter,1,nil,tp) end
	local g=Duel.SelectReleaseGroup(tp,c76121010.cfilter,1,1,nil,tp)
	Duel.Release(g,REASON_COST)
end
function c76121010.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c76121010.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then 
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end