--幻之晶月辉印
function c65020069.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c65020069.target)
	e1:SetOperation(c65020069.activate)
	c:RegisterEffect(e1)
end
function c65020069.thfil(c)
	return c:IsSetCard(0x9da3) and c:IsAbleToGrave()
end
function c65020069.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c65020069.thfil,tp,LOCATION_DECK,0,1,nil) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsPlayerCanSpecialSummonMonster(tp,65020069,0,0x21,1900,500,4,RACE_PSYCHO,ATTRIBUTE_DARK) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c65020069.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.SelectMatchingCard(tp,c65020069.thfil,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 and Duel.SendtoGrave(g,REASON_EFFECT)~=0 then
	Duel.BreakEffect()
	if not c:IsRelateToEffect(e) or Duel.GetLocationCount(tp,LOCATION_MZONE)<=0
		or not Duel.IsPlayerCanSpecialSummonMonster(tp,65020069,0,0x21,1900,500,4,RACE_PSYCHO,ATTRIBUTE_DARK) then return end
	c:AddMonsterAttribute(TYPE_EFFECT+TYPE_TRAP)
	Duel.SpecialSummonStep(c,0,tp,tp,true,false,POS_FACEUP)
	 --Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(c65020069.con)
	e1:SetCost(c65020069.cost)
	e1:SetTarget(c65020069.linktg)
	e1:SetOperation(c65020069.linkop)
	c:RegisterEffect(e1,true)
	Duel.SpecialSummonComplete()
	end
end
function c65020069.con(e,tp,eg,ep,ev,re,r,rp)
	local ph=Duel.GetCurrentPhase()
	return Duel.GetTurnPlayer()~=tp and (ph==PHASE_MAIN1 or ph==PHASE_MAIN2)
end
function c65020069.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:GetFlagEffect(65020069)==0 end
	c:RegisterFlagEffect(65020069,RESET_CHAIN,0,1)
end
function c65020069.matfilter(c)
	return c:IsFaceup() 
end
function c65020069.lkfilter(c)
	return c:IsSetCard(0x9da3) and c:IsType(TYPE_LINK) and c:IsSpecialSummonable(SUMMON_TYPE_LINK)
end
function c65020069.linktg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local el={}
		local mg=Duel.GetMatchingGroup(c65020069.matfilter,tp,LOCATION_MZONE,0,nil)
		local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_MZONE,0,mg)
		for tc in aux.Next(g) do
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_CANNOT_BE_LINK_MATERIAL)
			tc:RegisterEffect(e1)
			table.insert(el,e1)
		end
		local res=Duel.IsExistingMatchingCard(c65020069.lkfilter,tp,LOCATION_EXTRA,0,1,nil)
		for _,e in ipairs(el) do
			e:Reset()
		end
		return res
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c65020069.linkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local el={}
	local mg=Duel.GetMatchingGroup(c65020069.matfilter,tp,LOCATION_MZONE,0,nil)
	local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_MZONE,0,mg)
	for tc in aux.Next(g) do
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CANNOT_BE_LINK_MATERIAL)
		tc:RegisterEffect(e1)
		table.insert(el,e1)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local xg=Duel.SelectMatchingCard(tp,c65020069.lkfilter,tp,LOCATION_EXTRA,0,1,1,nil)
	local tc=xg:GetFirst()
	if tc then
		Duel.SpecialSummonRule(tp,tc,SUMMON_TYPE_LINK)
	end
	for _,e in ipairs(el) do
		e:Reset()
	end
end