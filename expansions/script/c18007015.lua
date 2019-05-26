--幻量子驱动
if not pcall(function() require("expansions/script/c18007001") end) then require("script/c18007001") end
local m=18007015
local cm=_G["c"..m]
function cm.initial_effect(c)
	local e1=rsef.ACT(c,nil,{m,0},nil,"td,sp","tg",nil,nil,rstg.target({cm.tdfilter1,"td",LOCATION_MZONE },{cm.tdfilter2,"td",LOCATION_MZONE },rsop.list(cm.spfilter,"sp",LOCATION_EXTRA)),cm.tdop)
end
cm.rssetcode="PhantomQuantum"
function cm.tdfilter1(c,e,tp)
	return c:CheckSetCard("PhantomQuantum") and c:IsFaceup() 
end
function cm.tdfilter2(c,e,tp,eg,ep,ev,re,r,rp,usingg)
	local g=rsgf.Mix2(usingg,c)
	return cm.tdfilter1(c,e,tp) and Duel.GetLocationCountFromEx(tp,tp,g)>0
end
function cm.spfilter(c,e,tp)
	return c:CheckSetCard("PhantomQuantum") and c:IsCanBeSpecialSummoned(e,0,tp,true,false)
end
function cm.tdop(e,tp)
	local g=rsgf.GetTargetGroup()
	if #g<=0 or Duel.SendtoDeck(g,nil,2,REASON_EFFECT)<=0 or not g:IsExists(Card.IsLocation,1,nil,LOCATION_DECK+LOCATION_EXTRA) or Duel.GetLocationCountFromEx(tp)<=0 then return end
	rsof.SelectHint(tp,"sp")
	local sg=Duel.SelectMatchingCard(tp,cm.spfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)
	if #sg>0 then 
		Duel.SpecialSummon(sg,0,tp,tp,true,false,POS_FACEUP) 
	end
end