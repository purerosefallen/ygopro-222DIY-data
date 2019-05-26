--心之怪盗团-换手
if not pcall(function() require("expansions/script/c15873611") end) then require("script/c15873611") end
local m=15873636
local cm=_G["c"..m]
function cm.initial_effect(c)
	rsphh.SetCode(c)  
	local e1=rsef.ACT(c,nil,nil,{1,m},"td,sp","tg",nil,nil,rstg.target({cm.tdfilter,"td",LOCATION_MZONE },rsop.list(cm.spfilter,"sp",LOCATION_DECK)),cm.activate)
end
function cm.tdfilter(c,e,tp)
	return rsphh.set(c) and c:IsFaceup() and c:IsAbleToDeck() and Duel.GetMZoneCount(tp,c,tp)>0
end
function cm.spfilter(c,e,tp,eg,ep,ev,re,r,rp,usingg)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false) and rsphh.set(c) and not c:IsCode(usingg:GetFirst():GetCode())
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=rscf.GetTargetCard()
	if not tc or Duel.SendtoDeck(tc,nil,2,REASON_EFFECT)<=0 or not tc:IsLocation(LOCATION_DECK+LOCATION_EXTRA) or Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	rsof.SelectHint(tp,"sp")
	local sg=Duel.SelectMatchingCard(tp,cm.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp,eg,ep,ev,re,r,rp,Group.FromCards(tc))
	if #sg>0 then
		rssf.SpecialSummon(sg)
	end
end