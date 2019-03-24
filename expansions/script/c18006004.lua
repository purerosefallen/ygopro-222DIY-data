--龙棋兵团 长枪兵
if not pcall(function() require("expansions/script/c18006001") end) then require("script/c18006001") end
local m=18006004
local cm=_G["c"..m]
cm.rssetcode="DragonChessCorps"
function cm.initial_effect(c)
	local e1,e2,e3=rsdcc.NormalMonsterFunction(c)
	local e4=rsdcc.QuickEffectFunction(c,m,nil,rstg.target(rsop.list(cm.cfilter,nil,LOCATION_DECK)),cm.op)
end
function cm.cfilter(c)
	return rsdcc.filter(c) and c:IsSSetable(true)
end
function cm.op(e,tp)
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local tc=Duel.SelectMatchingCard(tp,cm.cfilter,tp,LOCATION_DECK,0,1,1,nil):GetFirst()
	if tc then
		Duel.SSet(tp,tc)
		Duel.ConfirmCards(1-tp,tc)
	end
end