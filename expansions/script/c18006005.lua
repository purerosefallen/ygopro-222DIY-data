--龙棋兵团 重装兵
if not pcall(function() require("expansions/script/c18006001") end) then require("script/c18006001") end
local m=18006005
local cm=_G["c"..m]
cm.rssetcode="DragonChessCorps"
function cm.initial_effect(c)
	local e1,e2,e3=rsdcc.NormalMonsterFunction(c)
	local e4=rsdcc.QuickEffectFunction(c,m,"sp",rstg.target(rsop.list(cm.cfilter,"sp",LOCATION_DECK)),cm.op)
end
function cm.cfilter(c,e,tp)
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and rsdcc.IsSet(c)
end
function cm.op(e,tp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,cm.cfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	if #g>0 then
		rssf.SpecialSummon(g)
	end
end