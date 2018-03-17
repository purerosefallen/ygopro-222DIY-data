--天选圣女 神圣之布伦希尔德
if not pcall(function() require("expansions/script/c10120001") end) then require("script/c10120001") end
local m=10120011
local cm=_G["c"..m]
function cm.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkSetCard,0x9331),2,2)
	c:EnableReviveLimit()
	dsrsv.DanceSpiritNegateEffect(c,m,CATEGORY_SPECIAL_SUMMON,cm.ntg,cm.nop)
	--SpecialSummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(10140015,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,m)
	e1:SetTarget(cm.sptg)
	e1:SetOperation(cm.spop)
	c:RegisterEffect(e1) 
	local e2=e1:Clone()
	e2:SetCode(EVENT_SUMMON_SUCCESS) 
	c:RegisterEffect(e2)
end
function cm.spfilter2(c,e,tp)
	return c:IsSetCard(0x9331) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_SYNCHRO,tp,false,false) and c:IsType(TYPE_SYNCHRO)
end
function cm.ntg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCountFromEx(tp)>0
		and Duel.IsExistingMatchingCard(cm.spfilter2,tp,LOCATION_EXTRA,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function cm.nop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCountFromEx(tp)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,cm.spfilter2,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)
	if g:GetCount()>0 and Duel.SpecialSummon(g,SUMMON_TYPE_SYNCHRO,tp,tp,false,false,POS_FACEUP)~=0 then
	   g:GetFirst():CompleteProcedure()
	end
end
function cm.spfilter(c,e,tp,zone,g)
	return c:IsSetCard(0x9331) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP,tp,zone) and not g:IsExists(Card.IsCode,1,nil,c:GetCode())
end
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local lg=e:GetHandler():GetLinkedGroup()
	local g=eg:Filter(cm.cfilter,nil,lg)
	if chk==0 then
		local zone=e:GetHandler():GetLinkedZone(tp)
		return zone~=0 and g:GetCount()>0 and Duel.IsExistingMatchingCard(cm.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp,zone,g)
	end
	Duel.SetTargetCard(g)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
	local zone=e:GetHandler():GetLinkedZone(tp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	if zone==0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,cm.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp,zone,g)
	if g:GetCount()>0 then
	   Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP,zone)
	end
end
function cm.cfilter(c,g)
	return c:IsFaceup() and g:IsContains(c) and c:IsSetCard(0x9331)
end
