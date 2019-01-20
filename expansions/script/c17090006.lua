--ドラゴンナイツ
local m=17090006
local cm=_G["c"..m]
function cm.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,m+EFFECT_COUNT_CODE_OATH)
	e1:SetCost(cm.cost)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
end
function cm.IsVane(c)
	local m=_G["c"..c:GetCode()]
	return m and m.is_named_with_Vane
end
function cm.IsSiegfried(c)
	local m=_G["c"..c:GetCode()]
	return m and m.is_named_with_Siegfried
end
function cm.IsPercival(c)
	local m=_G["c"..c:GetCode()]
	return m and m.is_named_with_Percival
end
function cm.Vane(c)
	return c:IsType(TYPE_PENDULUM) and (c:IsCode(47500501) or cm.IsVane(c))
end
function cm.Siegfried(c)
	return c:IsType(TYPE_PENDULUM) and (c:IsCode(14000104,47548001,47500503,10120011) or cm.IsSiegfried(c))
end
function cm.Lancelot(c)
	return c:IsType(TYPE_PENDULUM) and c:IsSetCard(0xa8) 
end
function cm.Percival(c)
	return c:IsType(TYPE_PENDULUM) and (c:IsCode(17060925,47500507) or cm.IsPercival(c))
end
function cm.nmb(c)
	return c:IsCode(47500507,47548001,47500503,10120011,47500505,66547759,17060857,47550010)
end
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,nil) end
	Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD)
end
function cm.spfilter(c,e,tp)
	return (cm.Vane(c) or cm.Siegfried(c) or cm.Lancelot(c) or cm.Percival(c)) and c:IsCanBeSpecialSummoned(e,0,tp,true,false)
		and not Duel.IsExistingMatchingCard(Card.IsCode,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil,c:GetCode())
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local loc=0
		if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then loc=loc+LOCATION_DECK end
		if Duel.GetLocationCountFromEx(tp)>0 then loc=loc+LOCATION_EXTRA end
		return loc~=0 and Duel.IsExistingMatchingCard(cm.spfilter,tp,loc,0,1,nil,e,tp)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK+LOCATION_EXTRA)
end

function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	local loc=0
	if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then loc=loc+LOCATION_DECK end
	if Duel.GetLocationCountFromEx(tp)>0 then loc=loc+LOCATION_EXTRA end
	if loc==0 then return end
	local g=Duel.GetMatchingGroup(cm.spfilter,tp,loc,0,nil,e,tp)
	if g:GetCount()==0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g1=g:Select(tp,1,1,nil)
	Duel.SpecialSummon(g1,0,tp,tp,true,false,POS_FACEUP)
	local vc=g1:GetFirst()
	if vc:IsType(TYPE_XYZ) and cm.Siegfried(vc) then
		e:GetHandler():CancelToGrave()
		Duel.Overlay(vc,Group.FromCards(e:GetHandler()))
	end
	if Duel.IsPlayerAffectedByEffect(tp,59822133) then return end
	local t={cm.Vane,cm.Siegfried,cm.Lancelot,cm.Percival}
	for i=1,4 do
		if t[i](g1:GetFirst()) then g:Remove(t[i],nil) end
	if Duel.GetLocationCountFromEx(tp)==0 then g:Remove(cm.nmb,nil) end
	end
	if g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(m,0)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g2=g:Select(tp,1,1,nil)
		Duel.SpecialSummon(g2,0,tp,tp,true,false,POS_FACEUP)
		local tc=g2:GetFirst()
		if tc:IsType(TYPE_XYZ) and cm.Siegfried(tc) then
			e:GetHandler():CancelToGrave()
			Duel.Overlay(tc,Group.FromCards(e:GetHandler()))
		end
	end
end
