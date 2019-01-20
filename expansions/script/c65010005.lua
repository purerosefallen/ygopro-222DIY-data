--「02的反击」
if not pcall(function() require("expansions/script/c10199990") end) then require("script/c10199990") end
local m=65010005
local cm=_G["c"..m]
cm.card_code_list={65010001}
function cm.initial_effect(c)
	local f1=function(rc)
		return rc:IsFacedown() or not rc:IsCode(65010001)
	end
	local f2=function(rc,e,tp,re,rp)
		return not Duel.IsExistingMatchingCard(f1,tp,LOCATION_MZONE,0,1,nil)
	end
	local e1=rsef.ACT(c,EVENT_CHAINING,nil,nil,"neg,td,tg",nil,rscon.negcon(f2,true),nil,cm.tg,cm.op)
end
function cm.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return re:GetHandler():IsAbleToDeck() end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_TODECK,eg,1,0,0)
	end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
	if Duel.IsExistingMatchingCard(rscf.FilterFaceUp(Card.IsType,TYPE_NORMAL),tp,LOCATION_MZONE,0,1,nil) and not Duel.IsExistingMatchingCard(rscf.FilterFaceUp(Card.IsType,TYPE_NORMAL),tp,0,LOCATION_MZONE,1,nil) then
		Duel.SetChainLimit(cm.chainlimit)
	end
end
function cm.chainlimit(e,rp,tp)
	return tp==rp or not e:IsHasType(EFFECT_TYPE_ACTIVATE)
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	local f=function(c)
		return c:IsAbleToGrave() and c:IsCode(65010001)
	end 
	if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) and Duel.SendtoDeck(eg,nil,2,REASON_EFFECT)~=0 and Duel.IsExistingMatchingCard(f,tp,LOCATION_DECK,0,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(m,1)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local g=Duel.SelectMatchingCard(tp,f,tp,LOCATION_DECK,0,1,1,nil)
		Duel.SendtoGrave(g,REASON_EFFECT)
	end
end
