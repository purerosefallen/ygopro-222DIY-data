--心之怪盗团-Navi
if not pcall(function() require("expansions/script/c15873611") end) then require("script/c15873611") end
local m=15873617
local cm=_G["c"..m]
function cm.initial_effect(c)
	rsphh.SetCode(c)
	local e1=rsef.I(c,{m,0},{1,m},"se,th",nil,LOCATION_HAND,cm.con,rscost.cost({Card.IsDiscardable,nil},{Card.IsDiscardable,{"dish",cm.fun},LOCATION_HAND }),rstg.target(rsop.list(cm.thfilter,"th",LOCATION_DECK)),cm.thop)
	local e2=rsef.I(c,{m,1},{1,m},"atk,def,rec",nil,LOCATION_GRAVE,nil,aux.bfgcost,cm.target,cm.operation)
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetFieldGroup(tp,LOCATION_MZONE,LOCATION_MZONE)
	local g1=Duel.GetMatchingGroup(cm.cfilter,tp,LOCATION_MZONE,0,nil)
	if chk==0 then return #g>0 end
	local op=rsof.SelectOption(tp,#g1>0,{m,2},#g1>0,{m,3},#g>0,{m,4})
	if op==3 then
		e:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		Duel.SetTargetPlayer(tp)
		Duel.SetTargetParam(#g*300)
		Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,#g*300)
	else
		e:SetProperty(0)
	end
	e:SetLabel(op)
end
function cm.operation(e,tp)
	local c=e:GetHandler()
	local g=Duel.GetFieldGroup(tp,LOCATION_MZONE,0)
	local g1=Duel.GetMatchingGroup(cm.cfilter,tp,LOCATION_MZONE,0,nil)
	local op=e:GetLabel()
	local rct=1
	if Duel.GetTurnPlayer()~=tp then rct=2 end
	local reset={rsreset.est_pend+RESET_OPPO_TURN,rct}
	if op==1 then
		for tc in aux.Next(g1) do
			local e1,e2=rsef.SV_INDESTRUCTABLE({c,tc},"battle,effect",nil,nil,reset)
		end
	elseif op==2 then
		for tc in aux.Next(g1) do
			local e1,e2=rsef.SV_UPDATE({c,tc},"atk,def",#g*200,nil,reset)
		end
	else
		local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
		Duel.Recover(p,#g*300,REASON_EFFECT)
	end
end
function cm.cfilter(c)
	return c:IsFaceup() and (rsphh.set(c) or rsphh.set2(c))
end
function cm.con(e,tp)
	return Duel.GetFieldGroupCount(tp,LOCATION_ONFIELD,0)==0
end
function cm.fun(g,e,tp)
	g:AddCard(e:GetHandler())
	Duel.SendtoGrave(g,REASON_COST+REASON_DISCARD)
end
function cm.thfilter(c)
	return c:IsAbleToHand() and rsphh.set(c)
end
function cm.thop(e,tp)
	rsof.SelectHint(tp,"th")
	local tg=Duel.SelectMatchingCard(tp,cm.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if #tg>0 then
		Duel.SendtoHand(tg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tg)
	end
end