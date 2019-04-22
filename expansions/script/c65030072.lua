--终景见证·破
function c65030072.initial_effect(c)
	--act
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,65030072+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(c65030072.con)
	e1:SetTarget(c65030072.tg)
	e1:SetOperation(c65030072.op)
	c:RegisterEffect(e1)
end
function c65030072.cfilter(c)
	return c:IsFaceup() and c:IsCode(65030052)
end
function c65030072.con(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c65030072.cfilter,tp,LOCATION_FZONE,0,1,nil)
end
function c65030072.matfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x6da2)
end
function c65030072.lkfilter(c)
	return c:IsSetCard(0x6da2) and c:IsType(TYPE_LINK) and c:IsSpecialSummonable(SUMMON_TYPE_LINK)
end
function c65030072.synfilter(c)
	return c:IsSetCard(0x6da2) and c:IsType(TYPE_SYNCHRO) and c:IsSpecialSummonable(SUMMON_TYPE_SYNCHRO)
end
function c65030072.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	local b1=Duel.IsExistingMatchingCard(c65030072.lkfilter,tp,LOCATION_EXTRA,0,1,nil)
	local b2=Duel.IsExistingMatchingCard(c65030072.synfilter,tp,LOCATION_EXTRA,0,1,nil)
	if chk==0 then
		local el={}
		local eel={}
		local mg=Duel.GetMatchingGroup(c65030072.matfilter,tp,LOCATION_MZONE,0,nil)
		local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_MZONE,0,mg)
		for tc in aux.Next(g) do
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_CANNOT_BE_LINK_MATERIAL)
			tc:RegisterEffect(e1)
			table.insert(el,e1)
		end
		for tc in aux.Next(g) do
			local e2=Effect.CreateEffect(e:GetHandler())
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetCode(EFFECT_CANNOT_BE_SYNCHRO_MATERIAL)
			tc:RegisterEffect(e2)
			table.insert(eel,e2)
		end
		local res=b1 or b2
		for _,e in ipairs(el) do
			e:Reset()
		end
		for _,e in ipairs(eel) do
			e:Reset()
		end
		return res
	end
	local m=5
	if b1 and b2 then
		m=Duel.SelectOption(tp,aux.Stringid(65030072,0),aux.Stringid(65030072,1))
	elseif b1 then
		m=0
	elseif b2 then
		m=1
	end
	e:SetLabel(m)
	Duel.Hint(HINT_OPSELECTED,1-tp,aux.Stringid(65030072,m))
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c65030072.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local el={}
	local mg=Duel.GetMatchingGroup(c65030072.matfilter,tp,LOCATION_MZONE,0,nil)
	local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_MZONE,0,mg)
	local m=e:GetLabel()
	if m==0 then
		for tc in aux.Next(g) do
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_CANNOT_BE_LINK_MATERIAL)
			tc:RegisterEffect(e1)
			table.insert(el,e1)
		end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local xg=Duel.SelectMatchingCard(tp,c65030072.lkfilter,tp,LOCATION_EXTRA,0,1,1,nil)
		local tc=xg:GetFirst()
		if tc then
			Duel.SpecialSummonRule(tp,tc,SUMMON_TYPE_LINK)
		end
	elseif m==1 then
		for tc in aux.Next(g) do
			local e2=Effect.CreateEffect(c)
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetCode(EFFECT_CANNOT_BE_SYNCHRO_MATERIAL)
			tc:RegisterEffect(e2)
			table.insert(el,e2)
		end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local xg2=Duel.SelectMatchingCard(tp,c65030072.synfilter,tp,LOCATION_EXTRA,0,1,1,nil)
		local tc2=xg2:GetFirst()
		if tc2 then
			Duel.SpecialSummonRule(tp,tc2,SUMMON_TYPE_SYNCHRO)
		end
	end
	for _,e in ipairs(el) do
		e:Reset()
	end
	 if c:IsRelateToEffect(e) and c:IsCanTurnSet() then
		Duel.BreakEffect()
		c:CancelToGrave()
		Duel.ChangePosition(c,POS_FACEDOWN)
		Duel.RaiseEvent(c,EVENT_SSET,e,REASON_EFFECT,tp,tp,0)
	end
end