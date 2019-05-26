--心之怪盗团-面具切换
if not pcall(function() require("expansions/script/c15873611") end) then require("script/c15873611") end
local m=15873640
local cm=_G["c"..m]
function cm.initial_effect(c)
	rsphh.SetCode(c) 
	local e1=rsef.ACT(c,nil,nil,{1,m},"tg,sp","tg",rscon.excard(rscf.FilterFaceUp(rsphh.set),LOCATION_MZONE),nil,rstg.target2(cm.fun,{cm.tgfilter,"tg",LOCATION_MZONE }),cm.activate)
end
function cm.tgfilter(c,e,tp)
	return rsphh.set2(c) and c:IsAbleToGrave() and c:IsFaceup() and Duel.IsExistingMatchingCard(cm.spfilter,tp,LOCATION_DECK+LOCATION_EXTRA,0,1,nil,c,e,tp)
end
function cm.spfilter(c,tc,e,tp)
	return rsphh.set2(c) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and not c:IsCode(tc:GetCode()) and c:IsLevel(tc:GetLevel()) and ((c:IsLocation(LOCATION_EXTRA) and Duel.GetLocationCountFromEx(tp,tp,tc)>0) or (c:IsLocation(LOCATION_DECK) and Duel.GetMZoneCount(tp,tc,tp)>0))
end
function cm.fun(g,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,LOCATION_DECK+LOCATION_EXTRA)
end
function cm.activate(e,tp)
	local tc=rscf.GetTargetCard()
	if not tc or Duel.SendtoGrave(tc,REASON_EFFECT)<=0 or not tc:IsLocation(LOCATION_GRAVE) then return end
	rsof.SelectHint(tp,"sp")
	local sg=Duel.SelectMatchingCard(tp,cm.spfilter,tp,LOCATION_EXTRA+LOCATION_DECK,0,1,1,nil,tc,e,tp)
	if #sg>0 then
		rssf.SpecialSummon(sg)
	end
end