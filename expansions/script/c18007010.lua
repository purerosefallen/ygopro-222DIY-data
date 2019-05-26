--幻量子跃迁灵
if not pcall(function() require("expansions/script/c18007001") end) then require("script/c18007001") end
local m=18007010
local cm=_G["c"..m]
function cm.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,nil,2,2,cm.gf)
	local e1=rsef.I(c,{m,0},1,"td,sp","tg",LOCATION_MZONE,nil,nil,rstg.target({cm.tdfilter,"td",LOCATION_MZONE+LOCATION_GRAVE,0,2},rsop.list(cm.spfilter,"sp",LOCATION_DECK)),cm.tdop)
	local e2=rsef.FTO(c,EVENT_SPSUMMON_SUCCESS,{m,1},nil,nil,"de",LOCATION_MZONE,cm.imcon,nil,nil,cm.imop)
end
cm.rssetcode="PhantomQuantum"
function cm.gf(g)
	return g:GetClassCount(Card.GetRace)==#g
end
function cm.tdfilter(c,e,tp)
	return c:CheckSetCard("PhantomQuantum") and c:IsAbleToDeck() and c:IsType(TYPE_MONSTER) and Duel.GetMZoneCount(tp,c,tp)>0
end
function cm.spfilter(c,e,tp)
	return c:CheckSetCard("PhantomQuantum") and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function cm.tdop(e,tp)
	local g=rsgf.GetTargetGroup()
	if #g<=0 or Duel.SendtoDeck(g,nil,2,REASON_EFFECT)<=0 or not g:IsExists(Card.IsLocation,1,nil,LOCATION_DECK+LOCATION_EXTRA) then return end
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	rsof.SelectHint(tp,"sp")
	local sg=Duel.SelectMatchingCard(tp,cm.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	if #sg>0 then
		rssf.SpecialSummon(sg)
	end
end
function cm.cfilter(c,ec)
	if ec:GetSummonLocation()~=LOCATION_DECK then return false end
	if c:IsLocation(LOCATION_MZONE) then
		return ec:GetLinkedGroup():IsContains(c)
	else
		return bit.extract(ec:GetLinkedZone(c:GetPreviousControler()),c:GetPreviousSequence())~=0
	end
end
function cm.imcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(cm.cfilter,1,nil,e:GetHandler())
end
function cm.imop(e,tp)
	local e1=rsef.FV_INDESTRUCTABLE({e:GetHandler(),tp},"effect",aux.indoval,aux.TargetBoolFunction(rscf.CheckSetCard,"PhantomQuantum"),{LOCATION_ONFIELD,0},nil,rsreset.pend)
	local e2=rsef.FV_CANNOT_BE_TARGET({e:GetHandler(),tp},"effect",aux.tgoval,aux.TargetBoolFunction(rscf.CheckSetCard,"PhantomQuantum"),{LOCATION_ONFIELD,0},nil,rsreset.pend)
end
