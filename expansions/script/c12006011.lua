--不知何时你将变成敌人
local m=12006011
local cm=_G["c"..m]
function cm.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DRAW+CATEGORY_SPECIAL_SUMMON)
	e2:SetDescription(aux.Stringid(m,1))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,m)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(cm.tdtg)
	e2:SetOperation(cm.tdop)
	c:RegisterEffect(e2)
end
function cm.MergeCard(g,p,loc,seq)
	local tc=Duel.GetFieldCard(p,loc,seq)
	if tc then
		g:AddCard(tc)
		return true
	else
		return false
	end
end
function cm.GetCrossGroup(p,seq)
	local zone=(0x0100 << seq) | (0x01010000 << 4-seq)
	if seq==1 then
		zone=zone | 0x00400020
	elseif seq==3 then
		zone=zone | 0x00200040
	end
	return Duel.GetCardsInZone(p,zone)
end
function cm.filter(c,e,tp,zones)
	return c:IsSetCard(0xfbd) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_ATTACK,1-tp,zones)
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		local res={}
		local zones=0
		for seq=0,4 do
			local g=cm.GetCrossGroup(1-tp,seq)
			if #g>0 then zones=zones | (0x1 << seq) end
		end
		return zones>0 and Duel.GetMZoneCount(1-tp,nil,tp,LOCATION_REASON_TOFIELD,zones)>0 and Duel.IsExistingMatchingCard(cm.filter,tp,LOCATION_DECK,0,1,nil,e,tp,zones)
	end
	local g=Group.CreateGroup()
	for seq=0,4 do
		local tg=cm.GetCrossGroup(1-tp,seq)
		if Duel.CheckLocation(1-tp,LOCATION_MZONE,seq) then g:Merge(tg) end
	end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,#g,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	if not cm.target(e,tp,eg,ep,ev,re,r,rp,0) then return end
	local zones=0
	for seq=0,4 do
		local g=cm.GetCrossGroup(1-tp,seq)
		if #g>0 then zones=zones | (0x1 << seq) end
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,cm.filter,tp,LOCATION_DECK,0,1,1,nil,e,tp,zones)
	local tc=g:GetFirst()
	if tc and Duel.SpecialSummon(tc,0,tp,1-tp,false,false,POS_FACEUP_ATTACK,zones)>0 then
		local dg=cm.GetCrossGroup(1-tp,tc:GetSequence())
		if #dg>0 then
			Duel.BreakEffect()
			Duel.Remove(dg,POS_FACEUP,REASON_EFFECT)
		end
	end
end
function cm.tdtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function cm.tdop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Draw(tp,1,REASON_EFFECT)
	local tc=Duel.GetOperatedGroup():GetFirst()
	if tc and tc:IsSetCard(0xfbd) and tc:IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.SelectYesNo(tp,m*16) then
		Duel.BreakEffect()
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	end
end