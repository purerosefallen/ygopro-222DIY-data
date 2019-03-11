--模拟魂 虚饰
if not pcall(function() require("expansions/script/c18005001") end) then require("script/c18005001") end
local m=18005015
local cm=_G["c"..m]
cm.rssetcode="PseudoSoul"
function cm.initial_effect(c)
	aux.EnablePendulumAttribute(c)
	local e1=rsef.QO(c,nil,{m,0},1,"td",nil,LOCATION_PZONE,nil,rscost.cost2(cm.costfun,cm.cfilter,"th",LOCATION_ONFIELD),rstg.target(rsop.list(cm.tdfilter,"td",LOCATION_REMOVED)),cm.tdop)
end
function cm.cfilter(c)
	return c:IsFaceup() and c:IsAbleToHandAsCost() and c:CheckSetCard("PseudoSoul")
end
function cm.tdfilter(c)
	return c:IsFaceup() and c:IsAbleToDeck() and c:CheckSetCard("PseudoSoul")
end
function cm.costfun(g,e)
	e:SetLabelObject(g:GetFirst())
end
function cm.tdop(e,tp)
	local c=e:GetHandler()
	local tc=e:GetLabelObject()
	if (tc and tc==c) or c:IsRelateToEffect(e) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
		local tg=Duel.SelectMatchingCard(tp,cm.tdfilter,tp,LOCATION_REMOVED,0,1,1,nil)
		Duel.HintSelection(tg)
		Duel.SendtoDeck(tg,nil,2,REASON_EFFECT)
	end
end