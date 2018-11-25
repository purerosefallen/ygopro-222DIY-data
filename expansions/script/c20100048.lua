--御刀术 无想西瓜割
local m=20100048
local cm=_G["c"..m]
function cm.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)	
end
function cm.filter(c,e,tp)
	return c:IsSetCard(0xc90) and c:IsLevel(3) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_DEFENSE,1-tp)
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(1-tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(cm.filter,tp,LOCATION_HAND,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
end
function cm.dfilter(c,seq)
	return math.abs(c:GetSequence()-seq)==1
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(1-tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,cm.filter,tp,LOCATION_HAND,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		if Duel.SpecialSummon(g,0,tp,1-tp,false,false,POS_FACEUP_DEFENSE) then
			Duel.BreakEffect()
			local tc=g:GetFirst()
			local dg=tc:GetColumnGroup():Filter(Card.IsControler,nil,1-tp)
			local seq=tc:GetSequence()
			local bdg=Duel.GetMatchingGroup(cm.dfilter,tp,0,LOCATION_MZONE,tc,seq)
			dg:Merge(bdg)
			local dc=Duel.Destroy(dg,REASON_EFFECT)
			if dc>1 and tc:IsAbleToHand() then Duel.SendtoHand(tc,nil,REASON_EFFECT) end
		end
	end
end