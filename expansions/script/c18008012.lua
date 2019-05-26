--新干线回转调车
if not pcall(function() require("expansions/script/c18008001") end) then require("script/c18008001") end
local m=18008012
local cm=_G["c"..m]
function cm.initial_effect(c)
	local e1=rsef.ACT(c)
	local e2=rsef.QO(c,nil,{m,0},1,"dr,td",nil,LOCATION_SZONE,nil,rscost.cost(cm.rmfilter,{"rm",cm.fun},LOCATION_MZONE),rstg.target0(cm.cfun,cm.tfun,rsop.list(cm.tdfilter,"td",LOCATION_GRAVE+LOCATION_REMOVED)),cm.drop)
	local e3=rsef.SV_IMMUNE_EFFECT(c,nil,rssk.nmcon)
end
cm.rssetcode="Shinkansen"
function cm.cfun(e,tp)
	return Duel.IsPlayerCanDraw(tp,1)
end
function cm.tfun(g,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function cm.tdfilter(c)
	return c:IsAbleToDeck() and c:IsFaceup() and c:IsType(TYPE_MONSTER) and rssk.set(c)
end
function cm.drop(e,tp)
	local c=aux.ExceptThisCard(e)
	if not c then return end
	if Duel.Draw(tp,1,REASON_EFFECT)<=0 then return end
	rsof.SelectHint(tp,"td")
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(cm.tdfilter),tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil)
	if #g>0 then
		Duel.BreakEffect()
		Duel.HintSelection(g)
		Duel.SendtoDeck(g,nil,1,REASON_EFFECT)
	end
end
function cm.rmfilter(c)
	return rssk.set(c) and c:IsAbleToRemoveAsCost()
end
function cm.fun(g,e,tp)
	local tc=g:GetFirst()
	local c=e:GetHandler()
	if Duel.Remove(tc,POS_FACEUP,REASON_COST+REASON_TEMPORARY)~=0 then
		local ct=1
		if Duel.GetTurnPlayer()==tp then ct=2 end
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_PHASE+PHASE_END)
		e1:SetReset(RESET_PHASE+PHASE_END+RESET_SELF_TURN,ct)
		e1:SetLabelObject(tc)
		e1:SetCountLimit(1)
		e1:SetLabel(Duel.GetTurnCount())
		e1:SetCondition(cm.retcon)
		e1:SetOperation(cm.retop)
		Duel.RegisterEffect(e1,tp)
	end
end
function cm.retcon(e,tp)
	return Duel.GetTurnCount()~=e:GetLabel()
end
function cm.retop(e,tp,eg,ep,ev,re,r,rp)
	Duel.ReturnToField(e:GetLabelObject())
end