--幻量子转变
if not pcall(function() require("expansions/script/c18007001") end) then require("script/c18007001") end
local m=18007016
local cm=_G["c"..m]
function cm.initial_effect(c)
	local e1=rsef.ACT(c,nil,{m,0},nil,"dr","ptg",nil,rscost.cost(cm.cfilter,cm.fun,LOCATION_HAND+LOCATION_MZONE),cm.drtg,cm.drop)
	local e2=rsef.QO(c,nil,{m,1},nil,"sp",nil,LOCATION_GRAVE,cm.spcon,aux.bfgcost,rstg.target(rsop.list(cm.spfilter,"sp",LOCATION_DECK)),cm.spop)
end
cm.rssetcode="PhantomQuantum"
function cm.spcon(e,tp)
	return Duel.GetTurnPlayer()~=tp and Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)==0
end
function cm.spfilter(c,e,tp)
	return c:CheckSetCard("PhantomQuantum") and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_DEFENSE) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
end
function cm.spop(e,tp)
	rsof.SelectHint(tp,"sp")
	local sg=Duel.SelectMatchingCard(tp,cm.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	if #sg>0 then
		rssf.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP_DEFENSE,nil,rssf.SummonBuff(nil,nil,nil,nil,"td"))
	end
end 
function cm.fun(g,e,tp)
	local hg=g:Filter(Card.IsLocation,nil,LOCATION_HAND)
	if #hg>0 then
		Duel.ConfirmCards(1-tp,g)
	end
	Duel.SendtoDeck(g,nil,2,REASON_COST)
end
function cm.cfilter(c)
	return c:CheckSetCard("PhantomQuantum") and c:IsType(TYPE_MONSTER) and c:IsAbleToDeckAsCost()
end
function cm.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,2) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(2)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,2)
end
function cm.drop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end
