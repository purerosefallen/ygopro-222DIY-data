--幻量子风暴
if not pcall(function() require("expansions/script/c18007001") end) then require("script/c18007001") end
local m=18007012
local cm=_G["c"..m]
function cm.initial_effect(c)
	local e1=rsef.ACT(c,nil,{m,0},nil,"td",nil,nil,nil,rstg.target(rsop.list(cm.tdfilter,"td",LOCATION_HAND+LOCATION_MZONE)),cm.tdop)
	local e2=rsef.FV_REDIRECT(c,"tg",LOCATION_DECK,cm.tg,{LOCATION_MZONE,LOCATION_MZONE })
	local e3=rsef.QO(c,nil,{m,1},1,"sp","tg",LOCATION_FZONE,nil,nil,rstg.target({cm.tgfilter,nil,LOCATION_MZONE },rsop.list(cm.spfilter,"sp",LOCATION_DECK)),cm.spop)
end 
cm.rssetcode="PhantomQuantum"
function cm.tgfilter(c,e,tp)
	return c:GetSummonLocation()==LOCATION_DECK and c:GetTurnID()==Duel.GetTurnCount() and c:IsLevelAbove(2)
end
function cm.spfilter(c,e,tp,eg,ep,ev,re,r,rp,usingg)
	return c:CheckSetCard("PhantomQuantum") and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:GetLevel()<usingg:GetFirst():GetLevel()
end
function cm.spop(e,tp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local tc=rscf.GetTargetCard(Card.IsFaceup)
	if not tc then return end
	rsof.SelectHint(tp,"sp")
	local sg=Duel.SelectMatchingCard(tp,cm.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp,eg,ep,ev,re,r,rp,Group.FromCards(tc))
	if #sg>0 then
		rssf.SpecialSummon(sg)
	end
end
function cm.tg(e,c)
	return c:GetOriginalType()&TYPE_MONSTER ~=0
end
function cm.tdfilter(c)
	return c:CheckSetCard("PhantomQuantum") and c:IsAbleToDeck() and (c:IsLocation(LOCATION_HAND) or c:IsFaceup()) and c:IsType(TYPE_MONSTER)
end
function cm.tdop(e,tp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	rsof.SelectHint(tp,"td")
	local tg=Duel.SelectMatchingCard(tp,cm.tdfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,1,nil)
	if #tg<=0 then return end
	if tg:GetFirst():IsLocation(LOCATION_MZONE) then
		Duel.HintSelection(tg)
	else
		Duel.ConfirmCards(1-tp,tg)
	end
	Duel.SendtoDeck(tg,nil,2,REASON_EFFECT)
end