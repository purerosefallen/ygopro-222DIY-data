--真幻量子守护者
if not pcall(function() require("expansions/script/c18007001") end) then require("script/c18007001") end
local m=18007009
local cm=_G["c"..m]
function cm.initial_effect(c)
	local e1,e2=rspq.FusionSummonFun(c,m,false,true,8,2)
	local e3=rspq.LeaveFieldFun(c,m)
	local e4=rsef.I(c,{m,0},1,"td","tg",LOCATION_MZONE,nil,nil,rstg.target({cm.tdfilter,"td",LOCATION_MZONE },rsop.list(Card.IsAbleToDeck,"td",0,LOCATION_HAND),rsop.list(Card.IsAbleToDeck,"td",0,LOCATION_ONFIELD),rsop.list(Card.IsAbleToDeck,"td",0,LOCATION_GRAVE)),cm.tdop)
end
cm.rssetcode="PhantomQuantum"
function cm.tdfilter(c)
	return c:IsAbleToDeck() and c:CheckSetCard("PhantomQuantum")
end
function cm.tdop(e,tp)
	local tc=rscf.GetTargetCard()
	if not tc or Duel.SendtoDeck(tc,nil,2,REASON_EFFECT)<=0 or not tc:IsLocation(LOCATION_DECK+LOCATION_EXTRA) then return end
	local loclist={LOCATION_HAND,LOCATION_ONFIELD,LOCATION_GRAVE }
	for _,loc in pairs(loclist) do
		if Duel.GetMatchingGroupCount(Card.IsAbleToDeck,tp,0,loc,nil)<=0 then return end
	end
	local tg=Group.CreateGroup()
	for _,loc in pairs(loclist) do
		local g=Duel.GetMatchingGroup(Card.IsAbleToDeck,tp,0,loc,nil)
		rsof.SelectHint(tp,"td")
		local tg2=g:Select(tp,1,1,nil)
		if loc~=LOCATION_HAND then
			Duel.HintSelection(tg2)
		end
		tg:Merge(tg2)
	end
	Duel.SendtoDeck(tg,nil,2,REASON_EFFECT)
end