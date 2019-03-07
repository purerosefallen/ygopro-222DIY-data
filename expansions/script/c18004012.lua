--性感手枪快速装填
if not pcall(function() require("expansions/script/c18004001") end) then require("script/c18004001") end
local m=18004012
local cm=_G["c"..m]
cm.rssetcode="SexGun"
function cm.initial_effect(c)
	local e1=rsef.SV(c,EFFECT_QP_ACT_IN_SET_TURN,nil,nil,cm.con)
	local e2=rsef.ACT(c,nil,nil,{1,m,1},"td,dr,sp","tg",nil,nil,cm.tg,cm.op)	
end
function cm.con(e)
	return Duel.IsExistingMatchingCard(Card.IsCode,e:GetHandlerPlayer(),LOCATION_GRAVE,0,6,nil,18004005)
end
function cm.tg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local f=function(c)
		return c:IsCode(18004005) and c:IsAbleToDeck()
	end
	if chkc or chk==0 then return rstg.TargetCheck(e,tp,eg,ep,ev,re,r,rp,chk,chkc,{f,"td",LOCATION_GRAVE,0,1}) and Duel.IsPlayerCanDraw(tp,1) end
	rstg.TargetSelect(e,tp,eg,ep,ev,re,r,rp,{f,"td",LOCATION_GRAVE,0,1})
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,0,tp,LOCATION_HAND)
end
function cm.op(e,tp)
	local g=rsgf.GetTargetGroup()
	if #g<=0 or Duel.SendtoDeck(g,nil,1,REASON_EFFECT)<=0 then return end
	Duel.BreakEffect()
	if Duel.Draw(tp,1,REASON_EFFECT)~=0 then
		local tc=Duel.GetOperatedGroup():GetFirst()
		Duel.ConfirmCards(1-tp,tc)
		Duel.BreakEffect()
		if rssg.IsSexGun(tc) and tc:IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.SelectYesNo(tp,aux.Stringid(m,0)) then
			rssf.SpecialSummon(tc)
		end
		Duel.ShuffleHand(tp)
	end
end