--龙棋兵团 弩弓兵
if not pcall(function() require("expansions/script/c18006001") end) then require("script/c18006001") end
local m=18006002
local cm=_G["c"..m]
cm.rssetcode="DragonChessCorps"
function cm.initial_effect(c)
	local e1,e2,e3=rsdcc.NormalMonsterFunction(c)
	local e4=rsdcc.QuickEffectFunction(c,m,"des",rstg.target(rsop.list(cm.desfilter,"des",LOCATION_ONFIELD,LOCATION_ONFIELD)),cm.op)
end
function cm.desfilter(c,e)
	local cg=e:GetHandler():GetColumnGroup()
	return cg:IsContains(c) or c==e:GetHandler()
end
function cm.op(e,tp)
	local c=aux.ExceptThisCard(e)
	if not c then return end
	local g=c:GetColumnGroup()
	g:AddCard(c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local dg=g:Select(tp,1,1,nil)
	if #dg>0 then
		Duel.HintSelection(dg)
		Duel.Destroy(dg,REASON_EFFECT)
	end
end 