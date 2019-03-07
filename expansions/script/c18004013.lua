--性感手枪枪斗术
if not pcall(function() require("expansions/script/c18004001") end) then require("script/c18004001") end
local m=18004013
local cm=_G["c"..m]
cm.rssetcode="SexGun"
function cm.initial_effect(c)
	rssg.SexGunCode(c)   
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkCode,18004005),2,99,cm.lcheck)
	local e1=rsef.SV_INDESTRUCTABLE(c,"battle")
	local e2=rsef.SV(c,EFFECT_ATTACK_ALL,1,LOCATION_MZONE)
	local e3=rsef.STO(c,EVENT_BATTLE_START,{m,0},{1,m},"dr,des,rm",nil,nil,cm.cost,cm.tg,cm.op)
end
function cm.lcheck(g,lc)
	return g:IsExists(Card.IsType,1,nil,TYPE_TUNER)
end
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToDeck,tp,LOCATION_HAND,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,Card.IsAbleToDeck,tp,LOCATION_HAND,0,1,1,nil)
	Duel.SendtoDeck(g,nil,1,REASON_COST)
end
function cm.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	local bc=e:GetHandler():GetBattleTarget()
	if chk==0 then return Duel.IsPlayerCanDraw(tp) and bc end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)  
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	local bc=e:GetHandler():GetBattleTarget()
	local dp=bc:GetControler()
	local f=function(c,code)
		return c:IsAbleToRemove() and c:IsCode(code)
	end
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	if Duel.Draw(p,d,REASON_EFFECT)~=0 then
		local tc=Duel.GetOperatedGroup():GetFirst()
		Duel.ConfirmCards(1-tp,tc)
		Duel.BreakEffect()
		if tc:IsType(TYPE_MONSTER) and rssg.IsSexGun(tc) and bc:IsRelateToBattle() and Duel.Destroy(bc,REASON_EFFECT)>0 and tc:GetOriginalCode()==18004005 and Duel.IsExistingMatchingCard(f,dp,LOCATION_HAND+LOCATION_DECK+LOCATION_EXTRA+LOCATION_GRAVE,0,1,nil,bc:GetCode()) and Duel.SelectYesNo(tp,aux.Stringid(m,0)) then
			local sg=Duel.GetMatchingGroup(f,dp,LOCATION_HAND+LOCATION_DECK+LOCATION_EXTRA+LOCATION_GRAVE,0,nil)
			Duel.Remove(sg,POS_FACEUP,REASON_EFFECT)
		end
		Duel.ShuffleHand(tp)
	end
end